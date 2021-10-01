import 'context.dart';

abstract class ActivationStrategy {
  bool isEnabled(Map<String, dynamic> parameters, Context? context);
  String get name;
}
