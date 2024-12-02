import 'package:flutter/material.dart';
import 'insights_screen.dart';
import 'orders_graph_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const MainScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    InsightsScreen(),
    const OrdersGraphScreen(),
  ];

  final List<String> _screenTitles = [
    'Order Insights',
    'Order Trends',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_screenTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.toggleTheme(); // Toggle theme
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(

            icon: Icon(Icons.trending_up),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Order Trends',
          ),
        ],
      ),
    );
  }
}
