// lib/core/models/enums/diet_type.dart

/// Tipi di dieta disponibili
enum DietType {
  noDiet,
  mediterranean,
  vegetarian,
  vegan,
  paleo,
  keto,
  lowCarb,
  intermittentFasting,
  dukan,
  zone,
  dash,
  flexitarian,
  wholeFoods,
  glutenFree,
  lowFat,
  pescatarian;

  String get displayName {
    switch (this) {
      case DietType.noDiet:
        return 'Nessuna dieta specifica';
      case DietType.mediterranean:
        return 'Dieta Mediterranea';
      case DietType.vegetarian:
        return 'Dieta Vegetariana';
      case DietType.vegan:
        return 'Dieta Vegana';
      case DietType.paleo:
        return 'Dieta Paleo';
      case DietType.keto:
        return 'Dieta Chetogenica (Keto)';
      case DietType.lowCarb:
        return 'Dieta Low Carb';
      case DietType.intermittentFasting:
        return 'Digiuno Intermittente';
      case DietType.dukan:
        return 'Dieta Dukan';
      case DietType.zone:
        return 'Dieta a Zona';
      case DietType.dash:
        return 'Dieta DASH';
      case DietType.flexitarian:
        return 'Dieta Flexitariana';
      case DietType.wholeFoods:
        return 'Whole Foods';
      case DietType.glutenFree:
        return 'Senza Glutine';
      case DietType.lowFat:
        return 'Dieta Low Fat';
      case DietType.pescatarian:
        return 'Dieta Pescetariana';
    }
  }

  String get description {
    switch (this) {
      case DietType.noDiet:
        return 'Alimentazione libera senza restrizioni particolari';
      case DietType.mediterranean:
        return 'Ricca di frutta, verdura, cereali integrali, pesce e olio d\'oliva. Promuove salute cardiovascolare';
      case DietType.vegetarian:
        return 'Esclude carne e pesce. Include latticini, uova e alimenti vegetali';
      case DietType.vegan:
        return 'Esclude tutti i prodotti di origine animale. Solo alimenti vegetali';
      case DietType.paleo:
        return 'Basata su alimenti non processati: carne, pesce, frutta, verdura, noci';
      case DietType.keto:
        return 'Bassissimi carboidrati, alto contenuto di grassi. Favorisce la chetosi';
      case DietType.lowCarb:
        return 'Ridotto apporto di carboidrati, aumenta proteine e grassi';
      case DietType.intermittentFasting:
        return 'Alterna periodi di digiuno e alimentazione. Migliora metabolismo';
      case DietType.dukan:
        return 'Iperproteica a basso contenuto di grassi e carboidrati. 4 fasi';
      case DietType.zone:
        return 'Bilancia 40% carboidrati, 30% proteine, 30% grassi ad ogni pasto';
      case DietType.dash:
        return 'Riduce sodio, previene ipertensione. Ricca di frutta e verdura';
      case DietType.flexitarian:
        return 'Prevalentemente vegetariana con occasionale consumo di carne';
      case DietType.wholeFoods:
        return 'Cibi integrali non processati. Elimina zuccheri e cibi raffinati';
      case DietType.glutenFree:
        return 'Esclude glutine. Necessaria per celiaci, utile per sensibilità';
      case DietType.lowFat:
        return 'Riduce grassi al 20-30% delle calorie. Favorisce perdita peso';
      case DietType.pescatarian:
        return 'Vegetariana con aggiunta di pesce e frutti di mare';
    }
  }

  String get benefits {
    switch (this) {
      case DietType.noDiet:
        return 'Flessibilità totale';
      case DietType.mediterranean:
        return 'Salute cuore, longevità';
      case DietType.vegetarian:
        return 'Riduce colesterolo';
      case DietType.vegan:
        return 'Peso sano, etica';
      case DietType.paleo:
        return 'Energia, digestione';
      case DietType.keto:
        return 'Perdita peso rapida';
      case DietType.lowCarb:
        return 'Controllo glicemia';
      case DietType.intermittentFasting:
        return 'Metabolismo, longevità';
      case DietType.dukan:
        return 'Dimagrimento veloce';
      case DietType.zone:
        return 'Equilibrio ormonale';
      case DietType.dash:
        return 'Pressione normale';
      case DietType.flexitarian:
        return 'Sostenibile, bilanciata';
      case DietType.wholeFoods:
        return 'Salute generale';
      case DietType.glutenFree:
        return 'Benessere intestinale';
      case DietType.lowFat:
        return 'Cuore sano';
      case DietType.pescatarian:
        return 'Omega-3, proteine';
    }
  }

  // Serialization
  String toJson() => name;

  static DietType fromJson(String json) {
    return DietType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => DietType.noDiet,
    );
  }
}