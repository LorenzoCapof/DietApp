enum ProductCategory {
    recentlyAdded,
    all,
    best,
    favorites,
    shoppingList,
    expiring,
}

class Product {
    final String id;
    final String name;
    final String brand;
    final String imageUrl;
    final int calories;
    final ProductCategory category;
    final DateTime? expiryDate;
    final double? rating;
    final bool isFavorite;
    final bool inShoppingList;

    Product({
        required this.id,
        required this.name,
        required this.brand,
        required this.imageUrl,
        required this.calories,
        required this.category,
        
        this.expiryDate,
        this.rating,
        this.isFavorite = false,
        this.inShoppingList = false,
    });
}