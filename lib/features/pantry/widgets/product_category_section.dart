import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/product.dart';
import 'product_card.dart';

class ProductCategorySection extends StatelessWidget {
  final String title;
  final List<Product> products;
  final VoidCallback onSeeAll;
  final bool isExpiring;

  const ProductCategorySection({
    super.key,
    required this.title,
    required this.products,
    required this.onSeeAll,
    this.isExpiring = false,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: isExpiring ? AppTheme.error : null,
                    ),
                  ),
                  if (isExpiring) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.warning,
                        size: 14,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'Vedi tutto',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Carousel senza padding (full-width)
        _buildCarousel(),
      ],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingStandard),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: ProductCard(
              product: products[index],
              isExpiring: isExpiring,
            ),
          );
        },
      ),
    );
  }
}