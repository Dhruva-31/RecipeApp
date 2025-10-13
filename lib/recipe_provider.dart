import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeProvider extends ChangeNotifier {
  List<dynamic> recipes = [];
  List<dynamic> cuisines = [];
  List<dynamic> items = [];
  bool isLoaded = false;
  String selectedFilter = "All";
  List<dynamic> filteredRecipes = [];
  bool showFavourites = false;

  void setSelectedFilter(String s) {
    selectedFilter = s;
    notifyListeners();
  }

  void setFilteredRecipe(List fr) {
    filteredRecipes = fr;
    notifyListeners();
  }

  void setShowFavorites() {
    showFavourites = !showFavourites;
    notifyListeners();
  }

  Future<void> loadRecipeDetails() async {
    if (isLoaded) {
      return;
    }
    final data = await rootBundle.loadString('assets/recipe_data');
    final jsonResult = json.decode(data);
    recipes = jsonResult['recipes'];
    cuisines = jsonResult['cuisine'];
    items = jsonResult['items'];
    isLoaded = true;
    notifyListeners();
  }

  void toggleFavorite(String recipeName) {
    final index = recipes.indexWhere((r) => r['name'] == recipeName);
    if (index != -1) {
      recipes[index]['isFavorite'] = !recipes[index]['isFavorite'];
      notifyListeners();
    }
  }

  void applyFilters(
    RecipeProvider recipeProvider,
    TextEditingController searchController,
  ) {
    final query = searchController.text.toLowerCase().trim();
    var tempList = recipeProvider.recipes;
    if (showFavourites) {
      tempList = recipes.where((r) => r['isFavorite'] == true).toList();
    }
    if (selectedFilter != "All") {
      tempList = tempList
          .where((recipe) => recipe["cuisine"] == selectedFilter)
          .toList();
    }
    if (query.isNotEmpty) {
      tempList = tempList
          .where(
            (recipe) => recipe["name"].toString().toLowerCase().contains(query),
          )
          .toList();
    }
    filteredRecipes = tempList;
    notifyListeners();
  }
}
