import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:unleash/unleash.dart';

import 'test_utils.dart';

void main() {
  test('Unleash.init happy path', () async {
    final unleash = await Unleash.init(
      UnleashSettings(
        appName: 'test_app_name',
        instanceId: 'instance_id',
        unleashApi: Uri.parse('http://example.org/api'),
        pollingInterval: null,
      ),
      client: MockClient(happyMock),
    );

    expect(unleash.isEnabled('Demo'), false);
    expect(unleash.isEnabled('tasty-testy'), false);
    expect(unleash.isEnabled('tasty-truthy'), true);
    expect(unleash.isEnabled('foo'), true);
  });

  test('Unleash.isEnabled use default value', () async {
    final unleash = await Unleash.init(
      UnleashSettings(
          appName: 'test_app_name',
          instanceId: 'instance_id',
          unleashApi: Uri.parse('http://example.org/api')),
      client: MockClient(happyMock),
    );

    expect(unleash.isEnabled('foobar'), false);
    expect(unleash.isEnabled('foobar', defaultValue: true), true);
    expect(unleash.isEnabled('foobar', defaultValue: false), false);
  });

  test('Custom strategy', () async {
    final unleash = await Unleash.init(
      UnleashSettings(
          appName: 'test_app_name',
          instanceId: 'instance_id',
          unleashApi: Uri.parse('http://example.org/api'),
          strategies: [EnvironmentBased()]),
      client: MockClient(happyMock),
    );

    expect(unleash.isEnabled('featuristic'), true);
  });

  group('Unleash.getVariant', () {
    final spec = json.decode(testVariantsJson) as Map<String, dynamic>;
    final response = spec['state'] as Map<String, dynamic>;
    final tests = spec['variantTests'] as List;

    for (dynamic testData in tests) {
      runVariantTest(testData, json.encode(response));
    }
  });
}

void runVariantTest(dynamic testData, String response) async {
  _runVariantTest(
      testData['description'] as String,
      testData['context'] as Map<String, dynamic>?,
      testData['toggleName'] as String,
      testData['expectedResult'] as Map<String, dynamic>,
      response);
}

void _runVariantTest(
    String description,
    Map<String, dynamic>? context,
    String toggleName,
    Map<String, dynamic> expectedResult,
    String response) async {
  test(description, () async {
    final unleash = await Unleash.init(
        UnleashSettings(
            appName: 'test_app_name',
            instanceId: 'instance_id',
            unleashApi: Uri.parse('http://example.org/api')),
        client: MockClient((req) => happyMock(req,
            responseProvider: () async => Response(response, 200))),
        context: UnleashContext(
          userId: context?['userId'] as String?,
        ));

    final variant = unleash.getVariant(toggleName);
    expect(variant.name, expectedResult['name']);
    expect(variant.enabled, expectedResult['enabled']);
    expect(variant.payload?.type, expectedResult['payload']?['type']);
    expect(variant.payload?.value, expectedResult['payload']?['value']);
  });
}

Future<Response> _defaultResponseProvider() async =>
    Response(testFeatureToggleJson, 200);

/// This mock handler only sends valid responses.
/// Used to test the happy path.
Future<Response> happyMock(Request request,
    {Future<Response> Function() responseProvider =
        _defaultResponseProvider}) async {
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
    expect(body['strategies'], <dynamic>[]);
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

    return responseProvider();
  }
  fail('This should not be reached');
}

class EnvironmentBased implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters) {
    final environmentsStr = parameters['environment'] as String;
    final environments = environmentsStr.split(',');
    return environments.contains('production');
  }

  @override
  String get name => 'environmentBased';
}
