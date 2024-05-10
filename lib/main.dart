// import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/infra_info.dart';
import 'package:flutter/material.dart';
import '../screens/ShowMap.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart'; // ShowCustomSearchMessages.dart 파일 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => JoinMember(),
        // 이건 임시로 해놓은 화면
        '/infra_info': (context) => MapScreen(),
        // '/navigator': (context) => Navigator(),
        // '/search_missing_person': (context) => SearchMissingPerson(),
        '/message': (context) => ShowCustomSearchMessage(),
      },
    );
  }
}