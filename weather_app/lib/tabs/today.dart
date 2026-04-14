import 'package:flutter/material.dart';

class Today extends StatelessWidget {
  const Today({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 16, 189, 175),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Today\'s Weather',
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