// lib/features/meals/widgets/selected_products_list.dart

import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/consumed_product.dart';
import 'quantity_selector.dart';

/// Widget per mostrare la lista dei prodotti selezionati per il pasto
/// Permette di modificare quantità o rimuovere prodotti
class SelectedProductsList extends StatelessWidget {
  final List<ConsumedProduct> products;
  final Function(int index, double quantity, MeasurementUnit unit) onQuantityChanged;
  final Function(int index) onRemove;

  const SelectedProductsList({
    super.key,
    required this.products,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRODOTTI SELEZIONATI',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${products.length} ${products.length == 1 ? 'prodotto' : 'prodotti'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Lista prodotti
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductListItem(
              product: product,
              onQuantityChanged: (quantity, unit) {
                onQuantityChanged(index, quantity, unit);
              },
              onRemove: () => onRemove(index),
            );
          },
        ),

        const SizedBox(height: 16),

        // Totale calorie
        _buildTotalCalories(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 64,
            color: AppTheme.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun prodotto selezionato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cerca e aggiungi prodotti al pasto',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCalories(BuildContext context) {
    final totalCalories = products.fold<double>(
      0,
      (sum, p) => sum + p.totalNutrition.calories,
    );

    final totalProtein = products.fold<double>(
      0,
      (sum, p) => sum + p.totalNutrition.protein,
    );

    final totalCarbs = products.fold<double>(
      0,
      (sum, p) => sum + p.totalNutrition.carbs,
    );

    final totalFats = products.fold<double>(
      0,
      (sum, p) => sum + p.totalNutrition.fats,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Totale pasto',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: AppTheme.accent1,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${totalCalories.toInt()} kcal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Macro breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroChip(
                label: 'C',
                value: totalCarbs.toInt(),
                color: AppTheme.carbs,
              ),
              _MacroChip(
                label: 'P',
                value: totalProtein.toInt(),
                color: AppTheme.protein,
              ),
              _MacroChip(
                label: 'G',
                value: totalFats.toInt(),
                color: AppTheme.fats,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final ConsumedProduct product;
  final Function(double quantity, MeasurementUnit unit) onQuantityChanged;
  final VoidCallback onRemove;

  const _ProductListItem({
    required this.product,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Immagine prodotto
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: AppTheme.background,
                      child: const Icon(
                        Icons.fastfood,
                        size: 24,
                        color: AppTheme.textDisabled,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Info prodotto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.product.brand,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.totalNutrition.calories.toInt()} kcal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottone rimuovi
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: AppTheme.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Selettore quantità
          QuantitySelector(
            initialQuantity: product.quantity,
            initialUnit: product.unit,
            onChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MacroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ${value}g',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
