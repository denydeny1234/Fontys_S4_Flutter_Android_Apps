# NFC Color Match App
Welcome to the NFC Color Match App! This application allows users to read colors from NFC tags and play sounds based on whether the picked color matches the NFC tag's color.

## Features
- **NFC Color Reading:** Utilizes NFC technology to write and read colors encoded on NFC tags.
- **Color Matching:** Compares the picked color with the color from the NFC tag and plays a happy sound if they match.
- **Color Picker:** Allows users to select colors visually using a color picker.
- **Audio Feedback:** Provides audio feedback in the form of happy or sad sounds based on color matching results.
- **Shared Preferences:** Persists the selected color across app sessions using shared preferences.

  
## Installation
To run the NFC Color Match App locally, follow these steps:

### Clone the repository:
`git clone https://github.com/yourusername/Fontys_S4_Flutter_Android_Apps.git`

### Navigate to the project directory:
`cd Fontys_S4_Flutter_Android_Apps/Tech_Case_6_What_is_your_color`

### Ensure you have Flutter and Dart installed. If not, follow the instructions [here](https://docs.flutter.dev/get-started/install).

### Run the app:
`flutter run`


## Usage
- Upon launching the app, users will see a color picker interface where they can select a color.
- Users can pick a color by tapping the "Pick a color" button.
- To write the selected color to an NFC tag, tap the "Write Color to NFC" button.
- To read a color from an NFC tag, tap the "Read Color from NFC" button.
- If the picked color matches the color from the NFC tag, a happy sound will be played. Otherwise, a sad sound will be played.

  
## Dependencies
- Flutter SDK
- NFC Manager Plugin
- Audioplayers Plugin
- Flex Color Picker Plugin
- Shared Preferences Plugin


## Acknowledgements
- This app was built using Flutter, a UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- NFC Manager Plugin and Audioplayers Plugin were used to integrate NFC functionality and audio feedback into the app.
