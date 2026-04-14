import 'package:flutter/material.dart';

class Weekly extends StatelessWidget {
  const Weekly({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 33, 221, 133),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weekly Weather',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            if (searchQuery.trim().isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                searchQuery,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}