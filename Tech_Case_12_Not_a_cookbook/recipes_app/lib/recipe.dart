// class Recipe {
//   final int? id; // Make id optional
//   final String title;
//   final String imagePath;

//   Recipe({
//     this.id, // Removed required keyword
//     required this.title,
//     required this.imagePath,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id, // It's okay if id is null here, the database will handle it
//       'title': title,
//       'imagePath': imagePath,
//     };
//   }

//   factory Recipe.fromMap(Map<String, dynamic> map) {
//     print("Converting map to Recipe: $map");
//     return Recipe(
//       id: map['id'] as int?,
//       title: map['title'] as String? ?? 'Unknown Title',
//       imagePath: map['imagePath'] as String? ?? 'assets/images/default.jpg',
//     );
//   }

//   Recipe copy({int? id, String? title, String? imagePath}) {
//     return Recipe(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       imagePath: imagePath ?? this.imagePath,
//     );
//   }
// }

class Recipe {
  final int? id;
  final String title;
  final String imagePath;
  final String ingredients;
  final String instructions;

  Recipe({
    this.id,
    required this.title,
    required this.imagePath,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
        id: map['id'] as int?,
        title: map['title'] as String? ?? 'Unknown Title',
        imagePath: map['imagePath'] as String? ?? 'assets/images/default.jpg',
        ingredients: map['ingredients'] as String? ??
            '', // Default to empty string if null
        instructions: map['instructions'] as String? ??
            '' // Default to empty string if null
        );
  }

  Recipe copy({
    int? id,
    String? title,
    String? imagePath,
    String? ingredients,
    String? instructions,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }
}
