import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/whack_a_mole_controller.dart';

class WhackAMoleScreen extends StatelessWidget {
  const WhackAMoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = Get.put(WhackAMoleController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF388E3C),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildGameContent(gameController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              '🐹 WHACK A MOLE',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _showDifficultyDialog(),
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(WhackAMoleController gameController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildGameStats(gameController),
          const SizedBox(height: 20),
          Expanded(
            child: _buildGameGrid(gameController),
          ),
          const SizedBox(height: 20),
          _buildControlButton(gameController),
        ],
      ),
    );
  }

  Widget _buildGameStats(WhackAMoleController gameController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => _buildStatItem('Score', '${gameController.score.value}')),
          Obx(() =>
              _buildStatItem('Time', '${gameController.timeLeft.value}s')),
          Obx(() => _buildStatItem('Difficulty', gameController.difficultyName,
              gameController.difficultyColor)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [Color? valueColor]) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: label == 'Difficulty' ? 16 : 24,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGameGrid(WhackAMoleController gameController) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gridSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Center(
          child: SizedBox(
            width: gridSize,
            height: gridSize,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Changed to 4x4 grid
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: 16, // Changed to 16 holes
              itemBuilder: (context, index) {
                return _buildHole(index, gameController);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHole(int index, WhackAMoleController gameController) {
    return Obx(() {
      bool hasMole = gameController.activeMoleIndex.value == index &&
          gameController.isMoleVisible.value;

      return GestureDetector(
        onTap: () => gameController.hitMole(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.brown[800],
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.brown[900]!,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedScale(
              scale: hasMole ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.bounceOut,
              child: AnimatedOpacity(
                opacity: hasMole ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🐹',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildControlButton(WhackAMoleController gameController) {
    return Obx(() {
      bool isGameActive = gameController.isGameActive.value;

      return ElevatedButton(
        onPressed: isGameActive ? null : () => gameController.startGame(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isGameActive ? Colors.grey[600] : Colors.white,
          foregroundColor: isGameActive ? Colors.white : Colors.green[700],
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 8,
        ),
        child: Text(
          isGameActive ? 'Game in Progress...' : 'START GAME',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  void _showDifficultyDialog() {
    final gameController = Get.find<WhackAMoleController>();

    if (gameController.isGameActive.value) {
      Get.snackbar(
        'Game Active',
        'Cannot change difficulty during game',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '⚙️ Select Difficulty',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DifficultyLevel.values.map((difficulty) {
            final settings = gameController.difficultySettings[difficulty]!;
            final isSelected =
                gameController.currentDifficulty.value == difficulty;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? settings['color'] : Colors.transparent,
                    width: 2,
                  ),
                ),
                tileColor: isSelected
                    ? settings['color'].withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                leading: Icon(
                  _getDifficultyIcon(difficulty),
                  color: settings['color'],
                  size: 24,
                ),
                title: Text(
                  settings['name'],
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _getDifficultyDescription(difficulty),
                  style: GoogleFonts.orbitron(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  gameController.changeDifficulty(difficulty);
                  Get.back();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDifficultyIcon(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Icons.sentiment_satisfied;
      case DifficultyLevel.medium:
        return Icons.sentiment_neutral;
      case DifficultyLevel.hard:
        return Icons.sentiment_dissatisfied;
      case DifficultyLevel.expert:
        return Icons.whatshot;
    }
  }

  String _getDifficultyDescription(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Slow moles, perfect for beginners';
      case DifficultyLevel.medium:
        return 'Moderate speed, good challenge';
      case DifficultyLevel.hard:
        return 'Fast moles, test your reflexes';
      case DifficultyLevel.expert:
        return 'Lightning fast, for experts only!';
    }
  }
}
