import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold.dart 파일 import
import '../screens/JoinMember.dart'; // JoinMember.dart 파일 import
import '../screens/ShowCustomSearchMessage.dart'; // ShowCustomSearchMessages.dart 파일 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '얼렁뚱땅',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: JoinMember()//MyHomePage(), // ShowMessageList 에 있는 클래스 - 생성자
    );
  }
}