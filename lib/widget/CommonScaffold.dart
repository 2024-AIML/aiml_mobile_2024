// CommonScaffold.dart

import 'package:flutter/material.dart';
import 'package:aiml_mobile_2024/screens/HomeScreen.dart';
import 'package:aiml_mobile_2024/screens/InfraLocation.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/screens/FriendsLocation.dart';
import 'package:aiml_mobile_2024/screens/ShowCustomSearchMessage.dart';

class CommonScaffold extends StatefulWidget {
  final Widget title;
  final List<Widget>? actions;
  final List<Widget> pages;

  const CommonScaffold({
    Key? key,
    required this.title,
    required this.pages,
    this.actions,
  }) : super(key: key);

  @override
  _CommonScaffoldState createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: widget.actions,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xffD212121),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.content_paste_search), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.near_me), label: '길 안내'),
          BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: '친구 찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: '재난 문자 목록'),
        ],
      ),
    );
  }
}


