import 'package:flutter/material.dart';

class ToolboxPanel extends StatelessWidget {
  const ToolboxPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Text(
          'Toolbox',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
