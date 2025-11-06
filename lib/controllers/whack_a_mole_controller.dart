import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame_audio/flame_audio.dart';

enum DifficultyLevel { easy, medium, hard, expert }

class WhackAMoleController extends GetxController {
  // Game state
  final RxInt score = 0.obs;
  final RxInt timeLeft = 30.obs;
  final RxBool isGameActive = false.obs;
  final RxInt activeMoleIndex = (-1).obs; // -1 means no mole visible
  final RxBool isMoleVisible = false.obs;
  final Rx<DifficultyLevel> currentDifficulty = DifficultyLevel.easy.obs;

  // Timers
  Timer? _gameTimer;
  Timer? _moleTimer;

  // Constants
  static const int gameDuration = 30;
  static const int totalHoles = 16; // Changed to 4x4 grid

  // Difficulty settings
  Map<DifficultyLevel, Map<String, dynamic>> get difficultySettings => {
        DifficultyLevel.easy: {
          'moleInterval': 1500, // 1.5 seconds
          'moleVisibleTime': 1200, // 1.2 seconds
          'name': 'Easy',
          'color': Colors.green,
        },
        DifficultyLevel.medium: {
          'moleInterval': 1000, // 1 second
          'moleVisibleTime': 900, // 0.9 seconds
          'name': 'Medium',
          'color': Colors.orange,
        },
        DifficultyLevel.hard: {
          'moleInterval': 700, // 0.7 seconds
          'moleVisibleTime': 600, // 0.6 seconds
          'name': 'Hard',
          'color': Colors.red,
        },
        DifficultyLevel.expert: {
          'moleInterval': 500, // 0.5 seconds
          'moleVisibleTime': 400, // 0.4 seconds
          'name': 'Expert',
          'color': Colors.purple,
        },
      };

  @override
  void onInit() {
    super.onInit();
    resetGame();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _moleTimer?.cancel();
    super.onClose();
  }

  void startGame() {
    if (isGameActive.value) return;

    isGameActive.value = true;
    timeLeft.value = gameDuration;
    score.value = 0;

    // Start game countdown timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        endGame();
      }
    });

    // Start mole appearance timer
    _startMoleTimer();
  }

  void _startMoleTimer() {
    final settings = difficultySettings[currentDifficulty.value]!;
    final interval = settings['moleInterval'] as int;

    _moleTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if (isGameActive.value) {
        _showRandomMole();
      }
    });

    // Show first mole immediately
    _showRandomMole();
  }

  void _showRandomMole() {
    if (!isGameActive.value) return;

    // Hide current mole first
    hideMole();

    // Show new mole at random position
    final random = Random();
    activeMoleIndex.value = random.nextInt(totalHoles);
    isMoleVisible.value = true;

    // Auto-hide mole after visible time based on difficulty
    final settings = difficultySettings[currentDifficulty.value]!;
    final visibleTime = settings['moleVisibleTime'] as int;

    Timer(Duration(milliseconds: visibleTime), () {
      if (activeMoleIndex.value != -1 && isMoleVisible.value) {
        hideMole();
      }
    });
  }

  void hideMole() {
    activeMoleIndex.value = -1;
    isMoleVisible.value = false;
  }

  void hitMole(int holeIndex) {
    if (!isGameActive.value ||
        !isMoleVisible.value ||
        activeMoleIndex.value != holeIndex) {
      return;
    }

    // Increment score
    score.value++;

    // Hide mole immediately
    hideMole();

    // Play hit sound if available
    _playHitSound();
  }

  void endGame() {
    isGameActive.value = false;
    _gameTimer?.cancel();
    _moleTimer?.cancel();
    hideMole();

    // Play game over sound if available
    _playGameOverSound();

    // Show game over dialog
    _showGameOverDialog();
  }

  void resetGame() {
    isGameActive.value = false;
    score.value = 0;
    timeLeft.value = gameDuration;
    hideMole();
    _gameTimer?.cancel();
    _moleTimer?.cancel();
  }

  void _playHitSound() {
    try {
      FlameAudio.play('hit.wav');
    } catch (e) {
      // Sound file not found, continue without sound
      debugPrint('Hit sound not available: $e');
    }
  }

  void _playGameOverSound() {
    try {
      FlameAudio.play('game_over.wav');
    } catch (e) {
      // Sound file not found, continue without sound
      debugPrint('Game over sound not available: $e');
    }
  }

  void _showGameOverDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎮 Game Over!',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Final Score: ${score.value}',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Difficulty: ${difficultySettings[currentDifficulty.value]!['name']}',
              style: TextStyle(
                color: difficultySettings[currentDifficulty.value]!['color'],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              resetGame();
            },
            child: const Text(
              'Play Again',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Go back to home screen
            },
            child: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void changeDifficulty(DifficultyLevel newDifficulty) {
    if (!isGameActive.value) {
      currentDifficulty.value = newDifficulty;
    }
  }

  String get difficultyName =>
      difficultySettings[currentDifficulty.value]!['name'];
  Color get difficultyColor =>
      difficultySettings[currentDifficulty.value]!['color'];
}
