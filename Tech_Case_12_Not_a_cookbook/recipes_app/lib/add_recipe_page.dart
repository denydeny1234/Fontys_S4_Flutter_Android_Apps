// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'database_helper.dart';
// import 'recipe.dart';

// class AddRecipePage extends StatefulWidget {
//   @override
//   _AddRecipePageState createState() => _AddRecipePageState();
// }

// class _AddRecipePageState extends State<AddRecipePage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController titleController = TextEditingController();
//   TextEditingController ingredientsController = TextEditingController();
//   TextEditingController instructionsController = TextEditingController();
//   String? imagePath;

//   final ImagePicker _picker = ImagePicker();

//   Future getImage() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Choose Image Source"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: Text("Camera"),
//                   onTap: () {
//                     _pickImage(ImageSource.camera);
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//                 Padding(padding: EdgeInsets.all(8.0)),
//                 GestureDetector(
//                   child: Text("Gallery"),
//                   onTap: () {
//                     _pickImage(ImageSource.gallery);
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         imagePath = pickedFile.path;
//       });

//       // Call a method to process the image and extract recipe details
//       detectRecipe(imagePath!);
//     }
//   }

//   Future<void> detectRecipe(String imagePath) async {
//     // Simulate parsing detected recipe details
//     // Here, we'll just set dummy values
//     final Map<String, String> recipeDetails = {
//       'title': 'Detected Recipe Title',
//       'ingredients': 'Ingredient 1, Ingredient 2, Ingredient 3',
//     };

//     // Update the title and ingredients controllers with the detected recipe details
//     titleController.text = recipeDetails['title'] ?? '';
//     ingredientsController.text = recipeDetails['ingredients'] ?? '';
//   }

//   void addRecipe() async {
//     if (_formKey.currentState!.validate()) {
//       Recipe newRecipe = Recipe(
//         title: titleController.text,
//         imagePath: imagePath ?? 'assets/images/default.jpg',
//         ingredients: ingredientsController.text,
//         instructions: instructionsController.text,
//       );

//       await DatabaseHelper.instance.create(newRecipe);
//       Navigator.pop(context); // Navigate back to the previous screen
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Recipe'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(8),
//           children: <Widget>[
//             TextFormField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a title';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: ingredientsController,
//               decoration: InputDecoration(labelText: 'Ingredients'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter ingredients';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: instructionsController,
//               decoration: InputDecoration(labelText: 'Instructions'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter instructions';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 10),
//             imagePath == null
//                 ? Text('No image selected.')
//                 : Image.file(File(imagePath!)),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Choose Image'),
//             ),
//             ElevatedButton(
//               onPressed: addRecipe,
//               child: Text('Add Recipe'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dart_openai/dart_openai.dart'; // Import OpenAI
import 'database_helper.dart';
import 'recipe.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  String? imagePath;

  final ImagePicker _picker = ImagePicker();
  late OpenAI openAI;

  @override
  void initState() {
    super.initState();
    openAI = OpenAI('YOUR_OPENAI_API_KEY');
  }

  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });

      // Call method to process the image and extract recipe details
      detectRecipe(imagePath!);
    }
  }

  Future<void> detectRecipe(String imagePath) async {
    try {
      // Call OpenAI to process the image and generate text
      final generatedText = await openAI.createCompletion(
        model: 'text-davinci-003', // Specify the GPT-3 model
        prompt: "Detect recipe in the image",
        maxTokens: 100,
        temperature: 0.7,
        image: imagePath,
      );

      // Extract the detected recipe details from the generated text
      final recipeDetails =
          parseRecipeDetails(generatedText.choices!.first.text!);

      // Update the title and ingredients controllers with the detected recipe details
      setState(() {
        titleController.text = recipeDetails['title'] ?? '';
        ingredientsController.text = recipeDetails['ingredients'] ?? '';
        instructionsController.text = recipeDetails['instructions'] ?? '';
      });
    } catch (e) {
      print('Error detecting recipe: $e');
    }
  }

  Map<String, String?> parseRecipeDetails(String generatedText) {
    // Implement logic to parse detected recipe details from the generated text
    // For simplicity, we'll just return a map with dummy values for now
    return {
      'title': 'Detected Recipe Title',
      'ingredients': 'Ingredient 1, Ingredient 2, Ingredient 3',
      'instructions': 'Step 1, Step 2, Step 3',
    };
  }

  void addRecipe() async {
    if (_formKey.currentState!.validate()) {
      Recipe newRecipe = Recipe(
        title: titleController.text,
        imagePath: imagePath ?? 'assets/images/default.jpg',
        ingredients: ingredientsController.text,
        instructions: instructionsController.text,
      );

      await DatabaseHelper.instance.create(newRecipe);
      Navigator.pop(context); // Navigate back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Recipe'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ingredients';
                }
                return null;
              },
            ),
            TextFormField(
              controller: instructionsController,
              decoration: InputDecoration(labelText: 'Instructions'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter instructions';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            imagePath == null
                ? Text('No image selected.')
                : Image.file(File(imagePath!)),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Choose Image'),
            ),
            ElevatedButton(
              onPressed: addRecipe,
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
