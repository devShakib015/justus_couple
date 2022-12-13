import 'package:flutter/material.dart';
import 'package:justus_couple/views/chat/chat_page.dart';
import 'package:justus_couple/views/home/home_page.dart';
import 'package:justus_couple/views/profile/profile_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            label: 'Chat',
            selectedIcon: Icon(Icons.message),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            selectedIcon: Icon(Icons.person),
          ),
        ],
      ),
      body: const [HomePage(), ChatPage(), PofilePage()][_selectedIndex],
    );
  }
}
