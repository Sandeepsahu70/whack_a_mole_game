import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reaction_game_controller.dart';
import '../widgets/reaction_button.dart';

class ReactionSpeedScreen extends StatelessWidget {
  const ReactionSpeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReactionGameController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildGameArea(controller),
              ),
              _buildStatsArea(controller),
              const SizedBox(height: 20),
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
              '⚡ REACTION SPEED',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _showStatsDialog(),
            icon: const Icon(
              Icons.leaderboard,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(ReactionGameController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInstructions(controller),
          const SizedBox(height: 40),
          ReactionButton(controller: controller),
          const SizedBox(height: 40),
          _buildResultDisplay(controller),
        ],
      ),
    );
  }

  Widget _buildInstructions(ReactionGameController controller) {
    return Obx(() {
      String instruction;
      switch (controller.gameState.value) {
        case GameState.idle:
          instruction =
              'Tap the button to start!\nWait for GREEN, then tap as fast as you can!';
          break;
        case GameState.countdown:
          instruction = 'Get ready...';
          break;
        case GameState.waiting:
          instruction = 'Wait for it... DON\'T tap yet!';
          break;
        case GameState.ready:
          instruction = 'TAP NOW! 🚀';
          break;
        case GameState.tooSoon:
          instruction =
              'Oops! You tapped too early.\nWait for GREEN next time!';
          break;
        case GameState.result:
          instruction = 'Great job! Tap to play again.';
          break;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          instruction,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: Colors.white,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _buildResultDisplay(ReactionGameController controller) {
    return Obx(() {
      if (controller.gameState.value != GameState.result) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.green.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              '🎉 REACTION TIME',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${controller.lastReactionTime.value}ms',
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            if (controller.lastReactionTime.value ==
                controller.bestReactionTime.value)
              Text(
                '🏆 NEW BEST!',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsArea(ReactionGameController controller) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Best',
              controller.bestReactionTime.value > 0
                  ? '${controller.bestReactionTime.value}ms'
                  : '--',
              Colors.yellow,
            ),
            _buildStatItem(
              'Average',
              controller.averageReactionTime.value > 0
                  ? '${controller.averageReactionTime.value.toInt()}ms'
                  : '--',
              Colors.blue,
            ),
            _buildStatItem(
              'Rounds',
              '${controller.totalRounds.value}',
              Colors.purple,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showStatsDialog() {
    final controller = Get.find<ReactionGameController>();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '📊 Statistics',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogStatRow(
                    'Best Time:',
                    controller.bestReactionTime.value > 0
                        ? '${controller.bestReactionTime.value}ms'
                        : 'No data'),
                _buildDialogStatRow(
                    'Average Time:',
                    controller.averageReactionTime.value > 0
                        ? '${controller.averageReactionTime.value.toInt()}ms'
                        : 'No data'),
                _buildDialogStatRow(
                    'Total Rounds:', '${controller.totalRounds.value}'),
                _buildDialogStatRow(
                    'Last Time:',
                    controller.lastReactionTime.value > 0
                        ? '${controller.lastReactionTime.value}ms'
                        : 'No data'),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearStats();
              Get.back();
            },
            child: Text(
              'Clear Stats',
              style: GoogleFonts.orbitron(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
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

  Widget _buildDialogStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
