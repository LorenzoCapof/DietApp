// lib/core/repositories/mock_product_repository.dart

import 'dart:async';
import '../models/product.dart';
import 'product_repository.dart';

/// Implementazione MOCK del ProductRepository per sviluppo
/// Simula latenza di rete e fornisce dati fake realistici
/// 
/// NOTA: Questa classe sarà completamente sostituita quando il backend sarà pronto
class MockProductRepository implements ProductRepository {
  // Simula latenza di rete (300-600ms)
  static const _minDelay = Duration(milliseconds: 300);
  static const _maxDelay = Duration(milliseconds: 600);

  // Set di prodotti preferiti (in memoria)
  final Set<String> _favoriteIds = {};

  // Database mock di prodotti
  final List<Product> _mockProducts = [
    // Pasta e Cereali
    Product(
      id: 'prod_001',
      name: 'Pasta Integrale Penne',
      brand: 'Barilla',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
      calories: 350,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_002',
      name: 'Riso Basmati',
      brand: 'Scotti',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
      calories: 360,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_003',
      name: 'Avena Integrale',
      brand: 'Quaker',
      imageUrl: 'https://images.unsplash.com/photo-1574856344991-aaa31b6f4ce3?w=400',
      calories: 389,
      category: ProductCategory.best,
      rating: 4.8,
    ),

    // Latticini
    Product(
      id: 'prod_004',
      name: 'Latte Scremato',
      brand: 'Granarolo',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
      calories: 35,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_005',
      name: 'Yogurt Greco Naturale',
      brand: 'Fage',
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      calories: 97,
      category: ProductCategory.best,
      rating: 4.6,
    ),
    Product(
      id: 'prod_006',
      name: 'Mozzarella Bufala',
      brand: 'Galbani',
      imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400',
      calories: 280,
      category: ProductCategory.all,
    ),

    // Proteine
    Product(
      id: 'prod_007',
      name: 'Petto di Pollo',
      brand: 'AIA',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400',
      calories: 165,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_008',
      name: 'Tonno al Naturale',
      brand: 'Rio Mare',
      imageUrl: 'https://images.unsplash.com/photo-1625943553852-781c6dd46faa?w=400',
      calories: 116,
      category: ProductCategory.best,
      rating: 4.7,
    ),
    Product(
      id: 'prod_009',
      name: 'Uova Biologiche',
      brand: 'Cascina Italia',
      imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
      calories: 143,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_010',
      name: 'Salmone Affumicato',
      brand: 'Nostromo',
      imageUrl: 'https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?w=400',
      calories: 200,
      category: ProductCategory.all,
    ),

    // Frutta e Verdura
    Product(
      id: 'prod_011',
      name: 'Banane',
      brand: 'Dole',
      imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=400',
      calories: 89,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_012',
      name: 'Mele Golden',
      brand: 'Melinda',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      calories: 52,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_013',
      name: 'Broccoli Freschi',
      brand: 'Ortoromi',
      imageUrl: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400',
      calories: 34,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_014',
      name: 'Pomodori Ciliegino',
      brand: 'Pachino',
      imageUrl: 'https://images.unsplash.com/photo-1546470427-0ae30a1c9eff?w=400',
      calories: 18,
      category: ProductCategory.all,
    ),

    // Condimenti
    Product(
      id: 'prod_015',
      name: 'Olio Extra Vergine',
      brand: 'De Cecco',
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
      calories: 884,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_016',
      name: 'Miele Biologico',
      brand: 'Alce Nero',
      imageUrl: 'https://images.unsplash.com/photo-1555055926-c5778f87751e?w=400',
      calories: 304,
      category: ProductCategory.best,
      rating: 4.9,
    ),

    // Snack
    Product(
      id: 'prod_017',
      name: 'Mandorle Tostate',
      brand: 'Ventura',
      imageUrl: 'https://images.unsplash.com/photo-1508062878650-88b52897f298?w=400',
      calories: 575,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_018',
      name: 'Barretta Proteica',
      brand: 'Myprotein',
      imageUrl: 'https://images.unsplash.com/photo-1590523277543-a94d2e4eb00b?w=400',
      calories: 200,
      category: ProductCategory.best,
      rating: 4.5,
    ),

    // Bevande
    Product(
      id: 'prod_019',
      name: 'Acqua Naturale',
      brand: 'San Benedetto',
      imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400',
      calories: 0,
      category: ProductCategory.all,
    ),
    Product(
      id: 'prod_020',
      name: 'Tè Verde Bio',
      brand: 'Pompadour',
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
      calories: 2,
      category: ProductCategory.all,
    ),
  ];

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(_minDelay);
  }

  @override
  Future<List<Product>> searchProducts(String query, {int limit = 20}) async {
    await _simulateNetworkDelay();

    if (query.isEmpty) {
      return _mockProducts.take(limit).toList();
    }

    final lowerQuery = query.toLowerCase();
    final results = _mockProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.brand.toLowerCase().contains(lowerQuery);
    }).take(limit).toList();

    return results;
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    await _simulateNetworkDelay();

    // Simuliamo che alcuni barcode siano riconosciuti
    // In un'app reale, qui ci sarebbe una chiamata a OpenFoodFacts o DB interno
    final mockBarcodes = {
      '8076809513524': _mockProducts[0], // Barilla Pasta
      '8001160001111': _mockProducts[7], // Rio Mare Tonno
      '8000500037423': _mockProducts[15], // Alce Nero Miele
    };

    return mockBarcodes[barcode];
  }

  @override
  Future<Product?> getProductById(String productId) async {
    await _simulateNetworkDelay();

    try {
      return _mockProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
    ProductCategory category, {
    int limit = 20,
  }) async {
    await _simulateNetworkDelay();

    final results = _mockProducts
        .where((p) => p.category == category)
        .take(limit)
        .toList();

    return results;
  }

  @override
  Future<List<Product>> getRecentProducts({int limit = 10}) async {
    await _simulateNetworkDelay();

    // Simuliamo gli ultimi prodotti usati
    return _mockProducts.take(limit).toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    await _simulateNetworkDelay();

    final favorites = _mockProducts
        .where((p) => _favoriteIds.contains(p.id))
        .toList();

    return favorites;
  }

  @override
  Future<List<Product>> searchProductsByImage(String imagePath) async {
    // Simuliamo un tempo più lungo per l'analisi dell'immagine
    await Future.delayed(const Duration(seconds: 2));

    // TODO BACKEND: Implementare image recognition
    // Per ora ritorniamo risultati casuali
    return _mockProducts.take(5).toList();
  }

  @override
  Future<void> addToFavorites(String productId) async {
    await _simulateNetworkDelay();
    _favoriteIds.add(productId);
  }

  @override
  Future<void> removeFromFavorites(String productId) async {
    await _simulateNetworkDelay();
    _favoriteIds.remove(productId);
  }
}
