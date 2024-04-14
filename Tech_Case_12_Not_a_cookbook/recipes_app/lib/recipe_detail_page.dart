// import 'package:flutter/material.dart';
// import 'recipe.dart';

// class RecipeDetailPage extends StatelessWidget {
//   final Recipe recipe;

//   const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(recipe.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(recipe.imagePath,
//                 width: MediaQuery.of(context).size.width,
//                 height: 250,
//                 fit: BoxFit.cover),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Ingredients',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: Text(recipe.ingredients),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Instructions',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: Text(recipe.instructions),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io'; // Import this for File
import 'package:flutter/material.dart';
import 'recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title), // Display the recipe title on the app bar
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to avoid overflow when the content is too long
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(recipe.imagePath),
                width: double.infinity, // Make the image full width
                height: 300, // Set a fixed height for the image
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ingredients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                recipe.ingredients, // Display the ingredients
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Instructions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                recipe.instructions, // Display the cooking instructions
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
