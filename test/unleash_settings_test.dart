import 'package:test/test.dart';
import 'package:unleash/src/unleash_settings.dart';

import 'test_utils.dart';

void main() {
  test('UnleashSettings.toHeader', () {
    final settings = UnleashSettings(
      appName: 'appname',
      instanceId: 'instanceid',
      unleashApi: Uri.parse('https://example.org/api'),
    );

    expect(settings.toHeaders(), <String, String>{
      'UNLEASH-APPNAME': 'appname',
      'UNLEASH-INSTANCEID': 'instanceid',
    });
  });

  test('test assertions', () {
    expect(() {
      UnleashSettings(
        appName: null,
        instanceId: 'instanceid',
        unleashApi: Uri.parse('https://example.org/api'),
      );
    }, throwsAssertionError);

    expect(() {
      UnleashSettings(
        appName: 'appname',
        instanceId: null,
        unleashApi: Uri.parse('https://example.org/api'),
      );
    }, throwsAssertionError);

    expect(() {
      UnleashSettings(
        appName: 'appname',
        instanceId: 'instanceid',
        unleashApi: null,
      );
    }, throwsAssertionError);
  });

  test('test urls', () {
    var settings = UnleashSettings(
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api'),
      instanceId: 'instance',
      appName: 'appname',
    );
    expect(settings.featureUrl,
        'https://unleash.herokuapp.com/api/client/features');
    expect(settings.registerUrl,
        'https://unleash.herokuapp.com/api/client/register');

    settings = UnleashSettings(
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api/'),
      instanceId: 'instance',
      appName: 'appname',
    );
    expect(settings.featureUrl,
        'https://unleash.herokuapp.com/api/client/features');
    expect(settings.registerUrl,
        'https://unleash.herokuapp.com/api/client/register');
  });
}
