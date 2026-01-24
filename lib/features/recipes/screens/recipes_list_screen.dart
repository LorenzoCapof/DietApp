import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/models/recipe.dart';
import '../widgets/recipe_card.dart';

class RecipesListScreen extends StatefulWidget {
  final String category;

  const RecipesListScreen({
    super.key,
    required this.category,
  });

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSelectionMode = false;
  final Set<String> _selectedRecipes = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _getFilteredRecipes();

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
                _selectedRecipes.clear();
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
              onPressed: _selectedRecipes.isEmpty ? null : _deleteSelectedRecipes,
              child: Text(
                'Elimina (${_selectedRecipes.length})',
                style: TextStyle(
                  color: _selectedRecipes.isEmpty 
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
          
          // Recipes Grid
          Expanded(
            child: recipes.isEmpty
                ? _buildEmptyState()
                : _buildRecipesGrid(recipes),
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
                      hintText: 'Cerca Ricette',
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

  Widget _buildRecipesGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final isSelected = _selectedRecipes.contains(recipe.id);

        return GestureDetector(
          /*
          onLongPress: () {
            setState(() {
              _isSelectionMode = true;
              _selectedRecipes.add(recipe.id);
            });
          },
          */
          onTap: () {
            if (_isSelectionMode) {
              setState(() {
                if (isSelected) {
                  _selectedRecipes.remove(recipe.id);
                  if (_selectedRecipes.isEmpty) {
                    _isSelectionMode = false;
                  }
                } else {
                  _selectedRecipes.add(recipe.id);
                }
              });
            } else {
              _openRecipeDetail(recipe);
            }
          },
          child: Stack(
            children: [
              RecipeCard(recipe: recipe),
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
            'Nessuna ricetta trovata',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Recipe> _getFilteredRecipes() {
    // TODO: Sostituire con dati reali dal provider
    final allRecipes = _getAllRecipesByCategory();
    
    if (_searchQuery.isEmpty) {
      return allRecipes;
    }
    
    return allRecipes.where((recipe) {
      final searchLower = _searchQuery.toLowerCase();
      return recipe.name.toLowerCase().contains(searchLower);
    }).toList();
  }

  List<Recipe> _getAllRecipesByCategory() {
    // TODO: Implementare con provider reale
    // Dati mock per esempio
    return List.generate(
      20,
      (index) => Recipe(
        id: 'recipe_$index',
        name: 'Ricetta ${index + 1}',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
        calories: 300 + (index * 25),
        category: RecipeCategory.snacks,
        duration: widget.category == 'PASTI' ? 20 + (index % 30) : null,
      ),
    );
  }

  void _deleteSelectedRecipes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Elimina ricette',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Vuoi eliminare ${_selectedRecipes.length} ricett${_selectedRecipes.length == 1 ? 'a' : 'e'}?',
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
                _selectedRecipes.clear();
                _isSelectionMode = false;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ricette eliminate'),
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

  void _openRecipeDetail(Recipe recipe) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apri dettaglio: ${recipe.name}'),
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