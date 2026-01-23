
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/recipe.dart';
import 'recipe_card.dart';

class RecipeCategorySection extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;
  final VoidCallback onSeeAll;
  final bool isBigCard;

  const RecipeCategorySection({
    super.key,
    required this.title,
    required this.recipes,
    required this.onSeeAll,
    required this.isBigCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
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

        // Content - sempre in carosello
        _buildCarousel(),
      ],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: (this.isBigCard) ? 300 : 180,
            child: RecipeCard(recipe: recipes[index]),
          );
        },
      ),
    );
  }
}

