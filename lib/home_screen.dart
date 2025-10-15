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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (!recipeProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: height * 0.01),
                  Row(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.7,
                        child: TextField(
                          cursorColor: Colors.black,
                          cursorHeight: height * 0.025,
                          controller: searchController,
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            hintText: "Search Recipe",
                            hintStyle: Theme.of(context).textTheme.titleMedium,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: height * 0.005,
                              horizontal: width * 0.02,
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
                            prefixIcon: Icon(Icons.search, size: width * 0.06),
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
                      SizedBox(width: width * 0.02),
                      SizedBox(
                        width: width * 0.15,
                        height: width * 0.15,
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
                          iconSize: width * 0.08,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    height: height * 0.08,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipeProvider.cuisines.length,
                      itemBuilder: (context, index) {
                        final filter = recipeProvider.cuisines[index];
                        return Padding(
                          padding: EdgeInsets.all(width * 0.02),
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
                                  horizontal: width * 0.05,
                                  vertical: height * 0.01,
                                ),
                                child: Text(
                                  recipeProvider.cuisines[index],
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
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
                                    crossAxisCount: width < 600 ? 2 : 4,
                                    crossAxisSpacing: width * 0.02,
                                    mainAxisSpacing: width * 0.02,
                                    childAspectRatio: width < 600
                                        ? 3 / 5
                                        : 2.5 / 4.5,
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
                                            padding: EdgeInsets.only(
                                              bottom: height * 0.25,
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
                                          top: height * 0.15,
                                          left: width * 0.01,
                                          child: Container(
                                            width: width * 0.4,
                                            height: width * 0.4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
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
      ),
    );
  }
}
