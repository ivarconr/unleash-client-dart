import 'package:test/test.dart';
import 'package:unleash/src/context.dart';
import 'package:unleash/src/strategies.dart';

void main() {
  test('$DefaultStrategy', () {
    final strategy = DefaultStrategy();
    expect(strategy.name, 'default');
    expect(strategy.isEnabled(<String, dynamic>{}, null), isTrue);
  });

  test('$UnknownStrategy', () {
    final strategy = UnknownStrategy();
    expect(strategy.name, 'unknown');
    expect(strategy.isEnabled(<String, dynamic>{}, null), isFalse);
  });

  test('$UserIdStrategy', () {
    final strategy = UserIdStrategy();
    expect(strategy.name, 'userWithId');

    // no context -> false
    expect(strategy.isEnabled(<String, dynamic>{}, null), isFalse);

    // no context.userId -> false
    expect(strategy.isEnabled(<String, dynamic>{}, Context()), isFalse);

    // no userId in parameters -> false
    expect(strategy.isEnabled(<String, dynamic>{}, Context(userId: 'foo_bar')),
        isFalse);

    // no userId in parameters -> false
    expect(strategy.isEnabled(<String, dynamic>{}, Context(userId: 'foo_bar')),
        isFalse);

    // context.userId not in parameters -> false
    expect(
      strategy.isEnabled(
          <String, dynamic>{'userId': 'foo,bar'}, Context(userId: 'foo_bar')),
      isFalse,
    );

    // context.userId in parameters -> true
    expect(
      strategy.isEnabled(
          <String, dynamic>{'userId': 'foo_bar'}, Context(userId: 'foo_bar')),
      isFalse,
    );
  });
}
