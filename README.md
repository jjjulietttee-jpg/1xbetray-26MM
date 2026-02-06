# Neon Vault - English Version

Mobile gaming salon application with modern dark neon design.

## Description

Neon Vault is a Flutter application created for the "Salon gier" (gaming salon) niche. The application implements complete UI with premium gaming design in dark neon gaming salon style.

## Features

- 🎮 Modern dark neon design
- 📱 Responsive layout for mobile devices
- ✨ Interactive animations and glow effects
- 🏗️ Clean architecture (data / domain / presentation)
- 🎯 Using Slivers for smooth scrolling
- 🎨 Large UI elements with shadows and glow effects
- 🌍 Full English localization

## Screens

### OnboardingScreen
- 3 pages introducing the application
- PageView with smooth transitions
- Large titles with shadow and glow
- Animated navigation buttons
- Progress indicator

### HomeScreen
- Main screen with "PLAY" button
- Quick access to profile and achievements
- Player statistics
- Parallax effects on scroll

### GameScreen
- Placeholder for future game
- Gaming interface in neon style
- Animated elements
- Coming soon message

### ProfileScreen
- Player profile with editable name
- Achievement system (10 achievements)
- Detailed statistics
- Name input popup on first launch

## Technologies

- **Flutter** - main framework
- **go_router** - navigation
- **flutter_bloc** - state management (template)
- **talker_flutter** - logging (optional)

## Color Palette

- Primary colors: `#0B0B0F`, `#141421`
- Neon accents: purple (`#9D4EDD`), blue (`#3F37C9`), cyan (`#00F5FF`)
- Text: `#FFFFFF` with shadows

## Project Structure

```
lib/
├── core/
│   ├── shared/
│   │   ├── widgets/          # Reusable widgets
│   │   └── bloc/             # Base Bloc (template)
│   ├── extensions/           # Extensions
│   ├── utils/               # Constants and utilities
│   └── theme/               # App theme
├── features/
│   ├── onboarding/presentation/screens/
│   ├── home/presentation/screens/
│   ├── game/presentation/screens/
│   └── profile/presentation/screens/
├── main.dart                # Entry point
└── routes.dart             # Routing configuration
```

## SafeArea Implementation

All content is properly wrapped in SafeArea to avoid system UI overlaps:
- Status bar area is handled
- Navigation bar area is handled
- Content is always visible and accessible

## Running the Project

1. Make sure Flutter is installed
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter run`

## Next Steps

Current version contains complete UI implementation. Next phase planning:

- Game logic implementation
- Progress saving system
- Backend integration
- Leaderboard system
- Additional game modes

## License

This project is created to demonstrate Flutter capabilities in creating modern gaming applications.
