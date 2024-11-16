import 'package:flutter/material.dart';
import 'screens/rotary_path_selector.dart';

void main() {
  runApp(const MinJoviApp());
}

class MinJoviApp extends StatelessWidget {
  const MinJoviApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Min JoVi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RotaryPathSelector(),
    );
  }
}