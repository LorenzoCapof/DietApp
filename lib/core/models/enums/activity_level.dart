// lib/core/models/enums/activity_level.dart

/// Livello di attività fisica dell'utente per calcolo TDEE
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive;

  /// Display name localizzato
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentario';
      case ActivityLevel.lightlyActive:
        return 'Leggermente attivo';
      case ActivityLevel.moderatelyActive:
        return 'Moderatamente attivo';
      case ActivityLevel.veryActive:
        return 'Molto attivo';
      case ActivityLevel.extraActive:
        return 'Estremamente attivo';
    }
  }

  /// Descrizione del livello
  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Poco o nessun esercizio';
      case ActivityLevel.lightlyActive:
        return 'Esercizio leggero 1-3 giorni/settimana';
      case ActivityLevel.moderatelyActive:
        return 'Esercizio moderato 3-5 giorni/settimana';
      case ActivityLevel.veryActive:
        return 'Esercizio intenso 6-7 giorni/settimana';
      case ActivityLevel.extraActive:
        return 'Esercizio molto intenso o lavoro fisico';
    }
  }

  /// Fattore moltiplicativo per TDEE
  double get factor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  /// Serializzazione per storage
  String toJson() => name;

  /// Deserializzazione da storage
  static ActivityLevel fromJson(String json) {
    return ActivityLevel.values.firstWhere(
      (a) => a.name == json,
      orElse: () => ActivityLevel.sedentary,
    );
  }
}