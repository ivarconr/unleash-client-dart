import 'dart:async';

import 'package:unleash/unleash.dart';

class MyStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters) {
    final minVersion = int.parse(parameters['minVersion'] as String);
    final environmentsStr = parameters['environments'] as String;
    final environments = environmentsStr.split(',');
    return 260 >= minVersion && environments.contains('production');
  }

  @override
  String name() {
    return 'mobileStrategy';
  }
}

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
      appName: 'debug',
      instanceId: 'Q8XiLix59zo2NytFGd1b',
      unleashApi: Uri.parse('http://localhost:8080/api'),
      pollingInterval: const Duration(seconds: 5),
      strategies: [MyStrategy()],
    ),
    onUpdate: () {
      print('refreshed feature toggles');
    },
  );

  Timer.periodic(const Duration(seconds: 1), (timer) {
    print(unleash.isEnabled('flutter-test'));
  });
}
