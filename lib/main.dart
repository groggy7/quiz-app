import 'package:flutter/material.dart';
import 'question_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double deviceWidth = WidgetsBinding.instance.window.physicalSize.width; --> get device width
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionScreen(),
    );
  }
}
