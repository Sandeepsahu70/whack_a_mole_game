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
          const SizedBox(width: 48), // Balance the back button
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
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
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
}
