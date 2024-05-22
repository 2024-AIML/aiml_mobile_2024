import 'package:flutter/material.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold.dart 파일 import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const CommonScaffold(
          title: Text('Home'),
          body: Center(
            child: Text(
              "이제 여기에다가 구현하시면 됩니다. "
                  "다른 것들도 페이지 만들어서 비슷하게 위에다가 연결하시면 될 듯해요...",
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.account_box_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}