# Developing apps with 3D designs in Flutter

This project is developed to showcase how we can use some basic principles to convert any 3D design into a working application using Flutter. It demonstrates the creation of interactive 3D-like experiences using image sequences and gesture detection.

---

## 📋 Project Overview

This Flutter application showcases how to create stunning 3D-like visual effects by using image sequences and gesture-based interactions. The project includes features like:

- Interactive 3D bike visualization using image sequences
- Gesture-based interactions (drag to rotate)
- Animated transitions
- Responsive UI design
- Display of bike specifications in an interactive manner

---

## 🛠️ Technical Stack & Versions

### **Flutter Version**
- **Dart SDK**: `>= 3.0.0 < 4.0.0`
- **Flutter SDK**: Latest version compatible with Dart 3.0.0+
- **Build Gradle**: Latest version (Android)

### **Dependencies**

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.9

dev_dependencies:
  flutter_test:
    sdk: flutter
```

### **Key Features Used**
- Material Design
- SingleTickerProviderStateMixin for animation
- MediaQuery for responsive design
- Image assets and sequence handling
- Gesture detection (drag interactions)

---

## 📁 Project Structure

```
flutter_3d/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── home_page.dart            # Home page with 3D visualization
│   └── utils/
│       └── image_sequence.dart   # Image sequence utilities
├── assets/
│   ├── bikeImageSequence/        # Sequence images for 3D effect
│   └── images/                   # Static images (bike specs, etc.)
├── pubspec.yaml                  # Project configuration
├── android/                      # Android platform configuration
├── ios/                          # iOS platform configuration
└── web/                          # Web platform configuration
```

---

## 📦 Project Configuration

### **pubspec.yaml**

```yaml
name: some3d
description: project to showcase 'principles of 3D design in flutter'
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.9

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/bikeImageSequence/
    - assets/images/
```

---

## 💻 Code Breakdown

### **1. Main Entry Point - main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:some3d/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
```

**Explanation:**
- `main()`: Entry point of the application
- `MyApp`: Root widget that sets up the MaterialApp
- `debugShowCheckedModeBanner: false`: Removes the debug banner
- `primarySwatch: Colors.blue`: Sets the primary color theme
- `HomePage()`: The main page of the application

### **2. Home Page - home_page.dart (Partial)**

```dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:some3d/utils/image_sequence.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  late double bikeSpecsWidth;
  late double addedScreenHeight;
  late double onDragPositionStart;
  bool isBikeSpecsVisible = false;
  late AnimationController animationController;

  // List of bike specification images
  List<String> bikeSpecsImages = [
    'assets/images/bike_specs_disp.png',
    'assets/images/bike_specs_type.png',
    'assets/images/bike_specs_break.png',
    'assets/images/bike_specs_cylinder.png',
    'assets/images/bike_specs_fuel.png',
    'assets/images/bike_specs_height.png',
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
```

**Key Components Explained:**

- **StatefulWidget**: Used because the page requires state management for animations and user interactions
- **SingleTickerProviderStateMixin**: Provides animation ticker for smooth animations
- **AnimationController**: Manages animations with a 1200ms duration
- **MediaQuery**: Gets device screen dimensions for responsive design
- **bikeSpecsImages**: Array of image paths for bike specifications
- **initState()**: Called when widget is created, initializes the animation controller
- **dispose()**: Cleans up resources when widget is destroyed
- **didChangeDependencies()**: Called when screen dimensions change

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter 3.0.0 or higher installed
- Dart 3.0.0 or higher
- Android SDK (for Android development)
- Xcode (for iOS development)
- A code editor (VS Code, Android Studio, etc.)

### **Installation Steps**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/syedmohamedafsal/royalenfield_metro.git
   cd flutter_3d-main
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **For specific platform:**
   ```bash
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   
   # Web
   flutter run -d chrome
   ```

---

## 🎮 How It Works

### **3D Image Sequence Rendering**
The app uses image sequences to create a 3D-like effect:
- Multiple images are loaded as assets
- Gesture detection (drag) determines which image to display
- Smooth transitions between images create the illusion of 3D rotation

### **Gesture Handling**
- **Drag Gestures**: Users can drag across the screen to rotate the bike
- **Position Tracking**: The drag position is tracked to calculate rotation offset
- **Animation**: Smooth animations bridge between frames

### **State Management**
- Animation states are managed using `AnimationController`
- UI updates are triggered based on gesture and animation values
- Screen metrics are calculated dynamically for responsiveness

---

## 📱 Supported Platforms

- ✅ **Android**: API 16+
- ✅ **iOS**: 11.0+
- ✅ **Web**: Chrome, Firefox, Safari
- ✅ **Desktop**: Windows, macOS, Linux (with proper SDK)

---

## 📂 Asset Structure

```
assets/
├── bikeImageSequence/
│   ├── bike_1.png
│   ├── bike_2.png
│   ├── bike_3.png
│   └── ... (more rotation frames)
└── images/
    ├── bike_specs_disp.png
    ├── bike_specs_type.png
    ├── bike_specs_break.png
    ├── bike_specs_cylinder.png
    ├── bike_specs_fuel.png
    └── bike_specs_height.png
```

---

## 🎨 Design Principles

1. **Image Sequences**: Using multiple images at different angles to simulate 3D rotation
2. **Gesture Recognition**: Tracking user drag input to control rotation
3. **Smooth Animation**: Using Flutter's animation framework for fluid transitions
4. **Responsive Layout**: Adapting UI to different screen sizes using MediaQuery
5. **Material Design**: Following Google's Material Design guidelines

---

## ⚙️ Building for Production

### **Android Build**
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### **iOS Build**
```bash
flutter build ios --release
```

### **Web Build**
```bash
flutter build web --release
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Assets not loading | Verify asset paths in `pubspec.yaml` and run `flutter clean` |
| Animation lag | Ensure `SingleTickerProviderStateMixin` is used correctly |
| Screen size issues | Use `MediaQuery` to get device dimensions dynamically |
| Build errors | Run `flutter pub get` and `flutter clean` before building |

---

## 📝 Version History

- **v1.0.0** - Initial release with 3D bike visualization

---

## 👨‍💻 Developer

**Syed Mohamed Afsal**

Instagram: [@syedmd_afsal](https://instagram.com/syedmd_afsal)

---

## 📄 License

This project is open source and available for educational and commercial use.

---

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Dart Team for the powerful language
- Community for continuous support and feedback
