import 'package:flutter/material.dart';
import 'tabs/currently.dart';
import 'tabs/today.dart';
import 'tabs/weekly.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search city',
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Currently(),
            Today(),
            Weekly(),
          ],
        ),
        bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.cloud),
                text: 'Currently',
              ),
              Tab(
                icon: Icon(Icons.today),
                text: 'Today',
              ),
              Tab(
                icon: Icon(Icons.view_week),
                text: 'Weekly',
              ),
            ],
        )
      ),
    );
  }
}