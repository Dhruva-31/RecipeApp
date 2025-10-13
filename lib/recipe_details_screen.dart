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
    final recipeProvider = Provider.of<RecipeProvider>(context);
    if (!recipeProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
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
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 90),
                      Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.primary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [SizedBox(height: 60)],
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                right: 10,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.green),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
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
                                        widget.recipe['image_url'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
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
                        iconSize: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Card(
                      elevation: 8,
                      color: Theme.of(context).primaryColor,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      child: SizedBox(
                        width: 350,
                        height: 60,
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
                    padding: const EdgeInsets.only(left: 20.0, top: 25),
                    child: Text(
                      widget.recipe["name"],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      widget.recipe["cuisine"],
                      style: TextStyle(
                        color: const Color.fromARGB(255, 46, 44, 44),
                        fontSize: 18,
                        fontFamily: "Inter",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: 520,
                      child: Text(
                        widget.recipe["short_description"],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Nutritions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        color: Theme.of(context).colorScheme.onError,
                        child: SizedBox(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        152,
                                        222,
                                        222,
                                      ),
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
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      SizedBox(height: 2),
                                      Text(
                                        nutrientKey,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 2),
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
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 45),
                      Card(
                        elevation: 8,
                        color: Theme.of(context).colorScheme.secondary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.alarm),
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
                      SizedBox(width: 15),
                      Card(
                        elevation: 8,
                        color: Theme.of(context).colorScheme.secondary,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.person),
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

                  SizedBox(height: 30),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: showIngredients
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
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
                            width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: !showIngredients
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
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
                        duration: Duration(milliseconds: 100),
                        child: showIngredients
                            ? Card(
                                elevation: 8,
                                color: Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              widget
                                                  .recipe["ingredients"]
                                                  .length,
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
                                    ],
                                  ),
                                ),
                              )
                            : Card(
                                elevation: 8,
                                color: Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              widget
                                                  .recipe["recipe_steps"]
                                                  .length,
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
                                    ],
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
