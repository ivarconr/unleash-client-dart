/// See https://unleash.github.io/docs/api/client/features
class Features {
  Features({this.version, this.features});

  factory Features.fromJson(Map<String, dynamic> json) {
    var features = <Feature>[];
    if (json['features'] != null) {
      features = <Feature>[];
      json['features'].forEach((Map v) {
        features.add(Feature.fromJson(v));
      });
    }

    return Features(
      version: json['version'] as int,
      features: features,
    );
  }

  final int version;
  final List<Feature> features;
}

class Feature {
  Feature({
    this.name,
    this.description,
    this.enabled,
    this.strategies,
    this.strategy,
  });

  factory Feature.fromJson(Map json) {
    var strategies = <Strategies>[];
    if (json['strategies'] != null) {
      strategies = <Strategies>[];
      json['strategies'].forEach((Map v) {
        strategies.add(Strategies.fromJson(v));
      });
    }

    return Feature(
      name: json['name'] as String,
      description: json['description'] as String,
      enabled: json['enabled'] as bool,
      strategies: strategies,
      strategy: json['strategy'] as String,
    );
  }

  String name;
  String description;
  bool enabled;
  List<Strategies> strategies;
  String strategy;
}

class Strategies {
  Strategies({this.name, this.parameters});

  factory Strategies.fromJson(Map json) {
    return Strategies(
      name: json['name'] as String,
      parameters: json['parameters'] != null ? json['parameters'] as Map : null,
    );
  }

  String name;
  Map parameters;
}
