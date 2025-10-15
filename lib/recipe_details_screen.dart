import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/recipe_provider.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Map recipe;
  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool showIngredients = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    if (!recipeProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.05),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: width * 0.07,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.21),
                      Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.primary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.05),
                          borderSide: BorderSide.none,
                        ),
                        child: SizedBox(
                          width: width * 0.5,
                          height: height * 0.22,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(width * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [SizedBox(height: height * 0.07)],
                                ),
                              ),
                              Positioned(
                                bottom: -height * 0.04,
                                right: width * 0.045,
                                child: Hero(
                                  tag: 'grid',
                                  child: Container(
                                    width: width * 0.4,
                                    height: width * 0.4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.green,
                                        width: width * 0.005,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: width * 0.02,
                                          offset: Offset(
                                            width * 0.015,
                                            width * 0.015,
                                          ),
                                        ),
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                            255,
                                            183,
                                            69,
                                            69,
                                          ).withOpacity(0.5),
                                          blurRadius: width * 0.01,
                                          offset: Offset(
                                            -width * 0.015,
                                            -width * 0.015,
                                          ),
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: AssetImage(
                                          widget.recipe['image_url'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.08),
                      IconButton(
                        onPressed: () {
                          recipeProvider.toggleFavorite(widget.recipe["name"]);
                        },
                        icon: Icon(
                          widget.recipe["isFavorite"]
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                        ),
                        color: widget.recipe['isFavorite']
                            ? Colors.red
                            : const Color.fromARGB(255, 0, 0, 0),
                        iconSize: width * 0.08,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  Center(
                    child: Card(
                      elevation: 8,
                      color: Theme.of(context).primaryColor,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.08),
                        borderSide: BorderSide.none,
                      ),
                      child: SizedBox(
                        width: width * 0.85,
                        height: height * 0.08,
                        child: Center(
                          child: Text(
                            widget.recipe["creator"],
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      top: height * 0.03,
                    ),
                    child: Text(
                      widget.recipe["name"],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.045),
                    child: Text(
                      widget.recipe["cuisine"],
                      style: TextStyle(
                        color: const Color.fromARGB(255, 46, 44, 44),
                        fontSize: width * 0.045,
                        fontFamily: "Inter",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.045),
                    child: SizedBox(
                      width: width * 0.9,
                      child: Text(
                        widget.recipe["short_description"],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      'Nutritions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width > 600 ? 3 : 2,
                      crossAxisSpacing: width * 0.03,
                      mainAxisSpacing: width * 0.03,
                      childAspectRatio: 3 / 1,
                    ),
                    itemCount: widget.recipe["nutrients"].length,
                    itemBuilder: (context, index1) {
                      var nutrientKey = widget.recipe["nutrients"].keys
                          .toList()[index1];
                      var nutrientValue =
                          widget.recipe["nutrients"][nutrientKey]["value"];
                      var nutrientUnit =
                          widget.recipe["nutrients"][nutrientKey]["unit"];
                      return Card(
                        elevation: 8,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.08),
                          borderSide: BorderSide.none,
                        ),
                        color: Theme.of(context).colorScheme.onError,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.1,
                                  height: width * 0.1,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 152, 222, 222),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      nutrientValue.toString(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.025),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      nutrientKey,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      nutrientUnit,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8,
                        color: Theme.of(context).colorScheme.secondary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          borderSide: BorderSide.none,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                            horizontal: width * 0.05,
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.alarm),
                              Text(
                                "Prep time",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                '${widget.recipe["cooking_time"]}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Card(
                        elevation: 8,
                        color: Theme.of(context).colorScheme.secondary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          borderSide: BorderSide.none,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                            horizontal: width * 0.05,
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.person),
                              Text(
                                "Servings",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                '${widget.recipe["servings"]} Person',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: showIngredients
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  showIngredients = true;
                                });
                              },
                              child: Text(
                                "Ingredients",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: !showIngredients
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  showIngredients = false;
                                });
                              },
                              child: Text(
                                "Steps",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: showIngredients
                            ? Card(
                                elevation: 8,
                                color: Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.all(width * 0.045),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        widget.recipe["ingredients"].length,
                                        (index1) => Text(
                                          "${index1 + 1}. ${widget.recipe['ingredients'][index1]}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Card(
                                elevation: 8,
                                color: Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.all(width * 0.045),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        widget.recipe["recipe_steps"].length,
                                        (index1) => Text(
                                          "${index1 + 1}. ${widget.recipe['recipe_steps'][index1]}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
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
