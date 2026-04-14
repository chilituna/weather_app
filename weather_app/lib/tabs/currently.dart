import 'package:flutter/material.dart';

class Currently extends StatelessWidget {
  const Currently({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Current Weather',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}