import 'dart:async';

import 'package:unleash/unleash.dart';

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
      appName: 'debug',
      instanceId: 'Q8XiLix59zo2NytFGd1b',
      unleashApi:
          Uri.parse('https://gitlab.com/api/v4/feature_flags/unleash/18585314'),
    ),
    onUpdate: () {
      print('refreshed feature toggles');
    },
  );
  print(unleash.isEnabled('awesome_feature'));
  // wait some time so that toggles can be polled a few times
  // and dispose unleash at the end of it
  Timer(
    const Duration(seconds: 60),
    unleash.dispose,
  );
  print('finished');
}
