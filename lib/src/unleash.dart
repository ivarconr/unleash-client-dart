import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unleash/src/context.dart';
import 'package:unleash/src/features.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/src/strategies.dart';
import 'package:unleash/src/strategy.dart';
import 'package:unleash/src/toggle_backup.dart';
import 'package:unleash/src/unleash_settings.dart';
import 'package:unleash/unleash.dart';

import 'variant.dart';

typedef UpdateCallback = void Function();

class Unleash {
  Unleash._internal(this.settings, this._onUpdate, this._client, this._context);

  final UnleashSettings settings;
  final UpdateCallback? _onUpdate;
  final List<ActivationStrategy> _activationStrategies = [DefaultStrategy()];
  final UnleashContext _context;

  /// Collection of all available feature toggles
  Features? _features;

  /// The client which is used by unleash to make the requests
  final http.Client _client;

  /// This timer is responsible for starting a new request
  /// every time the given [UnleashSettings.pollingInterval] expired.
  Timer? _togglePollingTimer;

  ToggleBackupRepository? _backupRepository;

  /// Initializes an [Unleash] instance, registers it at the backend and
  /// starts to load the feature toggles.
  /// [settings] are used to specify the backend and various other settings.
  /// A [client] can be used for example to further configure http headers
  /// according to your needs.
  static Future<Unleash> init(UnleashSettings settings,
      {http.Client? client,
      ReadBackup? readBackup,
      WriteBackup? writeBackup,
      UpdateCallback? onUpdate,
      UnleashContext? context}) async {
    final unleash = Unleash._internal(
      settings,
      onUpdate,
      client ?? http.Client(),
      context ?? UnleashContext(),
    );
    if (writeBackup != null && readBackup != null) {
      unleash._backupRepository =
          ToggleBackupRepository(readBackup, writeBackup);
    }

    unleash._activationStrategies.addAll(settings.strategies ?? List.empty());

    await unleash._register();
    await unleash._loadToggles();
    unleash._setTogglePollingTimer();
    return unleash;
  }

  bool isEnabled(String toggleName, {bool defaultValue = false}) {
    final toggle = _getToggle(toggleName, defaultValue: defaultValue);
    final isEnabled = toggle.enabled ?? defaultValue;

    if (!isEnabled) {
      return false;
    }

    final strategies = toggle.strategies ?? List<Strategy>.empty();

    if (strategies.isEmpty) {
      return isEnabled;
    }

    for (final strategy in strategies) {
      final foundStrategy = _activationStrategies.firstWhere(
        (activationStrategy) => activationStrategy.name == strategy.name,
        orElse: () => UnknownStrategy(),
      );

      final parameters = strategy.parameters ?? <String, dynamic>{};

      if (foundStrategy.isEnabled(parameters)) {
        return true;
      }
    }

    return false;
  }

  /// Cancels all periodic actions of this Unleash instance
  void dispose() {
    _togglePollingTimer?.cancel();
  }

  Variant getVariant(String toggleName,
      {Variant defaultValue = Variant.disabledVariant}) {
    final toggle = _getToggle(toggleName);
    final isEnabled = toggle.enabled ?? false;

    if (!isEnabled) {
      return defaultValue;
    }

    return selectVariant(toggle, _context, defaultValue);
  }

  FeatureToggle _getToggle(String toggleName, {bool defaultValue = false}) {
    final defaultToggle = FeatureToggle(
      name: toggleName,
      strategies: null,
      description: null,
      enabled: defaultValue,
      strategy: null,
    );

    final featureToggle = _features?.features?.firstWhere(
      (toggle) => toggle.name == toggleName,
      orElse: () => defaultToggle,
    );

    return featureToggle ?? defaultToggle;
  }

  Future<void> _register() async {
    final register = Register(
      appName: settings.appName,
      instanceId: settings.instanceId,
      interval: settings.metricsReportingInterval?.inMilliseconds,
      strategies: _activationStrategies.map((e) => e.name).toList(),
      started: DateTime.now(),
    );

    try {
      final response = await _client.post(
        settings.registerUrl,
        headers: {
          'Content-type': 'application/json',
          ...settings.toHeaders(),
        },
        body: json.encode(register.toJson()),
      );
      if (response.statusCode >= 300) {
        log(
          'Unleash: Could not register this unleash instance.\n'
          'Please make sure your configuration is correct.\n'
          'Error:\n'
          'HTTP status code: ${response.statusCode}\n'
          'HTTP response message: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      log(
        'Unleash: Could not register this unleash instance.\n'
        'Please make sure your configuration is correct.\n'
        'Error:\n'
        '$e'
        ''
        '$stacktrace',
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
    _togglePollingTimer = Timer.periodic(settings.pollingInterval!, (timer) {
      _loadToggles();
    });
  }
}
