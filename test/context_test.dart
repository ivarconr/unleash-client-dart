import 'package:test/test.dart';
import 'package:unleash/src/context.dart';

void main() {
  test('$Context', () {
    final c = Context(
      remoteAddress: 'remote_address',
      sessionId: 'session',
      userId: 'user_id',
      properties: {'a': 'b'},
    );

    final copy = c.copyWith(
      remoteAddress: 'address',
      sessionId: 'new_session',
      userId: 'foo bar',
      properties: {'c': 'd'},
    );

    expect(copy.remoteAddress, 'address');
    expect(copy.sessionId, 'new_session');
    expect(copy.userId, 'foo bar');
    expect(copy.properties, {'c': 'd'});
  });
}
