import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:unleash/src/features.dart';
import 'package:unleash/src/strategies.dart';
import 'package:unleash/src/strategy.dart';
import 'package:unleash/src/unleash_client.dart';
import 'package:unleash/src/unleash_settings.dart';
import 'toggle_backup/toggle_backup.dart';

typedef UpdateCallback = void Function();

class Unleash {
  Unleash._internal(this.settings, this._onUpdate, this._unleashClient)
      : _backupRepository = ToggleBackup(settings);

  final UnleashClient _unleashClient;
  final UnleashSettings settings;
  final UpdateCallback? _onUpdate;
  final ToggleBackup _backupRepository;
  final List<ActivationStrategy> _activationStrategies = [
    DefaultStrategy(),
    UserIdStrategy(),
  ];

  /// Collection of all available feature toggles
  Features? _features;

  /// This timer is responsible for starting a new request
  /// every time the given [UnleashSettings.pollingInterval] expired.
  Timer? _togglePollingTimer;

  /// Initializes an [Unleash] instance, registers it at the backend and
  /// starts to load the feature toggles.
  /// [settings] are used to specify the backend and various other settings.
  /// A [client] can be used for example to further configure http headers
  /// according to your needs.
  static Future<Unleash> init(
    UnleashSettings settings, {
    UnleashClient? client,
    UpdateCallback? onUpdate,
  }) async {
    final unleash = Unleash._internal(
      settings,
      onUpdate,
      client ?? UnleashClient(settings: settings, client: http.Client()),
    );

    unleash._activationStrategies.addAll(settings.strategies ?? List.empty());

    await unleash._register();
    await unleash._loadToggles();
    unleash._setTogglePollingTimer();
    return unleash;
  }

  bool isEnabled(String toggleName, {bool defaultValue = false}) {
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

    final toggle = featureToggle ?? defaultToggle;
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

      if (foundStrategy.isEnabled(parameters, null)) {
        return true;
      }
    }

    return false;
  }

  /// Cancels all periodic actions of this Unleash instance
  void dispose() {
    _togglePollingTimer?.cancel();
  }

  Future<void> _register() {
    return _unleashClient.register(DateTime.now(), _activationStrategies);
  }

  Future<void> _loadToggles() async {
    final features = await _unleashClient.getFeatureToggles();

    if (features != null) {
      await _backupRepository.save(features);
      _onUpdate?.call();
      _features = features;
    } else {
      _features = await _backupRepository.load();
    }
  }

  void _setTogglePollingTimer() {
    final pollingInterval = settings.pollingInterval;
    // disable polling if no pollingInterval is given
    if (pollingInterval == null) {
      return;
    }
    _togglePollingTimer = Timer.periodic(pollingInterval, (timer) {
      _loadToggles();
    });
  }
}
