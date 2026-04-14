import 'package:flutter/material.dart';

class Weekly extends StatelessWidget {
  const Weekly({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 33, 221, 133),
      child: Center(
        child: Text(
          'Weekly Weather',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}