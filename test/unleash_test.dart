import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:unleash/unleash.dart';

import 'test_utils.dart';

void main() {
  test('Unleash.init throws assertion error', () {
    expect(Unleash.init(null), throwsAssertionError);
  });

  test('Unleash.init happy path', () async {
    Future<Response> mockClientHandler(Request request) {
      final registerUri = Uri.parse('http://example.org/api/client/register');
      final featuresUri = Uri.parse('http://example.org/api/client/features');

      if (request.url == registerUri) {
        // HTTP method
        expect(request.method, 'POST');

        // body
        final body = json.decode(request.body) as Map;
        expect(body.length, 6);
        expect(body['appName'], 'test_app_name');
        expect(body['instanceId'], 'instance_id');
        expect(body.containsKey('sdkVersion'), true);
        expect(body['strategies'], null);
        expect(body.containsKey('started'), true);
        expect(body['interval'], 10000);

        return Future.value(Response('', 200));
      }

      if (request.url == featuresUri) {
        expect(request.method, 'GET');

        // headers as per https://unleash.github.io/docs/api/client/features
        expect(
          request.headers,
          <String, String>{
            'UNLEASH-APPNAME': 'test_app_name',
            'UNLEASH-INSTANCEID': 'instance_id',
          },
        );

        return Future.value(Response(testFeatures, 200));
      }
      return null;
    }

    final unleash = await Unleash.init(
      UnleashSettings(
          appName: 'test_app_name',
          instanceId: 'instance_id',
          unleashApi: Uri.parse('http://example.org/api')),
      client: MockClient(mockClientHandler),
    );

    expect(unleash.isEnabled('Demo'), true);
    expect(unleash.isEnabled('tasty-testy'), false);
    expect(unleash.isEnabled('foo'), true);
  });
}

// language=json
const testFeatures = '''
{
   "version":1,
   "features":[
      {
         "name":"Demo",
         "description":"",
         "enabled":true,
         "strategies":[
            {
               "name":"flexibleRollout",
               "parameters":{
                  "rollout":"60",
                  "stickiness":"default",
                  "groupId":"Demo"
               }
            }
         ],
         "variants":null,
         "createdAt":"2020-05-02T07:18:53.274Z"
      },
      {
         "name":"tasty-testy",
         "description":"",
         "enabled":false,
         "strategies":[
            {
               "name":"default"
            }
         ],
         "variants":null,
         "createdAt":"2020-05-09T19:00:26.698Z"
      },
      {
         "name":"foo",
         "description":"bar",
         "enabled":true,
         "strategies":[
            {
               "name":"default"
            },
            {
               "name":"gradualRolloutRandom",
               "parameters":{
                  "percentage":"71"
               }
            }
         ],
         "variants":null,
         "createdAt":"2020-05-05T21:27:48.293Z"
      }
   ]
}
''';
