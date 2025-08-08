import 'package:flutter/material.dart';
import 'package:report_designer/screens/designer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Designer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.grey[400],
      ),
      debugShowCheckedModeBanner: false,
      home: const DesignerScreen(),
    );
  }
}
