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
  });

  factory FeatureToggle.fromJson(Map<String, dynamic> json) {
    var strategies = <Strategy>[];
    if (json['strategies'] != null) {
      json['strategies'].forEach((dynamic v) {
        strategies.add(Strategy.fromJson(v as Map<String, dynamic>));
      });
    }

    return FeatureToggle(
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      strategies: strategies,
      strategy: json['strategy'] as String?,
    );
  }

  final String? name;
  final String? description;
  final bool? enabled;
  final List<Strategy>? strategies;
  final String? strategy;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (enabled != null) 'enabled': enabled,
      if (strategy != null) 'strategy': strategy,
      if (strategies?.isNotEmpty ?? false)
        'strategies': strategies?.map((e) => e.toJson()).toList(),
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
