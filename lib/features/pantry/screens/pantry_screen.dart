import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/product_category_section.dart';
import '../widgets/barcode_scanner_button.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header con Search Bar
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            // Scanner Button
            SliverToBoxAdapter(
              child: _buildScannerSection(context),
            ),

            // Content
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                
                // Sezione APPENA AGGIUNTI
                ProductCategorySection(
                  title: 'APPENA AGGIUNTI',
                  products: _getRecentlyAddedProducts(),
                  onSeeAll: () => _navigateToCategory('APPENA AGGIUNTI'),
                ),
                
                const SizedBox(height: 32),
                
                // Sezione TUTTI I PRODOTTI
                ProductCategorySection(
                  title: 'TUTTI I PRODOTTI',
                  products: _getAllProducts(),
                  onSeeAll: () => _navigateToCategory('TUTTI I PRODOTTI'),
                ),
                
                const SizedBox(height: 32),
                
                // Sezione I MIGLIORI
                ProductCategorySection(
                  title: 'I MIGLIORI',
                  products: _getBestProducts(),
                  onSeeAll: () => _navigateToCategory('I MIGLIORI'),
                ),
                
                const SizedBox(height: 32),
                
                // Sezione I TUOI PREFERITI
                ProductCategorySection(
                  title: 'I TUOI PREFERITI',
                  products: _getFavoriteProducts(),
                  onSeeAll: () => _navigateToCategory('I TUOI PREFERITI'),
                ),
                
                const SizedBox(height: 32),
                
                // Sezione LISTA DELLA SPESA
                ProductCategorySection(
                  title: 'LISTA DELLA SPESA',
                  products: _getShoppingListProducts(),
                  onSeeAll: () => _navigateToCategory('LISTA DELLA SPESA'),
                ),
                
                const SizedBox(height: 32),
                
                // Sezione VICINO ALLA SCADENZA
                ProductCategorySection(
                  title: 'VICINO ALLA SCADENZA',
                  products: _getExpiringProducts(),
                  onSeeAll: () => _navigateToCategory('VICINO ALLA SCADENZA'),
                  isExpiring: true,
                ),
                
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.paddingStandard,
        20,
        AppTheme.paddingStandard,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar e Menu
          Row(
            children: [
              // Search Bar
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cerca Prodotti',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Menu Button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.06),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () => _showFilterMenu(context),
                  icon: const Icon(Icons.tune),
                  color: AppTheme.textPrimary,
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScannerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
      child: BarcodeScannerButton(
        onScan: () => _openBarcodeScanner(context),
      ),
    );
  }

  List<Product> _getRecentlyAddedProducts() {
    return [
      Product(
        id: '1',
        name: 'Pasta Integrale Barilla',
        brand: 'Barilla',
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
        calories: 350,
        category: ProductCategory.recentlyAdded,
        expiryDate: DateTime.now().add(const Duration(days: 180)),
      ),
      Product(
        id: '2',
        name: 'Latte Scremato',
        brand: 'Granarolo',
        imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
        calories: 35,
        category: ProductCategory.recentlyAdded,
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      ),
      Product(
        id: '3',
        name: 'Yogurt Greco',
        brand: 'Fage',
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
        calories: 97,
        category: ProductCategory.recentlyAdded,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }

  List<Product> _getAllProducts() {
    return [
      Product(
        id: '4',
        name: 'Riso Basmati',
        brand: 'Scotti',
        imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
        calories: 360,
        category: ProductCategory.all,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      ),
      Product(
        id: '5',
        name: 'Olio Extra Vergine',
        brand: 'De Cecco',
        imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
        calories: 884,
        category: ProductCategory.all,
        expiryDate: DateTime.now().add(const Duration(days: 540)),
      ),
    ];
  }

  List<Product> _getBestProducts() {
    return [
      Product(
        id: '6',
        name: 'Avena Integrale',
        brand: 'Quaker',
        imageUrl: 'https://images.unsplash.com/photo-1574856344991-aaa31b6f4ce3?w=400',
        calories: 389,
        category: ProductCategory.best,
        rating: 4.8,
        expiryDate: DateTime.now().add(const Duration(days: 200)),
      ),
      Product(
        id: '7',
        name: 'Tonno al Naturale',
        brand: 'Rio Mare',
        imageUrl: 'https://images.unsplash.com/photo-1625943553852-781c6dd46faa?w=400',
        calories: 116,
        category: ProductCategory.best,
        rating: 4.6,
        expiryDate: DateTime.now().add(const Duration(days: 730)),
      ),
    ];
  }

  List<Product> _getFavoriteProducts() {
    return [
      Product(
        id: '8',
        name: 'Miele Biologico',
        brand: 'Alce Nero',
        imageUrl: 'https://images.unsplash.com/photo-1555055926-c5778f87751e?w=400',
        calories: 304,
        category: ProductCategory.favorites,
        isFavorite: true,
        expiryDate: DateTime.now().add(const Duration(days: 600)),
      ),
    ];
  }

  List<Product> _getShoppingListProducts() {
    return [
      Product(
        id: '9',
        name: 'Banane',
        brand: 'Dole',
        imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=400',
        calories: 89,
        category: ProductCategory.shoppingList,
        inShoppingList: true,
      ),
      Product(
        id: '10',
        name: 'Uova Biologiche',
        brand: 'Cascina Italia',
        imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
        calories: 143,
        category: ProductCategory.shoppingList,
        inShoppingList: true,
      ),
    ];
  }

  List<Product> _getExpiringProducts() {
    return [
      Product(
        id: '11',
        name: 'Mozzarella',
        brand: 'Galbani',
        imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400',
        calories: 280,
        category: ProductCategory.expiring,
        expiryDate: DateTime.now().add(const Duration(days: 2)),
      ),
      Product(
        id: '12',
        name: 'Prosciutto Cotto',
        brand: 'Rovagnati',
        imageUrl: 'https://images.unsplash.com/photo-1529016061486-d80ad8eea08b?w=400',
        calories: 145,
        category: ProductCategory.expiring,
        expiryDate: DateTime.now().add(const Duration(days: 3)),
      ),
    ];
  }

  void _navigateToCategory(String category) {
    context.push('/products-list/${Uri.encodeComponent(category)}');
  }

  void _showFilterMenu(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtri - Coming soon!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openBarcodeScanner(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Scanner codice a barre - Coming soon!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}