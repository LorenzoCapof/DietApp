import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../core/models/meal.dart';
import '../../../core/models/product.dart';
import '../../../core/models/consumed_product.dart';
import '../../../core/repositories/product_repository.dart';
import '../../../core/repositories/mock_product_repository.dart';
import '../../../providers/nutrition_provider.dart';
import '../../pantry/widgets/product_card.dart';
import '../widgets/selected_products_list.dart';
import '../../../shared/widgets/barcode/barcode_scanner_button.dart';

// Schermata per aggiungere prodotti a un pasto specifico
class AddMealProductsScreen extends StatefulWidget {
  final MealType mealType;
  final DateTime date;

  const AddMealProductsScreen({
    super.key,
    required this.mealType,
    required this.date,
  });

  @override
  State<AddMealProductsScreen> createState() => _AddMealProductsScreenState();
}

class _AddMealProductsScreenState extends State<AddMealProductsScreen> {
  // Repository (sarà sostituito con DI quando avremo il backend)
  final ProductRepository _repository = MockProductRepository();
  final _uuid = const Uuid();

  // State
  final TextEditingController _searchController = TextEditingController();
  final List<ConsumedProduct> _selectedProducts = [];
  List<Product> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carica prodotti iniziali (recenti o suggeriti)
  Future<void> _loadInitialProducts() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final products = await _repository.getRecentProducts(limit: 20);
      setState(() {
        _searchResults = products;
      });
    } catch (e) {
      debugPrint('Error loading initial products: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  /// Esegue la ricerca prodotti
  Future<void> _searchProducts(String query) async {
    setState(() {
      _searchQuery = query;
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final products = await _repository.searchProducts(query, limit: 30);
      setState(() {
        _searchResults = products;
      });
    } catch (e) {
      debugPrint('Error searching products: $e');
      _showErrorSnackBar('Errore durante la ricerca');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  /// Aggiunge un prodotto alla lista selezionati
  void _addProduct(Product product) {
    // Quantità default intelligente basata sul tipo di prodotto
    final defaultQuantity = _getDefaultQuantity(product);
    final defaultUnit = _getDefaultUnit(product);

    final consumedProduct = ConsumedProduct(
      id: _uuid.v4(),
      product: product,
      quantity: defaultQuantity,
      unit: defaultUnit,
    );

    setState(() {
      _selectedProducts.add(consumedProduct);
    });

    HapticFeedback.lightImpact();

    // Feedback visivo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} aggiunto'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }

  /// Rimuove un prodotto dalla lista
  void _removeProduct(int index) {
    setState(() {
      _selectedProducts.removeAt(index);
    });

    HapticFeedback.lightImpact();
  }

  /// Aggiorna quantità di un prodotto
  void _updateProductQuantity(
    int index,
    double quantity,
    MeasurementUnit unit,
  ) {
    setState(() {
      _selectedProducts[index] = _selectedProducts[index].copyWith(
        quantity: quantity,
        unit: unit,
      );
    });
  }

  /// Salva i prodotti e aggiunge al pasto
  Future<void> _saveProducts() async {
    if (_selectedProducts.isEmpty) {
      _showErrorSnackBar('Aggiungi almeno un prodotto');
      return;
    }

    try {
      final provider = context.read<NutritionProvider>();
      
      // Mostra loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Aggiungi i prodotti al pasto
      await provider.addProductsToMeal(
        widget.mealType,
        _selectedProducts,
      );

      // Chiudi loading
      if (mounted) Navigator.of(context).pop();

      // Feedback successo
      HapticFeedback.mediumImpact();

      // Torna alla home
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_selectedProducts.length} prodott${_selectedProducts.length == 1 ? 'o aggiunto' : 'i aggiunti'} a ${widget.mealType.displayName}',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      // Chiudi loading
      if (mounted) Navigator.of(context).pop();
      
      debugPrint('Error saving products: $e');
      _showErrorSnackBar('Errore durante il salvataggio');
    }
  }

  /// Determina quantità default intelligente
  double _getDefaultQuantity(Product product) {
    // Logica intelligente basata sul nome del prodotto
    final nameLower = product.name.toLowerCase();
    
    // Bevande: 250ml default
    if (nameLower.contains('acqua') || 
        nameLower.contains('latte') ||
        nameLower.contains('succo')) {
      return 250.0;
    }
    
    // Frutta: 1 pezzo
    if (nameLower.contains('banana') ||
        nameLower.contains('mela') ||
        nameLower.contains('pera')) {
      return 1.0;
    }
    
    // Uova: 2 pezzi
    if (nameLower.contains('uova') || nameLower.contains('uovo')) {
      return 2.0;
    }
    
    // Default: 100g
    return 100.0;
  }

  /// Determina unità default intelligente
  MeasurementUnit _getDefaultUnit(Product product) {
    final nameLower = product.name.toLowerCase();
    
    // Liquidi: ml
    if (nameLower.contains('acqua') || 
        nameLower.contains('latte') ||
        nameLower.contains('succo')) {
      return MeasurementUnit.ml;
    }
    
    // Frutta intera / Uova: pezzi
    if (nameLower.contains('banana') ||
        nameLower.contains('mela') ||
        nameLower.contains('pera') ||
        nameLower.contains('uova') ||
        nameLower.contains('uovo')) {
      return MeasurementUnit.pieces;
    }
    
    // Default: grammi
    return MeasurementUnit.grams;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
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

  // Continua nella parte 2...
// Parte 2 - Build Methods e UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Search Section (fixed at top)
          _buildSearchSection(),
          _buildScannerSection(context),
          const SizedBox(height: 12),

          // Content (scrollable)
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Selected Products (se presenti)
                if (_selectedProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SelectedProductsList(
                        products: _selectedProducts,
                        onQuantityChanged: _updateProductQuantity,
                        onRemove: _removeProduct,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],

                // Search Results Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _hasSearched && _searchQuery.isNotEmpty
                          ? 'RISULTATI RICERCA'
                          : 'PRODOTTI SUGGERITI',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Search Results Grid
                if (_isSearching)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (_searchResults.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyResults(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = _searchResults[index];
                          return GestureDetector(
                            onTap: () => _addProduct(product),
                            child: ProductCard(product: product),
                          );
                        },
                        childCount: _searchResults.length,
                      ),
                    ),
                  ),

                // Bottom spacing for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedProducts.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _saveProducts,
              backgroundColor: AppTheme.accent1,
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                'Salva (${_selectedProducts.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppTheme.primary),
        onPressed: () => context.pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mealType.displayName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            _formatDate(widget.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
                      // Debounce search
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (_searchController.text == value && value.isNotEmpty) {
                          _searchProducts(value);
                        }
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

          const SizedBox(height: 12),
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

  Widget _buildEmptyResults() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun prodotto trovato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prova con una ricerca diversa',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _openBarcodeScanner(BuildContext context) {
    GoRouter.of(context).push('/barcode-scanner');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Oggi';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Ieri';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'Domani';
    } else {
      // Format: "Lun 27 Gen"
      const months = [
        'Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu',
        'Jul', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'
      ];
      const weekdays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
      
      final weekday = weekdays[date.weekday - 1];
      final month = months[date.month - 1];
      
      return '$weekday ${date.day} $month';
    }
  }
}

/// Widget per quick actions (Barcode, Foto)
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}