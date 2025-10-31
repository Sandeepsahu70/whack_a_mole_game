import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/whack_a_mole_screen.dart';

void main() {
  runApp(WhackAMoleApp());
}

class WhackAMoleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Whack-a-Mole Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WhackAMoleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
