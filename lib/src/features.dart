import 'variant.dart';

/// See https://unleash.github.io/docs/api/client/features
class Features {
  Features({this.version, this.features});

  factory Features.fromJson(Map<String, dynamic> json) {
    var features = <FeatureToggle>[];
    if (json['features'] != null) {
      features = <FeatureToggle>[];
      json['features'].forEach((dynamic v) {
        features.add(FeatureToggle.fromJson(v as Map));
      });
    }

    return Features(
      version: json['version'] as int?,
      features: features,
    );
  }

  final int? version;
  final List<FeatureToggle>? features;
}

class FeatureToggle {
  FeatureToggle({
    this.name,
    this.description,
    this.enabled,
    this.strategies,
    this.strategy,
    this.variants
  });

  factory FeatureToggle.fromJson(Map json) {
    var strategies = <Strategy>[];
    if (json['strategies'] != null) {
      strategies = <Strategy>[];
      json['strategies'].forEach((dynamic v) {
        strategies.add(Strategy.fromJson(v as Map));
      });
    }

    var variants = <VariantDefinition>[];
    if (json['variants'] != null) {
      json['variants'].forEach((dynamic v) {
        variants.add(VariantDefinition.fromJson(v as Map));
      });
    }

    return FeatureToggle(
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      strategies: strategies,
      strategy: json['strategy'] as String?,
      variants: variants,
    );
  }

  final String? name;
  final String? description;
  final bool? enabled;
  final List<Strategy>? strategies;
  final String? strategy;
  final List<VariantDefinition>? variants;
}

class Strategy {
  Strategy({this.name, this.parameters});

  factory Strategy.fromJson(Map json) {
    return Strategy(
      name: json['name'] as String?,
      parameters: json['parameters'] != null
          ? json['parameters'] as Map<String, dynamic>?
          : null,
    );
  }

  final String? name;
  final Map<String, dynamic>? parameters;
}
