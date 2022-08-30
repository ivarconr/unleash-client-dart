/// See https://unleash.github.io/docs/api/client/features
class Features {
  Features({this.version, this.features});

  factory Features.fromJson(Map<String, dynamic> json) {
    var features = <FeatureToggle>[];
    if (json['features'] != null) {
      json['features'].forEach((dynamic v) {
        features.add(FeatureToggle.fromJson(v as Map<String, dynamic>));
      });
    }

    return Features(
      version: json['version'] as int?,
      features: features,
    );
  }

  final int? version;
  final List<FeatureToggle>? features;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (version != null) 'version': version,
      if (features?.isNotEmpty ?? false)
        'features': features?.map((e) => e.toJson()).toList(),
    };
  }
}

class FeatureToggle {
  FeatureToggle({
    this.name,
    this.description,
    this.enabled,
    this.strategies,
    this.strategy,
    this.variants,
  });

  factory FeatureToggle.fromJson(Map<String, dynamic> json) {
    var strategies = <Strategy>[];
    if (json['strategies'] != null) {
      json['strategies'].forEach((dynamic v) {
        strategies.add(Strategy.fromJson(v as Map<String, dynamic>));
      });
    }

    var variants = <Variant>[];
    if (json['variants'] != null) {
      json['variants'].forEach((dynamic v) {
        variants.add(Variant.fromJson(v as Map<String, dynamic>));
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
  final List<Variant>? variants;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (enabled != null) 'enabled': enabled,
      if (strategy != null) 'strategy': strategy,
      if (strategies?.isNotEmpty ?? false)
        'strategies': strategies?.map((e) => e.toJson()).toList(),
      if (variants?.isNotEmpty ?? false)
        'variants': variants?.map((e) => e.toJson()).toList(),
    };
  }
}

class Strategy {
  Strategy({this.name, this.parameters});

  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      name: json['name'] as String?,
      parameters: json['parameters'] != null
          ? json['parameters'] as Map<String, dynamic>?
          : null,
    );
  }

  final String? name;
  final Map<String, dynamic>? parameters;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (parameters?.isNotEmpty ?? true) 'parameters': parameters,
    };
  }
}

class Variant {
  Variant({
    this.name,
    this.weight,
    this.weightType,
    this.stickiness,
    this.payload,
    this.overrides,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    VariantPayload? payload;
    if (json['payload'] != null) {
      payload =
          VariantPayload.fromJson(json['payload'] as Map<String, dynamic>);
    }

    return Variant(
      name: json['name'] as String?,
      weight: json['weight'] as int?,
      weightType: json['weightType'] as String?,
      stickiness: json['stickiness'] as String?,
      payload: payload,
      overrides: json['overrides'] as List<dynamic>?,
    );
  }

  final String? name;
  final int? weight;
  final String? weightType;
  final String? stickiness;
  final VariantPayload? payload;
  final List<dynamic>? overrides;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (weight != null) 'weight': weight,
      if (weightType != null) 'weightType': weightType,
      if (stickiness != null) 'stickiness': stickiness,
      if (payload != null) 'payload': payload,
      if (overrides != null) 'overrides': overrides,
    };
  }
}

class VariantPayload {
  VariantPayload({this.type, this.value});

  factory VariantPayload.fromJson(Map<String, dynamic> json) {
    return VariantPayload(
      type: json['type'] as String,
      value: json['value'] as String?,
    );
  }

  String? type;
  String? value;

  Map<String, String?> toJson() {
    return <String, String?>{
      if (type != null) 'type': type,
      if (value != null) 'value': value,
    };
  }
}
