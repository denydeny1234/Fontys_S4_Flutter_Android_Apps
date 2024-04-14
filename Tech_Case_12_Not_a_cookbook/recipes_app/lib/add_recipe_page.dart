import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
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

  Future getImage() async {
    // Show a dialog with options
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
    }
  }

  void addRecipe() async {
    print("Trying to add recipe");
    if (_formKey.currentState!.validate()) {
      print("Form is valid");
      Recipe newRecipe = Recipe(
        title: titleController.text,
        imagePath: imagePath ?? 'assets/images/default.jpg',
        ingredients: ingredientsController.text,
        instructions: instructionsController.text,
      );
      print("Recipe to add: ${newRecipe.toMap()}");
      await DatabaseHelper.instance.create(newRecipe);
      print("Recipe added");
      Navigator.pop(
          context); // This should take you back to the previous screen
    } else {
      print("Form is not valid");
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
