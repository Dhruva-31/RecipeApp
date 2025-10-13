import 'package:flutter/material.dart';
import 'package:recipe_app/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/recipe_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => RecipeProvider(),
        ),
      ],
      child: const RecipeApp(),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFFDEE791),
        scaffoldBackgroundColor: const Color(0xFFA3DC9A),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFFDEE791),
          onPrimary: const Color(0xFFDEE791),
          secondary: const Color(0xFFFFF9BD),
          onSecondary: const Color(0xFFFFF9BD),
          error: const Color.fromARGB(255, 226, 145, 91),
          onError: const Color.fromARGB(255, 226, 145, 91),
          surface: Colors.black,
          onSurface: Colors.black,
        ),
        fontFamily: "Roboto",
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          titleMedium: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          titleSmall: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          bodyLarge: TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
