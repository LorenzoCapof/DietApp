// lib/core/models/consumed_product.dart

import 'package:dietapp/core/models/product.dart';
import 'package:dietapp/core/models/nutrition.dart';

/// Unità di misura per i prodotti
enum MeasurementUnit {
  grams,
  ml,
  pieces;

  String get displayName {
    switch (this) {
      case MeasurementUnit.grams:
        return 'g';
      case MeasurementUnit.ml:
        return 'ml';
      case MeasurementUnit.pieces:
        return 'pz';
    }
  }

  String get longName {
    switch (this) {
      case MeasurementUnit.grams:
        return 'grammi';
      case MeasurementUnit.ml:
        return 'millilitri';
      case MeasurementUnit.pieces:
        return 'pezzi';
    }
  }
}

/// Prodotto consumato con quantità specifica
/// Questo wrapper collega Product (dispensa) con FoodItem (nutrizione)
class ConsumedProduct {
  final String id; // ID univoco del consumed product
  final Product product; // Riferimento al prodotto
  final double quantity; // Quantità consumata
  final MeasurementUnit unit; // Unità di misura
  final DateTime addedAt; // Quando è stato aggiunto

  ConsumedProduct({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unit,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Nutrizione totale basata sulla quantità consumata
  /// TODO: Quando avremo il backend, calcolare in base ai dati nutrizionali reali
  /// Per ora usiamo una stima basata sulle calorie del prodotto
  NutritionInfo get totalNutrition {
    // Stima approssimativa per il mock
    // Assumiamo che le calorie siano per 100g/ml
    final multiplier = unit == MeasurementUnit.pieces 
        ? quantity // Per pezzi, moltiplichiamo direttamente
        : quantity / 100; // Per g/ml, dividiamo per 100
    
    final calories = product.calories * multiplier;
    
    // Distribuzione macro approssimativa (40% carbs, 30% protein, 30% fats)
    final carbsCalories = calories * 0.40;
    final proteinCalories = calories * 0.30;
    final fatsCalories = calories * 0.30;
    
    return NutritionInfo(
      calories: calories,
      carbs: carbsCalories / 4, // 1g carbs = 4 kcal
      protein: proteinCalories / 4, // 1g protein = 4 kcal
      fats: fatsCalories / 9, // 1g fat = 9 kcal
    );
  }

  /// Display della quantità con unità
  String get displayQuantity => '$quantity${unit.displayName}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': product.id,
    'productName': product.name, // Salviamo anche il nome per sicurezza
    'productBrand': product.brand,
    'productImageUrl': product.imageUrl,
    'productCalories': product.calories,
    'quantity': quantity,
    'unit': unit.name,
    'addedAt': addedAt.toIso8601String(),
  };

  factory ConsumedProduct.fromJson(Map<String, dynamic> json) {
    // Ricostruiamo il Product dai dati salvati
    final product = Product(
      id: json['productId'],
      name: json['productName'],
      brand: json['productBrand'],
      imageUrl: json['productImageUrl'],
      calories: json['productCalories'],
      category: ProductCategory.all, // Default category
    );

    return ConsumedProduct(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
      unit: MeasurementUnit.values.firstWhere(
        (e) => e.name == json['unit'],
      ),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  /// CopyWith per aggiornamenti immutabili
  ConsumedProduct copyWith({
    String? id,
    Product? product,
    double? quantity,
    MeasurementUnit? unit,
    DateTime? addedAt,
  }) {
    return ConsumedProduct(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
