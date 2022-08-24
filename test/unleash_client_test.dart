import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/src/unleash_client.dart';
import 'package:unleash/unleash.dart';

void main() {
  late Fixture fixture;

  setUp(() {
    fixture = Fixture();
  });

  test('register successfully', () async {
    var callbackCalled = false;
    final client = fixture.getSut((request) async {
      expect(request.url, Uri.parse('https://example.org/api/client/register'));
      expect(request.method, 'POST');
      expect(request.headers, {
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': '123456789',
        'UNLEASH-APPNAME': 'foo',
        'UNLEASH-INSTANCEID': 'bar',
      });

      final register =
          Register.fromJson(jsonDecode(request.body) as Map<String, dynamic>);

      expect(register.appName, 'foo');
      expect(register.instanceId, 'bar');
      expect(register.started, DateTime(2021, 01, 01, 01, 01).toUtc());

      callbackCalled = true;
      return Response('', 200);
    });

    await client.register(DateTime(2021, 01, 01, 01, 01), []);

    expect(callbackCalled, isTrue);
  });

  test('register does not throw on failing request', () async {
    final client = fixture.getSut((request) async {
      throw Exception();
    });
    await client.register(DateTime(2021, 01, 01, 01, 01), []);
    expect(1, 1);
  });

  test('getFeatureToggles returns null on failing request', () async {
    final client = fixture.getSut((request) async {
      throw Exception();
    });
    final features = await client.getFeatureToggles();
    expect(features, null);
  });
}

class Fixture {
  UnleashClient getSut(MockClientHandler handler) {
    return UnleashClient(
      settings: UnleashSettings(
        apiToken: '123456789',
        appName: 'foo',
        instanceId: 'bar',
        unleashApi: Uri.parse('https://example.org/api'),
      ),
      client: MockClient(handler),
    );
  }
}
