import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/recipe.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.recipe.isFavorite;
  }

  bool get _isMealsCategory => widget.recipe.category == RecipeCategory.meals;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openRecipeDetail(),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          color: AppTheme.surface,
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: _isMealsCategory ? _buildMealsCard() : _buildStandardCard(),
      ),
    );
  }

  // Card per PASTI - tutto sull'immagine
  Widget _buildMealsCard() {
    return Stack(
      children: [
        // Immagine full
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          child: Image.network(
            widget.recipe.imageUrl,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 240,
                color: AppTheme.surface,
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 48,
                    color: AppTheme.textDisabled,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
        
        // Content
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.recipe.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Calories, Duration e Favorite
              Row(
                children: [
                  // Calories
                  const Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.recipe.calories} kcal',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  
                  if (widget.recipe.duration != null) ...[
                    const SizedBox(width: 12),
                    
                    // Duration
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.recipe.duration} min',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Card standard per COLAZIONE e SPUNTINI
  Widget _buildStandardCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusCard),
          ),
          child: Stack(
            children: [
              Image.network(
                widget.recipe.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: AppTheme.surface,
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
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
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.recipe.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Calories e Favorite (NO duration)
              Row(
                children: [
                  // Calories
                  const Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.recipe.calories} kcal',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openRecipeDetail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apri ricetta: ${widget.recipe.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}