import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_audio/flame_audio.dart';

enum GameState { idle, countdown, waiting, ready, tooSoon, result }

class ReactionGameController extends GetxController {
  // Game state
  final Rx<GameState> gameState = GameState.idle.obs;
  final RxInt countdownValue = 3.obs;
  final RxInt lastReactionTime = 0.obs;
  final RxInt bestReactionTime = 0.obs;
  final RxDouble averageReactionTime = 0.0.obs;
  final RxInt totalRounds = 0.obs;

  // Internal variables
  Timer? _gameTimer;
  Timer? _countdownTimer;
  int _readyTime = 0;
  final List<int> _reactionTimes = [];

  // Constants
  static const String _bestTimeKey = 'best_reaction_time';
  static const String _totalRoundsKey = 'total_rounds';
  static const String _reactionTimesKey = 'reaction_times';

  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }

  void startGame() {
    if (gameState.value != GameState.idle) return;

    gameState.value = GameState.countdown;
    countdownValue.value = 3;

    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue.value > 1) {
        countdownValue.value--;
      } else {
        timer.cancel();
        _startWaitingPhase();
      }
    });
  }

  void _startWaitingPhase() {
    gameState.value = GameState.waiting;

    // Random delay between 1-3 seconds
    final random = Random();
    final delay = 1000 + random.nextInt(2000); // 1000-3000ms

    _gameTimer = Timer(Duration(milliseconds: delay), () {
      _showReadyState();
    });
  }

  void _showReadyState() {
    gameState.value = GameState.ready;
    _readyTime = DateTime.now().millisecondsSinceEpoch;
    _playReadySound();
  }

  void onTap() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    switch (gameState.value) {
      case GameState.waiting:
        _handleTooSoon();
        break;
      case GameState.ready:
        _handleCorrectTap(currentTime);
        break;
      default:
        break;
    }
  }

  void _handleTooSoon() {
    gameState.value = GameState.tooSoon;
    _gameTimer?.cancel();

    // Auto reset after 2 seconds
    Timer(const Duration(seconds: 2), () {
      resetGame();
    });
  }

  void _handleCorrectTap(int tapTime) {
    final reactionTime = tapTime - _readyTime;
    lastReactionTime.value = reactionTime;

    // Update statistics
    _reactionTimes.add(reactionTime);
    totalRounds.value++;

    // Update best time
    if (bestReactionTime.value == 0 || reactionTime < bestReactionTime.value) {
      bestReactionTime.value = reactionTime;
    }

    // Update average
    averageReactionTime.value =
        _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;

    gameState.value = GameState.result;
    _saveData();
  }

  void resetGame() {
    gameState.value = GameState.idle;
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
  }

  void playAgain() {
    resetGame();
    startGame();
  }

  void _playReadySound() {
    try {
      FlameAudio.play('beep.wav');
    } catch (e) {
      // Sound file not available, continue without sound
      print('Ready sound not available: $e');
    }
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bestReactionTime.value = prefs.getInt(_bestTimeKey) ?? 0;
      totalRounds.value = prefs.getInt(_totalRoundsKey) ?? 0;

      final savedTimes = prefs.getStringList(_reactionTimesKey) ?? [];
      _reactionTimes.clear();
      _reactionTimes.addAll(savedTimes.map((e) => int.parse(e)));

      if (_reactionTimes.isNotEmpty) {
        averageReactionTime.value =
            _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
      }
    } catch (e) {
      print('Error loading saved data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_bestTimeKey, bestReactionTime.value);
      await prefs.setInt(_totalRoundsKey, totalRounds.value);
      await prefs.setStringList(
          _reactionTimesKey, _reactionTimes.map((e) => e.toString()).toList());
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  void clearStats() {
    _reactionTimes.clear();
    bestReactionTime.value = 0;
    averageReactionTime.value = 0.0;
    totalRounds.value = 0;
    lastReactionTime.value = 0;
    _saveData();
  }

  Color get buttonColor {
    switch (gameState.value) {
      case GameState.idle:
        return Colors.blue;
      case GameState.countdown:
        return Colors.orange;
      case GameState.waiting:
        return Colors.red;
      case GameState.ready:
        return Colors.green;
      case GameState.tooSoon:
        return Colors.red.shade800;
      case GameState.result:
        return Colors.purple;
    }
  }

  String get buttonText {
    switch (gameState.value) {
      case GameState.idle:
        return 'START GAME';
      case GameState.countdown:
        return countdownValue.value.toString();
      case GameState.waiting:
        return 'WAIT...';
      case GameState.ready:
        return 'TAP NOW!';
      case GameState.tooSoon:
        return 'TOO SOON!';
      case GameState.result:
        return 'PLAY AGAIN';
    }
  }
}
