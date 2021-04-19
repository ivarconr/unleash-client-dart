import 'package:unleash/src/strategy.dart';

class DefaultStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters) {
    return true;
  }

  @override
  String get name => 'default';
}

class UnknownStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters) {
    return false;
  }

  @override
  String get name => 'unknown-strategy';
}
