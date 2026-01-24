import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../core/models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isExpiring;

  const ProductCard({
    super.key,
    required this.product,
    this.isExpiring = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProductDetail(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          color: AppTheme.surface,
          border: Border.all(
            color: widget.isExpiring 
                ? AppTheme.warning.withOpacity(0.15)
                : AppTheme.primary.withOpacity(0.06),
            width: widget.isExpiring ? 2 : 1,
          ),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusButton),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: AppTheme.surface,
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 40,
                            color: AppTheme.textDisabled,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Favorite button overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: _isFavorite ? Colors.red : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & Brand
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.product.brand,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Bottom info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Calories or Rating
                        if (widget.product.rating != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppTheme.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.rating!.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.product.calories} kcal',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        
                        // Expiry date if available
                        if (widget.product.expiryDate != null && widget.isExpiring) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: _getDaysUntilExpiry() <= 3 
                                    ? AppTheme.error 
                                    : AppTheme.warning,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _getExpiryText(),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getDaysUntilExpiry() <= 3 
                                        ? AppTheme.error 
                                        : AppTheme.warning,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getDaysUntilExpiry() {
    if (widget.product.expiryDate == null) return 999;
    return widget.product.expiryDate!.difference(DateTime.now()).inDays;
  }

  String _getExpiryText() {
    final days = _getDaysUntilExpiry();
    if (days == 0) return 'Scade oggi!';
    if (days == 1) return 'Scade domani';
    if (days <= 3) return 'Scade tra $days gg';
    return DateFormat('dd/MM/yy').format(widget.product.expiryDate!);
  }

  void _openProductDetail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apri prodotto: ${widget.product.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}