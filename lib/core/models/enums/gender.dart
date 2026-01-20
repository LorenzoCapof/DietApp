// lib/core/models/enums/gender.dart

/// Genere dell'utente per calcoli BMR
enum Gender {
  male,
  female;

  /// Display name localizzato
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Uomo';
      case Gender.female:
        return 'Donna';
    }
  }

  /// Serializzazione per storage
  String toJson() => name;

  /// Deserializzazione da storage
  static Gender fromJson(String json) {
    return Gender.values.firstWhere(
      (g) => g.name == json,
      orElse: () => Gender.male,
    );
  }
}