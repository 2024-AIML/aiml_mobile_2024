import 'package:flutter/material.dart';
// import '../screens/ShowMessageList.dart'; // 수정된 부분: HomePage 위젯을 불러옴
import '../screens/ShowCustomSearchMessage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '얼렁뚱땅',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(), // ShowMessageList 에 있는 클래스 - 생성자
    );
  }
}