import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:math' as math;
import '../../../app/theme.dart';
import '../widgets/nutrition_score_circle.dart';

class ProductDetailScreen extends StatefulWidget {
  final String barcode;

  const ProductDetailScreen({
    super.key,
    required this.barcode,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  String? _errorMessage;
  int _nutritionScore = 0;
  int _quantity = 1;
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Configure OpenFoodFacts
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'DietApp',
        version: '1.0.0',
      );

      // Fetch product
      final ProductQueryConfiguration configuration = ProductQueryConfiguration(
        widget.barcode,
        language: OpenFoodFactsLanguage.ITALIAN,
        fields: [
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.NUTRIMENTS,
          ProductField.NUTRISCORE,
          ProductField.NOVA_GROUP,
          ProductField.INGREDIENTS_TEXT,
        ],
        version: ProductQueryVersion.v3,
      );

      final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
        configuration,
      );

      if (result.product != null) {
        setState(() {
          _product = result.product;
          _nutritionScore = _calculateNutritionScore(result.product!);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Prodotto non trovato nel database';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore durante il caricamento: $e';
        _isLoading = false;
      });
    }
  }

  int _calculateNutritionScore(Product product) {
    // Sistema di valutazione su 100
    int score = 50; // Start from middle

    final nutriments = product.nutriments;
    if (nutriments == null) return score;

    // Positive factors (increase score)
    // Fiber (good)
    final fiber = nutriments.getValue(Nutrient.fiber, PerSize.oneHundredGrams);
    if (fiber != null) {
      score += ((fiber * 2).toInt()).clamp(0, 10);
    }
    
    // Protein (good)
    final proteins = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
    if (proteins != null) {
      score += ((proteins * 1.5).toInt()).clamp(0, 10);
    }

    // Negative factors (decrease score)
    // Saturated fat (bad)
    final saturatedFat = nutriments.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams);
    if (saturatedFat != null) {
      score -= ((saturatedFat * 3).toInt()).clamp(0, 15);
    }
    
    // Sugar (bad)
    final sugars = nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams);
    if (sugars != null) {
      score -= ((sugars * 2).toInt()).clamp(0, 15);
    }
    
    // Salt (bad)
    final salt = nutriments.getValue(Nutrient.salt, PerSize.oneHundredGrams);
    if (salt != null) {
      score -= ((salt * 10).toInt()).clamp(0, 15);
    }

    // Nutriscore bonus/malus
    if (product.nutriscore != null) {
      switch (product.nutriscore!.toUpperCase()) {
        case 'A':
          score += 20;
          break;
        case 'B':
          score += 10;
          break;
        case 'C':
          break; // neutral
        case 'D':
          score -= 10;
          break;
        case 'E':
          score -= 20;
          break;
      }
    }

    // Nova group (ultra-processed penalty)
    if (product.novaGroup != null && product.novaGroup! >= 3) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildProductDetail(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Caricamento prodotto...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return SafeArea(
      child: Column(
        children: [
          // App Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Error content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppTheme.error.withOpacity(0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _loadProduct,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Riprova'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetail() {
    if (_product == null) return const SizedBox.shrink();

    return CustomScrollView(
      slivers: [
        // App Bar with image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppTheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            // Titolo e sottotitolo sono gestiti solitamente qui o dentro lo Stack
            background: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Immagine di sfondo
                _product!.imageFrontUrl != null
                    ? Image.network(
                        _product!.imageFrontUrl!,
                        fit: BoxFit.cover,
                        // Gestione del caricamento
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child; // Immagine caricata
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                      )
                    : _buildErrorPlaceholder(),

                // 2. Gradiente Scuro (Overlay)
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87, // Intensità dell'ombra in basso
                      ],
                      stops: [0.6, 1.0], // Il gradiente inizia a scurirsi dal 60% dell'altezza
                    ),
                  ),
                ),

                // 3. Testi (Titolo e Sottotitolo)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _product!.productName ?? "Nome Prodotto",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _product!.brands! ?? "Marca",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nutrition Score
              Container(
                margin: const EdgeInsets.all(AppTheme.paddingStandard),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.06),
                    width: 1,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    Text(
                      'VALUTAZIONE NUTRIZIONALE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    NutritionScoreCircle(score: _nutritionScore),
                    const SizedBox(height: 16),
                    Text(
                      _getScoreDescription(_nutritionScore),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Nutrition Table
              if (_product!.nutriments != null) _buildNutritionTable(),

              const SizedBox(height: 24),

              // Quantity Input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.06),
                    width: 1,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUANTITÀ PRODOTTO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Decrease button
                        IconButton(
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                                _quantityController.text = _quantity.toString();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppTheme.primary,
                          iconSize: 32,
                        ),
                        const SizedBox(width: 8),
                        // Quantity input
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.primary.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.primary.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppTheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null && parsed > 0) {
                                setState(() {
                                  _quantity = parsed;
                                });
                              } else if (value.isEmpty || parsed == null || parsed <= 0) {
                                setState(() {
                                  _quantity = 1;
                                  _quantityController.text = '1';
                                  _quantityController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: _quantityController.text.length),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Increase button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++;
                              _quantityController.text = _quantity.toString();
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppTheme.primary,
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
                child: Column(
                  children: [
                    // Add Product Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implementa logica per aggiungere prodotto
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Aggiunto $_quantity x ${_product!.productName ?? "prodotto"}'),
                              backgroundColor: AppTheme.primary,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 24),
                        label: const Text(
                          'Aggiungi prodotto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Scan Another Product Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implementa logica per scansionare altro prodotto
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.qr_code_scanner, size: 24),
                        label: const Text(
                          'Scansiona un altro prodotto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: AppTheme.primary.withOpacity(0.1),
      child: const Icon(
        Icons.image_not_supported,
        size: 80,
        color: AppTheme.textDisabled,
      ),
    );
  }

  Widget _buildNutritionTable() {
    final nutriments = _product!.nutriments!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DICHIARAZIONE NUTRIZIONALE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'per 100g',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          _buildNutrientRow(
            'Energia',
            nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams)?.toStringAsFixed(0) ?? '-',
            'kcal',
          ),
          _buildNutrientRow(
            'Grassi',
            nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams)?.toStringAsFixed(1) ?? '-',
            'g',
            color: AppTheme.fats,
          ),
          if (nutriments.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams) != null)
            _buildNutrientRow(
              '  di cui saturi',
              nutriments.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams)!.toStringAsFixed(1),
              'g',
              isIndented: true,
            ),
          _buildNutrientRow(
            'Carboidrati',
            nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams)?.toStringAsFixed(1) ?? '-',
            'g',
            color: AppTheme.carbs,
          ),
          if (nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams) != null)
            _buildNutrientRow(
              '  di cui zuccheri',
              nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams)!.toStringAsFixed(1),
              'g',
              isIndented: true,
            ),
          if (nutriments.getValue(Nutrient.fiber, PerSize.oneHundredGrams) != null)
            _buildNutrientRow(
              'Fibre',
              nutriments.getValue(Nutrient.fiber, PerSize.oneHundredGrams)!.toStringAsFixed(1),
              'g',
            ),
          _buildNutrientRow(
            'Proteine',
            nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams)?.toStringAsFixed(1) ?? '-',
            'g',
            color: AppTheme.protein,
          ),
          _buildNutrientRow(
            'Sale',
            nutriments.getValue(Nutrient.salt, PerSize.oneHundredGrams)?.toStringAsFixed(2) ?? '-',
            'g',
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(
    String name,
    String value,
    String unit, {
    Color? color,
    bool isIndented = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (color != null)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isIndented ? AppTheme.textSecondary : AppTheme.textPrimary,
                    fontWeight: isIndented ? FontWeight.w400 : FontWeight.w500,
                  ),
            ),
          ),
          Text(
            '$value $unit',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(int score) {
    if (score >= 80) return 'Eccellente scelta nutrizionale';
    if (score >= 60) return 'Buona scelta nutrizionale';
    if (score >= 40) return 'Scelta accettabile';
    if (score >= 20) return 'Scelta da limitare';
    return 'Sconsigliato per uso frequente';
  }
}