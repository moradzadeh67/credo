/// The two kinds of OpenRouter keys Credo can work with.
enum KeyType {
  /// A standard key used to call chat/completion endpoints.
  /// It exposes per-key limits and usage through `/api/v1/key`.
  inference,

  /// An administrative key. Required to read account-wide credit totals
  /// through `/api/v1/credits`.
  management;

  /// Value persisted in secure storage.
  String get storageValue => name;

  /// Human readable title.
  String get title => switch (this) {
    KeyType.inference => 'Inference Key',
    KeyType.management => 'Management Key',
  };

  /// Short explanation shown to the user.
  String get description => switch (this) {
    KeyType.inference =>
      'Standard key for chat and completions. Shows this key\'s limits and usage.',
    KeyType.management => 'Administrative key. Required to read your account credit balance.',
  };

  /// Parses a persisted value, defaulting to [KeyType.inference].
  static KeyType fromStorage(String? value) {
    return KeyType.values.firstWhere((type) => type.name == value, orElse: () => KeyType.inference);
  }
}
