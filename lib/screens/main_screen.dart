import 'package:flutter/material.dart';
import 'package:my_library/screens/home_screen.dart';
import 'package:my_library/screens/library_screen.dart';
import 'package:my_library/screens/search_screen.dart';
import 'package:my_library/widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final GlobalKey<NavigatorState> _searchNavigatorKey =
      GlobalKey<NavigatorState>();

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index == 1) {
      _searchNavigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToSearch(String query) {
    setState(() {
      _selectedIndex = 1; // Switch to the search tab
    });
    // Push the search screen onto the nested navigator
    _searchNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SearchScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          // Pass the navigation function to the HomeScreen
          HomeScreen(onSearch: _navigateToSearch),
          _buildSearchScreen(),
          const LibraryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Navigator(
      key: _searchNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            // The initial route is the empty search screen
            return const SearchScreen.empty();
          },
        );
      },
    );
  }
}
