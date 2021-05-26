import 'dart:math';

import 'package:murmurhash/murmurhash.dart';
import 'package:unleash/src/context.dart';
import 'package:collection/collection.dart';

import 'features.dart';

class Variant {
  const Variant({required this.name, this.payload, required this.enabled});

  factory Variant.from(VariantDefinition variantDefinition) {
    return Variant(
      name: variantDefinition.name,
      payload: variantDefinition.payload,
      enabled: true,
    );
  }

  final String name;
  final Payload? payload;
  final bool enabled;

  static const disabledVariant = Variant(name: 'disabled', enabled: false);
}

class VariantDefinition {
  VariantDefinition(
      {required this.name, required this.weight, this.payload, this.overrides});

  factory VariantDefinition.fromJson(Map json) {
    final overrides = <VariantOverride>[];
    if (json['overrides'] != null) {
      json['overrides'].forEach((dynamic override) {
        overrides.add(VariantOverride.fromJson(override as Map));
      });
    }

    return VariantDefinition(
      name: json['name'] as String,
      weight: json['weight'] as int,
      payload: json['payload'] != null
          ? Payload.fromJson(json['payload'] as Map)
          : null,
      overrides: overrides,
    );
  }

  final String name;
  final int weight;
  final Payload? payload;
  final List<VariantOverride>? overrides;
}

class Payload {
  Payload({required this.type, this.value});

  factory Payload.fromJson(Map json) {
    return Payload(
        type: json['type'] as String, value: json['value'] as String?);
  }

  final String type;
  final String? value;
}

class VariantOverride {
  VariantOverride({required this.contextName, required this.values});

  factory VariantOverride.fromJson(Map json) {
    final values = <String>[];
    if (json['values'] != null) {
      json['values'].forEach((dynamic value) {
        values.add(value as String);
      });
    }

    return VariantOverride(
      contextName: json['contextName'] as String,
      values: values,
    );
  }

  final String contextName;
  final List<String> values;
}

// utils
Variant selectVariant(FeatureToggle? featureToggle, UnleashContext context,
    Variant defaultVariant) {
  if (featureToggle == null) {
    return defaultVariant;
  }

  final variants = featureToggle.variants ?? List.empty();
  final totalWeight =
      variants.fold(0, (int prev, variant) => prev + variant.weight);
  if (totalWeight == 0) {
    return defaultVariant;
  }

  final variantOverride = getOverride(variants, context);
  if (variantOverride != null) {
    return Variant.from(variantOverride);
  }

  final target = getNormalizedNumber(
      getIdentifier(context), featureToggle.name!,
      normalizer: totalWeight);

  var counter = 0;
  for (var definition in variants) {
    if (definition.weight != 0) {
      counter += definition.weight;
    }
    if (counter >= target) {
      return Variant.from(definition);
    }
  }

  return defaultVariant;
}

String getIdentifier(UnleashContext context) =>
    context.userId ??
    context.sessionId ??
    context.remoteAddress ??
    Random().nextDouble().toString();

VariantDefinition? getOverride(
        List<VariantDefinition> variants, UnleashContext context) =>
    variants.firstWhereOrNull((variant) =>
        variant.overrides
            ?.any((override) => overrideMatchesContext(override, context)) ??
        false);

bool overrideMatchesContext(VariantOverride override, UnleashContext context) =>
    override.values
        .contains(getContextValue(override.contextName, context) ?? '');

String? getContextValue(String contextName, UnleashContext context) {
  switch (contextName) {
    case 'userId':
      return context.userId;
    case 'sessionId':
      return context.sessionId;
    case 'remoteAddress':
      return context.remoteAddress;
    default:
      return context.properties?[contextName];
  }
}

int getNormalizedNumber(String identifier, String name,
    {int normalizer = 100}) {
  final hash = MurmurHash.v3('$name:$identifier', 0);
  return (hash % normalizer) + 1;
}
