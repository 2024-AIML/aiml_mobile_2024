import 'package:flutter/material.dart';
import '../screens/ShowMessageList.dart'; // 수정된 부분: HomePage 위젯을 불러옴

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
      home: MyHomePage(), // 수정된 부분: MyHomePage 대신 HomePage를 사용
    );
  }
}