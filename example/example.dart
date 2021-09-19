import 'dart:async';

import 'package:unleash/unleash.dart';

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
        appName: 'debug',
        instanceId: 'Q8XiLix59zo2NytFGd1b',
        unleashApi: Uri.parse('https://unleash.herokuapp.com/api/'),
        apiToken:
            '3bd74da5b341d868443134377ba5d802ea1e6fa2d2a948276ade1f092bec8d92'),
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
