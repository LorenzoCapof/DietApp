import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/product.dart';
import '../widgets/product_card.dart';

class ProductsListScreen extends StatefulWidget {
  final String category;

  const ProductsListScreen({
    super.key,
    required this.category,
  });

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSelectionMode = false;
  final Set<String> _selectedProducts = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () {
            if (_isSelectionMode) {
              setState(() {
                _isSelectionMode = false;
                _selectedProducts.clear();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          widget.category,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (_isSelectionMode)
            TextButton(
              onPressed: _selectedProducts.isEmpty ? null : _deleteSelectedProducts,
              child: Text(
                'Elimina (${_selectedProducts.length})',
                style: TextStyle(
                  color: _selectedProducts.isEmpty 
                      ? AppTheme.textDisabled 
                      : AppTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(context),
          
          // Products Grid
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : _buildProductsGrid(products),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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

  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isSelected = _selectedProducts.contains(product.id);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              _isSelectionMode = true;
              _selectedProducts.add(product.id);
            });
          },
          onTap: () {
            if (_isSelectionMode) {
              setState(() {
                if (isSelected) {
                  _selectedProducts.remove(product.id);
                  if (_selectedProducts.isEmpty) {
                    _isSelectionMode = false;
                  }
                } else {
                  _selectedProducts.add(product.id);
                }
              });
            } else {
              _openProductDetail(product);
            }
          },
          child: Stack(
            children: [
              ProductCard(
                product: product,
                isExpiring: widget.category == 'VICINO ALLA SCADENZA',
              ),
              if (_isSelectionMode)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppTheme.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun prodotto trovato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _getFilteredProducts() {
    // TODO: Sostituire con dati reali dal provider
    final allProducts = _getAllProductsByCategory();
    
    if (_searchQuery.isEmpty) {
      return allProducts;
    }
    
    return allProducts.where((product) {
      final searchLower = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(searchLower) ||
             product.brand.toLowerCase().contains(searchLower);
    }).toList();
  }

  List<Product> _getAllProductsByCategory() {
    // TODO: Implementare con provider reale
    // Dati mock per esempio
    return List.generate(
      20,
      (index) => Product(
        id: 'product_$index',
        name: 'Prodotto ${index + 1}',
        brand: 'Brand ${index % 5 + 1}',
        imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400',
        calories: 100 + (index * 20),
        category: ProductCategory.all,
        expiryDate: widget.category == 'VICINO ALLA SCADENZA'
            ? DateTime.now().add(Duration(days: index % 5))
            : DateTime.now().add(Duration(days: 30 + index)),
      ),
    );
  }

  void _deleteSelectedProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Elimina prodotti',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Vuoi eliminare ${_selectedProducts.length} prodott${_selectedProducts.length == 1 ? 'o' : 'i'}?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annulla',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementare eliminazione reale
              setState(() {
                _selectedProducts.clear();
                _isSelectionMode = false;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prodotti eliminati'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Elimina',
              style: TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        ),
      ),
    );
  }

  void _openProductDetail(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apri dettaglio: ${product.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
}