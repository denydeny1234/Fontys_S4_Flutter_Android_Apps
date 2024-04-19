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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'recipe.dart';
import 'package:http/http.dart' as http;

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
      final recipeDetails = await getRecipeDetails(imagePath);

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

  Future<Map<String, String?>> getRecipeDetails(String imagePath) async {
    try {
      // Encode the image to base64
      List<int> imageBytes = File(imagePath).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      // Make HTTP POST request to OpenAI API
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer sk-proj-JXynjwNYwHtb6JAp1xAOT3BlbkFJ8Fp2AeMux5w5ulkMGYYj',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': 'Detect recipe in the image',
          'max_tokens': 100,
          'temperature': 0.7,
          'image': base64Image,
        }),
      );

      // Parse response JSON
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String generatedText = responseData['choices'][0]['text'];

      // Parse the generated text to extract recipe details
      final Map<String, String?> recipeDetails =
          parseRecipeDetails(generatedText);

      return recipeDetails;
    } catch (e) {
      print('Error getting recipe details: $e');
      return {};
    }
  }

  Map<String, String?> parseRecipeDetails(String generatedText) {
    // Here you can implement your logic to parse the generated text
    // and extract recipe details such as title, ingredients, and instructions
    // For example, you can use regular expressions or string manipulation
    // For now, let's just return dummy values

    return {
      'title': 'Detected Recipe Title',
      'ingredients': 'Ingredient 1, Ingredient 2, Ingredient 3',
      'instructions': 'Step 1: Do something\nStep 2: Do something else',
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
