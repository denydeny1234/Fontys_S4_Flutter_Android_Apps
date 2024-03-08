// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// // import 'package:flex_color_picker/flex_color_picker.dart';
// // import 'package:nfc_manager/nfc_manager.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Color Match App',
// //       home: ColorPickerScreen(),
// //     );
// //   }
// // }

// // class ColorPickerScreen extends StatefulWidget {
// //   @override
// //   _ColorPickerScreenState createState() => _ColorPickerScreenState();
// // }

// // class _ColorPickerScreenState extends State<ColorPickerScreen> {
// //   Color _selectedColor = Colors.blue;
// //   bool _isNFCReady = false;
// //   bool _isNFCAvailable = false;
// //   final AudioPlayer player = AudioPlayer();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initNFC();
// //     _loadSelectedColor();
// //   }

// //   void _initNFC() async {
// //     _isNFCReady = await NfcManager.instance.isAvailable();
// //     if (_isNFCReady) {
// //       setState(() {
// //         _isNFCAvailable = true;
// //       });
// //     }
// //   }

// //   void _openColorPicker() {
// //     ColorPicker(
// //       color: _selectedColor,
// //       onColorChanged: (Color color) {
// //         setState(() {
// //           _selectedColor = color;
// //         });
// //         _saveSelectedColor(color);
// //       },
// //       width: 40,
// //       height: 40,
// //       borderRadius: 15,
// //       heading: Text('Select a color'),
// //       recentColors: [
// //         Colors.red,
// //         Colors.green,
// //         Colors.blue,
// //         Colors.yellow,
// //       ],
// //     ).showPickerDialog(context);
// //   }

// //   void _saveSelectedColor(Color color) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setInt('selectedColor', color.value);
// //   }

// //   Future<void> _loadSelectedColor() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     int colorValue = prefs.getInt('selectedColor') ?? Colors.blue.value;
// //     setState(() {
// //       _selectedColor = Color(colorValue);
// //     });
// //   }

// //   void _checkColorMatch(Color otherColor) async {
// //     if (_selectedColor == otherColor) {
// //       await player.play(AssetSource('happy_sound.mp3'));
// //     } else {
// //       await player.play(AssetSource('sad_sound.mp3'));
// //     }
// //   }

// //   Future<void> _startNFCListening() async {
// //     // Simulate NFC listening by randomly selecting a color
// //     await Future.delayed(
// //         Duration(seconds: 1)); // Simulate a delay for NFC reading

// //     // Randomly select a color for simulation
// //     final random = math.Random();
// //     List<Color> simulatedColors = [
// //       Colors.red,
// //       Colors.green,
// //       Colors.blue,
// //       Colors.yellow
// //     ];
// //     Color simulatedOtherColor =
// //         simulatedColors[random.nextInt(simulatedColors.length)];

// //     // Check if the simulated color matches the selected color
// //     _checkColorMatch(simulatedOtherColor);

// //     return Future.value();
// //   }

// //   @override
// //   void dispose() {
// //     NfcManager.instance.stopSession();
// //     player.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Color Match App'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(
// //               'Selected Color:',
// //               style: TextStyle(fontSize: 18),
// //             ),
// //             SizedBox(height: 20),
// //             Container(
// //               width: 100,
// //               height: 100,
// //               color: _selectedColor,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _openColorPicker,
// //               child: Text('Pick a color'),
// //             ),
// //             SizedBox(height: 20),
// //             if (_isNFCAvailable)
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   await _startNFCListening();
// //                 },
// //                 child: Text('Start NFC Listening'),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flex_color_picker/flex_color_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Color Match App',
//       home: ColorPickerScreen(),
//     );
//   }
// }

// class ColorPickerScreen extends StatefulWidget {
//   @override
//   _ColorPickerScreenState createState() => _ColorPickerScreenState();
// }

// class _ColorPickerScreenState extends State<ColorPickerScreen> {
//   Color _selectedColor = Colors.blue;
//   Color? _simulatedOtherColor; // Make it nullable by adding a ?
//   bool _isNFCReady = false;
//   bool _isNFCAvailable = false;
//   final AudioPlayer player = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     _initNFC();
//     _loadSelectedColor();
//   }

//   void _initNFC() async {
//     _isNFCReady = await NfcManager.instance.isAvailable();
//     setState(() {
//       _isNFCAvailable = _isNFCReady;
//     });
//   }

//   void _openColorPicker() async {
//     // Use the color picker in a dialog
//     ColorPicker(
//       color: _selectedColor,
//       onColorChanged: (Color color) {
//         setState(() {
//           _selectedColor = color;
//         });
//         _saveSelectedColor(color);
//       },
//       width: 40,
//       height: 40,
//       borderRadius: 15,
//       heading: Text(
//         'Select a color',
//         style: Theme.of(context).textTheme.headline5,
//       ),
//       subheading: Text(
//         'Select color shade',
//         style: Theme.of(context).textTheme.subtitle1,
//       ),
//       pickersEnabled: const <ColorPickerType, bool>{
//         ColorPickerType.both:
//             true, // Enable both Material color picker and Accent color picker.
//       },
//       // Update the `onColorChanged` callback to also pop the dialog.
//       onColorChangeStart: (Color color) {
//         setState(() {
//           _selectedColor = color;
//         });
//       },
//       onColorChangeEnd: (Color color) {
//         setState(() {
//           _selectedColor = color;
//         });
//         _saveSelectedColor(color);
//         Navigator.of(context).pop(); // Hide the dialog
//       },
//     ).showPickerDialog(
//       context,
//       constraints: BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
//     );
//   }

//   void _saveSelectedColor(Color color) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('selectedColor', color.value);
//   }

//   Future<void> _loadSelectedColor() async {
//     final prefs = await SharedPreferences.getInstance();
//     int colorValue = prefs.getInt('selectedColor') ?? Colors.blue.value;
//     setState(() {
//       _selectedColor = Color(colorValue);
//     });
//   }

//   void _checkColorMatch(Color otherColor) async {
//     // Compare only the RGB values of the colors, ignoring the alpha channel.
//     bool colorsMatch = _selectedColor.red == otherColor.red &&
//         _selectedColor.green == otherColor.green &&
//         _selectedColor.blue == otherColor.blue;

//     if (colorsMatch) {
//       await player.play(AssetSource('happy_sound.mp3'));
//     } else {
//       await player.play(AssetSource('sad_sound.mp3'));
//     }
//   }

//   Future<void> _startNFCListening() async {
//     await Future.delayed(
//         Duration(seconds: 1)); // Simulate a delay for NFC reading

//     // Randomly select a color for simulation
//     final random = math.Random();
//     List<Color> simulatedColors = [
//       Colors.red,
//       Colors.green,
//       Colors.blue,
//       Colors.yellow
//     ];
//     Color simulatedOtherColor =
//         simulatedColors[random.nextInt(simulatedColors.length)];

//     setState(() {
//       _simulatedOtherColor = simulatedOtherColor;
//     });

//     _checkColorMatch(simulatedOtherColor); // Now calling the method correctly
//   }

//   @override
//   void dispose() {
//     NfcManager.instance.stopSession();
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Color Match App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Selected Color:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 100,
//               height: 100,
//               color: _selectedColor,
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _openColorPicker,
//               child: Text('Pick a color'),
//             ),
//             SizedBox(height: 40),
//             if (_isNFCAvailable)
//               ElevatedButton(
//                 onPressed: _startNFCListening,
//                 child: Text('Start NFC Listening'),
//               ),
//             if (_simulatedOtherColor != null) ...[
//               SizedBox(height: 40),
//               Text(
//                 'Simulated Other Color:',
//                 style: TextStyle(fontSize: 24),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: 100,
//                 height: 100,
//                 color: _simulatedOtherColor,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Match App',
      home: ColorPickerScreen(),
    );
  }
}

class ColorPickerScreen extends StatefulWidget {
  @override
  _ColorPickerScreenState createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  Color _selectedColor = Colors.blue;
  bool _isNFCReady = false;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initNFC();
    _loadSelectedColor();
  }

  void _initNFC() async {
    _isNFCReady = await NfcManager.instance.isAvailable();
    setState(() {
      _isNFCReady = _isNFCReady;
    });
  }

  void _openColorPicker() async {
    ColorPicker(
      color: _selectedColor,
      onColorChanged: (Color color) {
        setState(() {
          _selectedColor = color;
        });
        _saveSelectedColor(color);
      },
      width: 40,
      height: 40,
      borderRadius: 15,
      heading:
          Text('Select a color', style: Theme.of(context).textTheme.headline5),
      subheading: Text('Select color shade',
          style: Theme.of(context).textTheme.subtitle1),
      pickersEnabled: const <ColorPickerType, bool>{ColorPickerType.both: true},
      onColorChangeStart: (Color color) {
        setState(() {
          _selectedColor = color;
        });
      },
      onColorChangeEnd: (Color color) {
        setState(() {
          _selectedColor = color;
        });
        _saveSelectedColor(color);
        Navigator.of(context).pop();
      },
    ).showPickerDialog(
      context,
      constraints: BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  void _saveSelectedColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', color.value);
  }

  Future<void> _loadSelectedColor() async {
    final prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('selectedColor') ?? Colors.blue.value;
    setState(() {
      _selectedColor = Color(colorValue);
    });
  }

  void _checkColorMatch(Color otherColor) async {
    if (_selectedColor == otherColor) {
      await player.play(AssetSource('happy_sound.mp3'));
    } else {
      await player.play(AssetSource('sad_sound.mp3'));
    }
  }

  void _writeToNfc() async {
    if (!_isNFCReady) return;

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) return;
      var record = NdefRecord.createText(_selectedColor.value.toString());
      await ndef.write(NdefMessage([record]));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Color written to NFC Tag successfully!"),
          duration: Duration(seconds: 3),
        ),
      );
      NfcManager.instance.stopSession();
    });
  }

  void _readFromNfc() async {
    if (!_isNFCReady) return;

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) return;
      if (ndef.cachedMessage != null) {
        var record = ndef.cachedMessage!.records.first;
        String tagData = String.fromCharCodes(record.payload);

        // Remove non-numeric prefix if exists (e.g., 'en')
        final match = RegExp(r'(\d+)$').firstMatch(tagData);
        if (match != null) {
          try {
            var otherColorValue = int.parse(match.group(0)!);
            var otherColor = Color(otherColorValue);
            _checkColorMatch(otherColor);
          } catch (e) {
            print("Error parsing NFC tag data: $e");
          }
        } else {
          print("NFC Tag contains non-numeric data: $tagData");
        }
      }
      NfcManager.instance.stopSession();
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Match App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selected Color:', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Container(width: 100, height: 100, color: _selectedColor),
            SizedBox(height: 40),
            ElevatedButton(
                onPressed: _openColorPicker, child: Text('Pick a color')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _writeToNfc, child: Text('Write Color to NFC')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _readFromNfc, child: Text('Read Color from NFC')),
          ],
        ),
      ),
    );
  }
}
