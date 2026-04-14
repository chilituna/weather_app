import 'package:flutter/material.dart';

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 16, 189, 175),
      child: Center(
        child: Text(
          'Today\'s Weather',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}