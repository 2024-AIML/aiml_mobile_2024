// CommonScaffold.dart

import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final Widget title;
  final List<Widget>? actions;

  const CommonScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key); // key를 명시하지 않습니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xffD9D9D9),
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/infra_info');
              break;
            case 2:
              Navigator.pushNamed(context, '/navigator');
              break;
            case 3:
              Navigator.pushNamed(context, '/search_missing_person');
              break;
            case 4:
              Navigator.pushNamed(context, '/message');
              break;
            default:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: '내 주변'),
          BottomNavigationBarItem(icon: Icon(Icons.near_me), label: '길 안내'),
          BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: '친구 찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: '재난 문자 목록'),
        ],
      ),
    );
  }
}
