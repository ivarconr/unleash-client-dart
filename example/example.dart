import 'dart:async';

import 'package:unleash/unleash.dart';

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
        appName: 'debug',
        instanceId: 'Q8XiLix59zo2NytFGd1b',
        unleashApi: Uri.parse('https://unleash.herokuapp.com/api/'),
        apiToken:
            '*:development.ba76487db29d7ef2557977a25b477c2e6288e2d9334fd1b91f63e2a9'),
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
