abstract class ActivationStrategy {
  bool isEnabled(Map<String, dynamic> parameters);
  String get name;
}
