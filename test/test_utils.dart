import 'dart:convert';

import 'package:unleash/src/features.dart';
import 'package:unleash/src/strategy.dart';
import 'package:unleash/src/unleash_client.dart';

late final testFeatures = Features.fromJson(
    jsonDecode(testFeatureToggleJson) as Map<String, dynamic>);

// language=json
const testFeatureToggleJson = '''
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
         "name":"tasty-truthy",
         "description":"",
         "enabled":true,
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
      },
      {
         "name":"featuristic",
         "description":"bar",
         "enabled":true,
         "strategies":[
            {
               "name":"environmentBased",
               "parameters":{
                  "environment":"production"
               }
            }
         ],
         "variants":null,
         "createdAt":"2020-05-05T21:27:48.293Z"
      }
   ]
}
''';

class MockUnleashClient implements UnleashClient {
  @override
  Future<Features?> getFeatureToggles() {
    throw UnimplementedError();
  }

  @override
  Future<void> register(
      DateTime dateTime, List<ActivationStrategy> activationStrategies) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMetrics() {
    throw UnimplementedError();
  }
}
