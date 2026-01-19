import 'package:dietapp/core/models/nutrition.dart';

class FoodItem {
  final String id;
  final String name;
  final NutritionInfo nutrition;
  final double servingSize; // grammi
  final String? imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.nutrition,
    required this.servingSize,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nutrition': nutrition.toJson(),
    'servingSize': servingSize,
    'imageUrl': imageUrl,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'],
    name: json['name'],
    nutrition: NutritionInfo.fromJson(json['nutrition']),
    servingSize: json['servingSize'],
    imageUrl: json['imageUrl'],
  );
}