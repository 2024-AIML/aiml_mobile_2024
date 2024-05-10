import 'package:aiml_mobile_2024/firebase_options.dart';
import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:aiml_mobile_2024/screens/Sample_showData.dart';
import 'package:aiml_mobile_2024/screens/infra_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../screens/ShowMap.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart';
import 'screens/LogIn.dart'; // ShowCustomSearchMessages.dart 파일 import
import 'screens/Sample_showData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => JoinMember(),
        // 임시로 회원가입으로 해놓은 화면
        '/infra_info': (context) => MapScreen(),
        // '/navigator': (context) => Navigator(),
        // '/search_missing_person': (context) => SearchMissingPerson(),
        '/message': (context) => ShowCustomSearchMessage(),
      },
    );
  }
}