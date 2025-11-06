import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/game_card.dart';
import 'whack_a_mole_screen.dart';
import 'reaction_speed_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
              Color(0xFF533483),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                Expanded(
                  child: _buildGameGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '🎮 GAME HUB',
          style: GoogleFonts.orbitron(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              const Shadow(
                blurRadius: 10.0,
                color: Colors.purpleAccent,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your adventure',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildGameGrid() {
    final games = [
      GameData(
        title: 'Whack A Mole',
        emoji: '🐹',
        description: 'Test your reflexes!\nHit the moles as they pop up',
        color: Colors.green,
        onTap: () => Get.to(() => const WhackAMoleScreen()),
      ),
      GameData(
        title: 'Reaction Speed',
        emoji: '⚡',
        description: 'How fast can you react?\nTest your lightning reflexes',
        color: Colors.orange,
        onTap: () => Get.to(() => const ReactionSpeedScreen()),
      ),
      GameData(
        title: 'Memory Game',
        emoji: '🧠',
        description: 'Coming Soon!\nTrain your memory skills',
        color: Colors.blue,
        onTap: () => _showComingSoon('Memory Game'),
      ),
      GameData(
        title: 'Snake Game',
        emoji: '🐍',
        description: 'Coming Soon!\nClassic snake adventure',
        color: Colors.red,
        onTap: () => _showComingSoon('Snake Game'),
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return GameCard(gameData: games[index]);
      },
    );
  }

  void _showComingSoon(String gameName) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '🚀 Coming Soon!',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '$gameName is under development.\nStay tuned for updates!',
          style: GoogleFonts.orbitron(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: GoogleFonts.orbitron(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameData {
  final String title;
  final String emoji;
  final String description;
  final Color color;
  final VoidCallback onTap;

  GameData({
    required this.title,
    required this.emoji,
    required this.description,
    required this.color,
    required this.onTap,
  });
}
