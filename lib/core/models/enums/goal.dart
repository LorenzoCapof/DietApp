// lib/core/models/enums/goal.dart

/// Obiettivo nutrizionale dell'utente
enum Goal {
  loseWeight,
  maintain,
  gainWeight;

  /// Display name localizzato
  String get displayName {
    switch (this) {
      case Goal.loseWeight:
        return 'Perdere peso';
      case Goal.maintain:
        return 'Mantenere il peso';
      case Goal.gainWeight:
        return 'Aumentare massa';
    }
  }

  /// Descrizione dell'obiettivo
  String get description {
    switch (this) {
      case Goal.loseWeight:
        return 'Deficit calorico di ~500 kcal/giorno';
      case Goal.maintain:
        return 'Calorie di mantenimento';
      case Goal.gainWeight:
        return 'Surplus calorico di ~300 kcal/giorno';
    }
  }

  /// Icona rappresentativa
  String get icon {
    switch (this) {
      case Goal.loseWeight:
        return '📉';
      case Goal.maintain:
        return '⚖️';
      case Goal.gainWeight:
        return '📈';
    }
  }

  /// Modifica calorica giornaliera rispetto a TDEE
  int get calorieAdjustment {
    switch (this) {
      case Goal.loseWeight:
        return -500;
      case Goal.maintain:
        return 0;
      case Goal.gainWeight:
        return 300;
    }
  }

  /// Serializzazione per storage
  String toJson() => name;

  /// Deserializzazione da storage
  static Goal fromJson(String json) {
    return Goal.values.firstWhere(
      (g) => g.name == json,
      orElse: () => Goal.maintain,
    );
  }
}