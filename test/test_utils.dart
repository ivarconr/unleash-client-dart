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

const testVariantsJson = '''
{
  "name": "08-variants",
  "state": {
      "version": 1,
      "features": [
          {
              "name": "Feature.Variants.A",
              "description": "Enabled",
              "enabled": true,
              "strategies": [
                  {
                      "name": "default",
                      "parameters": {}
                  }
              ],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 1,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      }
                  }
              ]
          },
          {
              "name": "Feature.Variants.B",
              "description": "Enabled for user=123",
              "enabled": true,
              "strategies": [],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 1,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      }
                  },
                  {
                      "name": "variant2",
                      "weight": 1,
                      "payload": {
                          "type": "string",
                          "value": "val2"
                      }
                  }
              ]
          },
          {
              "name": "Feature.Variants.C",
              "description": "Testing three variants",
              "enabled": true,
              "strategies": [],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 33,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      }
                  },
                  {
                      "name": "variant2",
                      "weight": 33,
                      "payload": {
                          "type": "string",
                          "value": "val2"
                      }
                  },
                  {
                      "name": "variant3",
                      "weight": 33,
                      "payload": {
                          "type": "string",
                          "value": "val3"
                      }
                  }
              ]
          },
          {
              "name": "Feature.Variants.D",
              "description": "Variants with payload",
              "enabled": true,
              "strategies": [],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 1,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      }
                  },
                  {
                      "name": "variant2",
                      "weight": 49,
                      "payload": {
                          "type": "string",
                          "value": "val2"
                      }
                  },
                  {
                      "name": "variant3",
                      "weight": 50,
                      "payload": {
                          "type": "string",
                          "value": "val3"
                      }
                  }
              ]
          },
          {
              "name": "Feature.Variants.override.D",
              "description": "Variant with overrides",
              "enabled": true,
              "strategies": [],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 33,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      },
                      "overrides": [{
                          "contextName": "userId",
                          "values": ["132", "61"]
                      }]
                  },
                  {
                      "name": "variant2",
                      "weight": 33,
                      "payload": {
                          "type": "string",
                          "value": "val2"
                      }
                  },
                  {
                      "name": "variant3",
                      "weight": 34,
                      "payload": {
                          "type": "string",
                          "value": "val3"
                      }
                  }
              ]
          },
          {
              "name": "Feature.Variants.E",
              "description": "Enabled",
              "enabled": false,
              "strategies": [
                  {
                      "name": "default",
                      "parameters": {}
                  }
              ],
              "variants": [
                  {
                      "name": "variant1",
                      "weight": 1,
                      "payload": {
                          "type": "string",
                          "value": "val1"
                      }
                  }
              ]
          }
      ]
  },
  "variantTests": [
      {
          "description": "Feature.Variants.A should be enabled",
          "context": {
              "userId": "0"
          },
          "toggleName": "Feature.Variants.A",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.MissingToggle should be disabled missing toggle",
          "context": {},
          "toggleName": "Feature.Variants.MissingToggle",
          "expectedResult": {
              "name": "disabled",
              "enabled": false
          }
      },
      {
          "description": "Feature.Variants.B should be enabled for user 2",
          "context": {
              "userId": "2"
          },
          "toggleName": "Feature.Variants.B",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.B should be enabled for user 0",
          "context": {
              "userId": "0"
          },
          "toggleName": "Feature.Variants.B",
          "expectedResult": {
              "name": "variant2",
              "payload": {
                  "type": "string",
                  "value": "val2"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.C should return variant1",
          "context": {
              "userId": "315"
          },
          "toggleName": "Feature.Variants.C",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.C should return variant2",
          "context": {
              "userId": "320"
          },
          "toggleName": "Feature.Variants.C",
          "expectedResult": {
              "name": "variant2",
              "payload": {
                  "type": "string",
                  "value": "val2"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.C should return variant3",
          "context": {
              "userId": "729"
          },
          "toggleName": "Feature.Variants.C",
          "expectedResult": {
              "name": "variant3",
              "payload": {
                  "type": "string",
                  "value": "val3"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.D should return variant1",
          "context": {
              "userId": "367"
          },
          "toggleName": "Feature.Variants.D",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.D should return variant2",
          "context": {
              "userId": "31"
          },
          "toggleName": "Feature.Variants.D",
          "expectedResult": {
              "name": "variant2",
              "payload": {
                  "type": "string",
                  "value": "val2"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.D should return variant3",
          "context": {
              "userId": "19"
          },
          "toggleName": "Feature.Variants.D",
          "expectedResult": {
              "name": "variant3",
              "payload": {
                  "type": "string",
                  "value": "val3"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.override.D should return variant1 for user 132",
          "context": {
              "userId": "132"
          },
          "toggleName": "Feature.Variants.override.D",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.override.D should return variant1 for user 61",
          "context": {
              "userId": "61"
          },
          "toggleName": "Feature.Variants.override.D",
          "expectedResult": {
              "name": "variant1",
              "payload": {
                  "type": "string",
                  "value": "val1"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.override.D should return variant2 for user 82",
          "context": {
              "userId": "82"
          },
          "toggleName": "Feature.Variants.override.D",
          "expectedResult": {
              "name": "variant2",
              "payload": {
                  "type": "string",
                  "value": "val2"
              },
              "enabled": true
          }
      },
      {
          "description": "Feature.Variants.E should be disabled",
          "context": {
              "userId": "0"
          },
          "toggleName": "Feature.Variants.E",
          "expectedResult": {
              "name": "disabled",
              "enabled": false
          }
      }
  ]
}
''';
