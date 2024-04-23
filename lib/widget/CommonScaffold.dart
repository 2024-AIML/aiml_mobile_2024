// CommonScaffold.dart

import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final Widget title;

  const CommonScaffold({
    Key? key,
    required this.body,
    required this.title,
  }) : super(key: key); // key를 명시하지 않습니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'infra'),
          BottomNavigationBarItem(icon: Icon(Icons.near_me), label: 'navi'),
          BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: 'sear'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: 'mess'),
        ],
      ),
    );
  }
}
