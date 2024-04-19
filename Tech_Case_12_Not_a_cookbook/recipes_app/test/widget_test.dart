import 'package:flutter_test/flutter_test.dart';

import 'package:recipes_app/main.dart';

void main() {
  testWidgets('RecipesApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(RecipesApp());

    // Here, you would add your specific tests related to RecipesApp.
    // The original example is looking for a counter, which likely doesn't exist in your RecipesApp,
    // so you'll want to adjust these tests to reflect the actual functionality of your app.
  });
}
