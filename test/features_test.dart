import 'package:test/test.dart';
import 'package:unleash/src/features.dart';

void main() {
  group('Features ', () {
    test('Features.fromJson', () {
      final features = Features.fromJson(<String, dynamic>{
        'version': 1,
        'features': [
          <String, dynamic>{
            'name': 'example-feature',
            'description': 'example description',
            'enabled': false,
            'strategy': 'example-strategy',
            'strategies': [
              <String, dynamic>{
                'name': 'example-strategy',
                'parameters': <String, String>{'example': 'example'}
              },
            ],
            'variants': [
              <String, dynamic>{
                'name': 'example-variant',
                'weight': 500,
                'payload': <String, dynamic>{
                  'type': 'payload-type',
                  'value': 'payload-value',
                },
                'overrides': [
                  <String, dynamic>{
                    'contextName': 'example-contextName',
                    'values': ['override-value'],
                  },
                ],
              },
            ],
          }
        ],
      });

      // Features
      expect(features.version, 1);
      expect(features.features!.length, 1);

      // FeatureToggle
      final feature = features.features![0];
      expect(feature.name, 'example-feature');
      expect(feature.description, 'example description');
      expect(feature.enabled, false);
      expect(feature.strategy, 'example-strategy');
      expect(feature.strategies!.length, 1);

      // Strategy
      final strategy = feature.strategies![0];
      expect(strategy.name, 'example-strategy');
      expect(strategy.parameters!.length, 1);
      expect(strategy.parameters!['example'], 'example');

      // Variants
      final variant = feature.variants![0];
      expect(variant.name, 'example-variant');
      expect(variant.weight, 500);
      expect(variant.payload!.type, 'payload-type');
      expect(variant.payload!.value, 'payload-value');
      expect(variant.overrides!.length, 1);
      expect(variant.overrides![0].contextName, 'example-contextName');
      expect(variant.overrides![0].values[0], 'override-value');
    });
  });
}
