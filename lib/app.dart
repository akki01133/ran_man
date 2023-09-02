import 'package:flutter/material.dart';
import 'package:ran_man/pages/grid_drawing.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: GridDrawingPage());
  }
}
