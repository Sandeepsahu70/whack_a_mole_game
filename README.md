<<<<<<< HEAD
# Whack-a-Mole Game

A Flutter-based Whack-a-Mole game using GetX for state management.

## Features

- 3×3 grid with 9 holes
- Moles appear randomly every 1 second
- 30-second game timer
- Score tracking
- Responsive design
- Optional sound effects
- Clean animations with green/brown theme

## Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK (comes with Flutter)

### Installation & Running

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the game:**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── controllers/
│   └── game_controller.dart     # Game logic and state management
└── screens/
    └── whack_a_mole_screen.dart # Main game UI

assets/
├── images/
│   └── mole.png                 # Optional mole image (uses 🐹 emoji as fallback)
└── sounds/
    ├── hit.wav                  # Optional hit sound effect
    └── game_over.wav            # Optional game over sound effect
```

### How to Play

1. Tap "Start Game" to begin
2. Moles (🐹) will appear randomly in holes every second
3. Tap the mole to score points
=======
# whack_a_mole_game
A fun and interactive Whack-a-Mole game built entirely with Flutter and Dart, using GetX for state management. Test your reflexes by tapping on the moles as they pop up from random holes before the timer runs out! ⏰
>>>>>>> ec9a4f19d47055a9d09f25071247b33d8252f17a
