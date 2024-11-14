// CommonScaffold.dart

import 'package:flutter/material.dart';


class CommonScaffold extends StatefulWidget {
  final Widget title;
  final List<Widget>? actions;
  final List<Widget> pages;
  final Widget? leading;

  const CommonScaffold({
    Key? key,
    required this.title,
    required this.pages,
    this.actions,
    this.leading,
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white, // SafeArea 내부 배경색 설정
          child: IndexedStack(
            index: _selectedIndex,
            children: widget.pages,
          ),
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.content_paste_search), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.near_me), label: '길 안내'),
          BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: '친구 찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: '재난 문자 목록'),
        ],
      ),
    );
  }
}