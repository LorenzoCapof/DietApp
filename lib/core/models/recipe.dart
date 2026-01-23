enum RecipeCategory {
  meals,
  breakfast,
  snacks,
}

class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final int calories;
  final int? duration; // in minuti - solo per meals
  final RecipeCategory category;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.category,
    this.duration,
    this.isFavorite = false,
  });
}