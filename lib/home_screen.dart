import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/recipe_details_screen.dart';
import 'package:recipe_app/recipe_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  final myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    recipeProvider.loadRecipeDetails().then((_) {
      setState(() {
        recipeProvider.filteredRecipes = recipeProvider.recipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    if (!recipeProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 290,
                      child: TextField(
                        cursorColor: Colors.black,
                        cursorHeight: 20,
                        controller: searchController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          hintText: "Search Recipe",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).primaryColor,
                          prefixIcon: Icon(
                            Icons.search,
                            fontWeight: FontWeight.w600,
                            size: 24,
                          ),
                          suffixIcon: searchController.text != ''
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      searchController.text = '';
                                      recipeProvider.applyFilters(
                                        recipeProvider,
                                        searchController,
                                      );
                                    });
                                  },
                                  icon: Icon(Icons.clear),
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          recipeProvider.applyFilters(
                            recipeProvider,
                            searchController,
                          );
                        },
                        onSubmitted: (value) {
                          recipeProvider.applyFilters(
                            recipeProvider,
                            searchController,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        onPressed: () {
                          recipeProvider.setShowFavorites();
                          recipeProvider.applyFilters(
                            recipeProvider,
                            searchController,
                          );
                        },
                        icon: Icon(
                          recipeProvider.showFavourites
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                        ),
                        color: recipeProvider.showFavourites
                            ? Colors.red
                            : const Color.fromARGB(255, 0, 0, 0),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipeProvider.cuisines.length,
                    itemBuilder: (context, index) {
                      final filter = recipeProvider.cuisines[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              recipeProvider.setSelectedFilter(filter);
                            });
                            recipeProvider.applyFilters(
                              recipeProvider,
                              searchController,
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              color: (recipeProvider.selectedFilter == filter)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(60),
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                recipeProvider.cuisines[index],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: recipeProvider.filteredRecipes.isEmpty
                      ? Center(
                          child: Text(
                            "no recipe found",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : Hero(
                          tag: 'grid',
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3 / 5,
                                ),
                            itemCount: recipeProvider.filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe =
                                  recipeProvider.filteredRecipes[index];
                              Color cardColor;
                              if (index % 4 == 0 || index % 4 == 3) {
                                cardColor = const Color(0xFFFFF9BD);
                              } else {
                                cardColor = const Color(0xFFFFD6BA);
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailsScreen(recipe: recipe),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  color: cardColor,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 200.0,
                                          ),
                                          child: Text(
                                            recipe["name"],
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleSmall,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        left: 5,
                                        child: Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.25,
                                                ),
                                                blurRadius: 10,
                                                offset: Offset(5, 5),
                                              ),
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                  255,
                                                  183,
                                                  69,
                                                  69,
                                                ).withOpacity(0.5),
                                                blurRadius: 5,
                                                offset: Offset(-5, -5),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage(
                                                recipe['image_url'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
