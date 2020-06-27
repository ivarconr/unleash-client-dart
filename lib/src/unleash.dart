import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unleash/src/features.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/src/toggle_backup.dart';
import 'package:unleash/src/unleash_settings.dart';

typedef UpdateCallback = void Function();

class Unleash {
  Unleash._internal(this.settings, this._onUpdate);

  final UnleashSettings settings;
  final UpdateCallback _onUpdate;

  /// Collection of all available feature toggles
  Features _features;

  /// The client which is used by unleash to make the requests
  http.Client _client;

  /// This timer is responsible for starting a new request
  /// every time the given [UnleashSettings.pollingInterval] expired.
  Timer _togglePollingTimer;

  ToggleBackupRepository _backupRepository;

  /// Initializes an [Unleash] instance, registers it at the backend and
  /// starts to load the feature toggles.
  /// [settings] are used to specify the backend and various other settings.
  /// A [client] can be used for example to further configure http headers
  /// according to your needs.
  static Future<Unleash> init(
    UnleashSettings settings, {
    http.Client client,
    ReadBackup readBackup,
    WriteBackup writeBackup,
    UpdateCallback onUpdate,
  }) async {
    assert(settings != null);
    final unleash = Unleash._internal(settings, onUpdate)
      .._client = client ?? http.Client();
    if (writeBackup != null && readBackup != null) {
      unleash._backupRepository =
          ToggleBackupRepository(readBackup, writeBackup);
    }

    await unleash._register();
    await unleash._loadToggles();
    unleash._setTogglePollingTimer();
    return unleash;
  }

  bool isEnabled(String feature, {bool defaultValue = false}) {
    final defaultToggle = FeatureToggle(
      name: feature,
      strategies: null,
      description: null,
      enabled: defaultValue,
      strategy: null,
    );

    final featureToggle = _features.features.firstWhere(
      (toggle) => toggle.name == feature,
      orElse: () => defaultToggle,
    );
    return featureToggle.enabled;
  }

  /// Cancels all periodic actions of this Unleash instance
  void dispose() {
    _togglePollingTimer.cancel();
  }

  Future<void> _register() async {
    final register = Register(
      appName: settings.appName,
      instanceId: settings.instanceId,
      interval: settings.metricsReportingInterval.inMilliseconds,
      started: DateTime.now().toIso8601String(),
    );

    final response = await _client.post(
      settings.registerUrl,
      headers: {
        'Content-type': 'application/json',
        ...settings.toHeaders(),
      },
      body: json.encode(register.toJson()),
    );
    if (response != null && response.statusCode >= 300) {
      log(
        'Unleash: Could not register this unleash instance.\n'
        'Please make sure your configuration is correct.\n'
        'Error:\n'
        'HTTP status code: ${response.statusCode}\n'
        'HTTP response message: ${response.body}',
      );
    }
  }

  Future<void> _loadToggles() async {
    try {
      final reponse = await _client.get(
        settings.featureUrl,
        headers: settings.toHeaders(),
      );
      final stringResponse = utf8.decode(reponse.bodyBytes);
      await _backupRepository?.write(settings, stringResponse);
      _features = Features.fromJson(
          json.decode(stringResponse) as Map<String, dynamic>);
      _onUpdate?.call();
    } catch (_) {
      // TODO: Should there be some other form of error handling?
      _features = await _backupRepository?.load(settings);
    }
  }

  void _setTogglePollingTimer() {
    // disable polling if no pollingInterval is given
    if (settings.pollingInterval == null) {
      return;
    }
    _togglePollingTimer = Timer.periodic(settings.pollingInterval, (timer) {
      _loadToggles();
    });
  }
}
