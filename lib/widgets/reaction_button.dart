import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reaction_game_controller.dart';

class ReactionButton extends StatelessWidget {
  final ReactionGameController controller;

  const ReactionButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: controller.buttonColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: controller.buttonColor.withOpacity(0.6),
                blurRadius:
                    controller.gameState.value == GameState.ready ? 30 : 15,
                spreadRadius:
                    controller.gameState.value == GameState.ready ? 10 : 5,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 3,
            ),
          ),
          child: AnimatedScale(
            scale: controller.gameState.value == GameState.ready ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: Text(
                controller.buttonText,
                style: GoogleFonts.orbitron(
                  fontSize: _getFontSize(),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _handleTap() {
    switch (controller.gameState.value) {
      case GameState.idle:
        controller.startGame();
        break;
      case GameState.waiting:
      case GameState.ready:
        controller.onTap();
        break;
      case GameState.result:
        controller.playAgain();
        break;
      default:
        break;
    }
  }

  double _getFontSize() {
    switch (controller.gameState.value) {
      case GameState.countdown:
        return 80;
      case GameState.ready:
        return 32;
      case GameState.tooSoon:
        return 28;
      default:
        return 24;
    }
  }
}
