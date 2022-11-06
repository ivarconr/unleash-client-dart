import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/unleash.dart';

/// Responsible for the communication with Unleash Server
class UnleashClient {
  UnleashClient({
    Client? client,
    required UnleashSettings settings,
  })  : _client = client ?? Client(),
        _settings = settings;

  final Client _client;
  final UnleashSettings _settings;

  /// Loads feature toggles from Unleash server
  Future<Features?> getFeatureToggles() async {
    try {
      final reponse = await _client.get(
        _settings.featureUrl,
        headers: _settings.toHeaders(),
      );
      final stringResponse = utf8.decode(reponse.bodyBytes);

      final response = Features.fromJson(
          json.decode(stringResponse) as Map<String, dynamic>);

      List<FeatureToggle>? features = response.features;

      _settings.fakeToggles?.forEach((e) {
        final index = features?.indexWhere((f) => f.name == e.name) ?? -1;

        if (index == -1) {
          features?.add(e);
        } else {
          features?[index] = e;
        }
      });

      return Features(
        version: response.version,
        features: features,
      );
    } catch (e, stackTrace) {
      log(
        'Could not load feature toggles from Unleash server.\n'
        'Please make sure your configuration is correct.',
        name: 'unleash',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Registers this applications
  Future<void> register(
    DateTime dateTime,
    List<ActivationStrategy> activationStrategies,
  ) async {
    final register = Register(
      appName: _settings.appName,
      instanceId: _settings.instanceId,
      interval: _settings.metricsReportingInterval?.inMilliseconds,
      strategies: activationStrategies.map((e) => e.name).toList(),
      started: dateTime,
    );

    try {
      final response = await _client.post(
        _settings.registerUrl,
        headers: {
          'Content-type': 'application/json',
          ..._settings.toHeaders(),
        },
        body: json.encode(register.toJson()),
      );
      if (response.statusCode >= 300) {
        log(
          'Could not register this unleash instance.\n'
          'Please make sure your configuration is correct.\n'
          'Error:\n'
          'HTTP status code: ${response.statusCode}\n'
          'HTTP response message: ${response.body}',
          name: 'unleash',
        );
      }
    } catch (e, stackTrace) {
      log(
        'Unleash: Could not register this unleash instance.\n'
        'Please make sure your configuration is correct.',
        name: 'unleash',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sends metrics to Unleash server
  Future<void> updateMetrics() async {}
}
