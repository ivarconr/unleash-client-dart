import 'package:unleash/unleashdart.dart';

Future<void> main() async {
  await Unleash.init(
    UnleashSettings(
      appName: '<appname>',
      instanceId: '<instanceid>',
      unleashApi: Uri.parse('<api_url>'),
    ),
  );
  print(Unleash.isEnabled('Awesome Feature'));
}
