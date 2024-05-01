import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:aiml_mobile_2024/screens/infra_info.dart';
import 'package:flutter/material.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart';
import 'screens/LogIn.dart'; // ShowCustomSearchMessages.dart 파일 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // 이건 임시로 해놓은 화면
        '/infra_info': (context) => JoinMember(),
        '/navigator': (context) => Login(),
        '/search_missing_person': (context) => MyPage(),
        '/message': (context) => ShowCustomSearchMessage(),
      },
    );
  }
}

