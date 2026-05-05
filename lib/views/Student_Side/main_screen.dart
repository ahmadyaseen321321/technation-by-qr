import 'package:flutter/material.dart';
import '../../../res/Colors/colors.dart';
import 'package:technation_hub/views/Student_Side/Home_Screen/home_screen.dart';
import 'package:technation_hub/views/Student_Side/Discover_Screen/discover_screen.dart';
import 'package:technation_hub/views/Student_Side/Study_Groups_Screen/study_groups_screen.dart';
import 'package:technation_hub/views/Student_Side/AI_Screen/ai_screen.dart';
import 'package:technation_hub/views/Student_Side/Profile_Screen/profile_screen.dart';
import '../../res/components/side_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const DiscoverScreen(),
    const StudyGroupsScreen(),
    const OpenClawScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.greyColor,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Study Groups',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'OpenClaw',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColor.primaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
    );
  }
}
