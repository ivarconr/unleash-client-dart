import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unleash/src/features.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/src/unleash_settings.dart';

class Unleash {
  Unleash._internal(this.settings);

  final UnleashSettings settings;

  Features features;

  http.Client _client;

  /// Initializes an [Unleash] instance, registers it at the backend and
  /// starts to load the feature toggles.
  /// [settings] are used to specify the backend and various other settings.
  /// A [client] can be used for example to further configure http headers
  /// according to your needs.
  static Future<Unleash> init(
    UnleashSettings settings, {
    http.Client client,
  }) async {
    assert(settings != null);
    final unleash = Unleash._internal(settings)
      .._client = client ?? http.Client();
    await unleash._register();
    await unleash._loadToggles();
    return unleash;
  }

  Future<void> _register() async {
    final register = Register(
      appName: settings.appName,
      instanceId: settings.instanceId,
      interval: settings.metricsReportingInterval.inMilliseconds,
      started: DateTime.now().toIso8601String(),
    );

    try {
      final response = await _client.post(
        settings.registerUrl,
        headers: settings.toHeaders(),
        body: json.encode(register.toJson()),
      );
      if (response != null && response.statusCode != 200) {
        log(
          'Unleash: Could not register this unleash instance.\n'
          'Please make sure your configuration is correct.\n'
          'Error:\n'
          'HTTP status code: ${response.statusCode}\n'
          'HTTP response message: ${response.body}',
        );
      }
    } on SocketException catch (_) {
      log(
        'Unleash: Could not connect to server!\n'
        'Please make sure you have a connection to the internet.',
      );
    }
  }

  Future<void> _loadToggles() async {
    final reponse = await _client.get(
      settings.featureUrl,
      headers: settings.toHeaders(),
    );
    final stringResponse = utf8.decode(reponse.bodyBytes);
    features =
        Features.fromJson(json.decode(stringResponse) as Map<String, dynamic>);
  }

  bool isEnabled(String feature, {bool defaultValue = false}) {
    final defaultToggle = FeatureToggle(
      name: feature,
      strategies: null,
      description: null,
      enabled: defaultValue,
      strategy: null,
    );

    final featureToggle = features.features.firstWhere(
      (toggle) => toggle.name == feature,
      orElse: () => defaultToggle,
    );
    return featureToggle.enabled;
  }
}
