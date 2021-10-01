import 'dart:async';

import 'package:unleash/unleash.dart';

class MyStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters, Context? context) {
    final minVersion = int.parse(parameters['minVersion'] as String);
    final environmentsStr = parameters['environments'] as String;
    final environments = environmentsStr.split(',');
    return 260 >= minVersion && environments.contains('production');
  }

  @override
  String get name => 'myStrategy';
}

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
      appName: 'debug',
      instanceId: 'Q8XiLix59zo2NytFGd1b',
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api/'),
      pollingInterval: const Duration(seconds: 5),
      strategies: [MyStrategy()],
      apiToken:
          '3bd74da5b341d868443134377ba5d802ea1e6fa2d2a948276ade1f092bec8d92',
    ),
    onUpdate: () {
      print('refreshed feature toggles');
    },
  );

  Timer.periodic(const Duration(seconds: 1), (timer) {
    print(unleash.isEnabled('flutter-test'));
  });
}
