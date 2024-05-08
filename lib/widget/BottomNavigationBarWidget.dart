import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xffD9D9D9),
      onTap: (int index){
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
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.place), label: 'infra'),
        BottomNavigationBarItem(icon: Icon(Icons.near_me), label: 'navi'),
        BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: 'sear'),
        BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: 'mess')
      ],
    );
  }
}