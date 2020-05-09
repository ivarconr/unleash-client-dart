import 'package:unleash/unleash.dart';

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
      appName: '<appname>',
      instanceId: '<instanceid>',
      unleashApi: Uri.parse('<api_url>'),
    ),
  );
  print(unleash.isEnabled('Awesome Feature'));
}
