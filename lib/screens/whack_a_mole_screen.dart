import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';

class WhackAMoleScreen extends StatelessWidget {
  final GameController gameController = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text('Whack-a-Mole'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildGameStats(),
              SizedBox(height: 20),
              Expanded(
                child: _buildGameGrid(),
              ),
              SizedBox(height: 20),
              _buildControlButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
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
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  Widget _buildGameGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gridSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Center(
          child: Container(
            width: gridSize,
            height: gridSize,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return _buildHole(index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHole(int index) {
    return Obx(() {
      bool hasMole = gameController.activeMoleIndex.value == index &&
          gameController.isMoleVisible.value;

      return GestureDetector(
        onTap: () => gameController.hitMole(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.brown[600],
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.brown[800]!,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedScale(
              scale: hasMole ? 1.0 : 0.0,
              duration: Duration(milliseconds: 150),
              curve: Curves.bounceOut,
              child: AnimatedOpacity(
                opacity: hasMole ? 1.0 : 0.0,
                duration: Duration(milliseconds: 100),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
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

  Widget _buildControlButton() {
    return Obx(() {
      bool isGameActive = gameController.isGameActive.value;

      return ElevatedButton(
        onPressed: isGameActive ? null : () => gameController.startGame(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isGameActive ? Colors.grey : Colors.green[700],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 4,
        ),
        child: Text(
          isGameActive ? 'Game in Progress...' : 'Start Game',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}
