import 'package:unleash/src/context.dart';
import 'package:unleash/src/strategy.dart';

// See https://docs.getunleash.io/user_guide/activation_strategy

/// See https://docs.getunleash.io/user_guide/activation_strategy#standard
class DefaultStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters, Context? context) {
    return true;
  }

  @override
  String get name => 'default';
}

/// See https://docs.getunleash.io/user_guide/activation_strategy#userids
class UserIdStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters, Context? context) {
    if (context == null) {
      return false;
    }
    if (context.userId == null) {
      return false;
    }
    final users = parameters['userIds'] as String?;
    if (users == null) {
      return false;
    }
    return users.split(',').contains(context.userId);
  }

  @override
  String get name => 'userWithId';
}

class UnknownStrategy implements ActivationStrategy {
  @override
  bool isEnabled(Map<String, dynamic> parameters, Context? context) => false;

  @override
  String get name => 'unknown';
}
