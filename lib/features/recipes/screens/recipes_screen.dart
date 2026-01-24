import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/models/recipe.dart'; // Usa il modello esistente
import '../widgets/recipe_card.dart';
import '../widgets/recipe_category_section.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
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

            // Content
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppTheme.paddingStandard),
                
                // Sezione PASTI
                RecipeCategorySection(
                  title: 'PASTI',
                  recipes: _getMealsRecipes(),
                  onSeeAll: () => _navigateToCategory('PASTI'),
                  isBigCard: true,
                ),
                
                const SizedBox(height: 32),
                
                // Sezione COLAZIONE
                RecipeCategorySection(
                  title: 'COLAZIONE',
                  recipes: _getBreakfastRecipes(),
                  onSeeAll: () => _navigateToCategory('COLAZIONE'),
                  isBigCard: false,
                ),
                
                const SizedBox(height: 32),
                
                // Sezione SPUNTINI
                RecipeCategorySection(
                  title: 'SPUNTINI',
                  recipes: _getSnacksRecipes(),
                  onSeeAll: () => _navigateToCategory('SPUNTINI'),
                  isBigCard: false,
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
                      hintText: 'Trova Ricette',
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

  List<Recipe> _getMealsRecipes() {
    return [
      Recipe(
        id: '1',
        name: 'Ricette per Performance',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
        calories: 495,
        duration: 25,
        category: RecipeCategory.meals,
      ),
      Recipe(
        id: '1b',
        name: 'Bowl Proteica',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
        calories: 520,
        duration: 30,
        category: RecipeCategory.meals,
      ),
      Recipe(
        id: '1c',
        name: 'Insalata Nutriente',
        imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800',
        calories: 380,
        duration: 15,
        category: RecipeCategory.meals,
      ),
    ];
  }

  List<Recipe> _getBreakfastRecipes() {
    return [
      Recipe(
        id: '2',
        name: 'Tofu con quinoa e erbe',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
        calories: 495,
        category: RecipeCategory.breakfast,
      ),
      Recipe(
        id: '3',
        name: 'Tofu con quinoa e erbe',
        imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=600',
        calories: 495,
        category: RecipeCategory.breakfast,
      ),
      Recipe(
        id: '4',
        name: 'Frittata con verdure',
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600',
        calories: 380,
        category: RecipeCategory.breakfast,
      ),
    ];
  }

  List<Recipe> _getSnacksRecipes() {
    return [
      Recipe(
        id: '5',
        name: 'Energy balls',
        imageUrl: 'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=600',
        calories: 220,
        category: RecipeCategory.snacks,
      ),
      Recipe(
        id: '6',
        name: 'Smoothie bowl',
        imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=600',
        calories: 310,
        category: RecipeCategory.snacks,
      ),
    ];
  }

  void _navigateToCategory(String category) {
    context.push('/recipes-list/${Uri.encodeComponent(category)}');
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