import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame_audio/flame_audio.dart';

class GameController extends GetxController {
  // Game state
  final RxInt score = 0.obs;
  final RxInt timeLeft = 30.obs;
  final RxBool isGameActive = false.obs;
  final RxInt activeMoleIndex = (-1).obs; // -1 means no mole visible
  final RxBool isMoleVisible = false.obs;

  // Timers
  Timer? _gameTimer;
  Timer? _moleTimer;

  // Constants
  static const int gameDuration = 30;
  static const int moleInterval = 1;
  static const int totalHoles = 9;

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
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    _moleTimer = Timer.periodic(Duration(seconds: moleInterval), (timer) {
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
      print('Hit sound not available: $e');
    }
  }

  void _playGameOverSound() {
    try {
      FlameAudio.play('game_over.wav');
    } catch (e) {
      // Sound file not found, continue without sound
      print('Game over sound not available: $e');
    }
  }

  void _showGameOverDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Game Over!'),
        content: Text('Final Score: ${score.value}'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              resetGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
