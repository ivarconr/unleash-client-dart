import 'package:test/test.dart';
import 'package:unleash/unleash.dart';

import 'test_utils.dart';

void main() {
  test('Unleash.init throws assertion error', () {
    expect(Unleash.init(null), throwsAssertionError);
  });
}
