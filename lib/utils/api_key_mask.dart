/// Masks an API key for secure display (e.g., `sk-or-v1-abc...1234`).
String maskApiKey(String key) {
  if (key.length <= 8) {
    return '****';
  }
  final prefix = key.substring(0, 8);
  final suffix = key.substring(key.length - 4);
  return '$prefix...$suffix';
}
