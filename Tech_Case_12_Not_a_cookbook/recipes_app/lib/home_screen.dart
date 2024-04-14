import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipes_app/recipe_detail_page.dart';
import 'add_recipe_page.dart'; // Ensure this file exists and is correctly set up to add recipes
import 'database_helper.dart';
import 'recipe.dart'; // Ensure this file correctly defines the Recipe model

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false; // Tracks loading state
  List<Recipe> recipes = []; // List to store recipes

  @override
  void initState() {
    super.initState();
    loadRecipes(); // Load recipes when the widget is initialized
  }

  // Fetches recipes from the database and updates the UI
  void loadRecipes() async {
    setState(() => isLoading = true); // Show loading indicator
    recipes = await DatabaseHelper.instance.readAllRecipes(); // Fetch recipes
    setState(() =>
        isLoading = false); // Hide loading indicator once recipes are loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Home'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : recipes.isEmpty
              ? Center(
                  child: Text(
                      'No Recipes Found')) // Show this message if no recipes are available
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Card(
                      child: ListTile(
                        leading: Image.file(
                          File(recipe.imagePath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(recipe.title),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddRecipePage()), // Navigate to add recipe page
          ).then((value) {
            // Reload recipes after adding a new one
            loadRecipes();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
