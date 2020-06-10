import 'package:test/test.dart';

final Matcher throwsAssertionError = throwsA(isA<AssertionError>());

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
