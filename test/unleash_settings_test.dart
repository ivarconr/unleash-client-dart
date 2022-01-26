import 'package:test/test.dart';
import 'package:unleash/src/unleash_settings.dart';

void main() {
  test('UnleashSettings.toHeader', () {
    final settings = UnleashSettings(
      appName: 'appname',
      instanceId: 'instanceid',
      unleashApi: Uri.parse('https://example.org/api'),
      apiToken: '',
    );

    expect(settings.toHeaders(), <String, String>{
      'UNLEASH-APPNAME': 'appname',
      'UNLEASH-INSTANCEID': 'instanceid',
      'Authorization': '',
    });
  });


  test('UnleashSettings.toHeader with custome headers', () {
    final settings = UnleashSettings(
      appName: 'appname',
      instanceId: 'instanceid',
      unleashApi: Uri.parse('https://example.org/api'),
      apiToken: '123',
      customHeaders: { 'X-CUSTOM': 'WORLD'}
    );

    expect(settings.toHeaders(), <String, String>{
      'UNLEASH-APPNAME': 'appname',
      'UNLEASH-INSTANCEID': 'instanceid',
      'Authorization': '123',
      'X-CUSTOM': 'WORLD',
    });
  });

  test('test urls', () {
    var settings = UnleashSettings(
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api'),
      instanceId: 'instance',
      appName: 'appname',
      apiToken: '',
    );
    expect(
      settings.featureUrl,
      Uri.parse('https://unleash.herokuapp.com/api/client/features'),
    );
    expect(
      settings.registerUrl,
      Uri.parse('https://unleash.herokuapp.com/api/client/register'),
    );

    settings = UnleashSettings(
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api/'),
      instanceId: 'instance',
      appName: 'appname',
      apiToken: '',
    );
    expect(
      settings.featureUrl,
      Uri.parse('https://unleash.herokuapp.com/api/client/features'),
    );
    expect(
      settings.registerUrl,
      Uri.parse('https://unleash.herokuapp.com/api/client/register'),
    );
  });
}
