import 'package:flutter/material.dart';

class Currently extends StatelessWidget {
  const Currently({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Weather',
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