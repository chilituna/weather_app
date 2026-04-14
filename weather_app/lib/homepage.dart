import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tabs/currently.dart';
import 'tabs/today.dart';
import 'tabs/weekly.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  decoration: InputDecoration(
                    hintText: 'Search city',
                    border: InputBorder.none,
                  ),
                   onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                setState(() {
                  _searchQuery = 'geolocation';
                });
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Currently(searchQuery: _searchQuery),
            Today(searchQuery: _searchQuery),
            Weekly(searchQuery: _searchQuery),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.cloud), text: 'Currently'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.view_week), text: 'Weekly'),
          ],
        ),
      ),
    );
  }
}
