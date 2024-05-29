import 'package:aiml_mobile_2024/firebase_options.dart';
import 'package:aiml_mobile_2024/screens/FriendsList.dart';
import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
<<<<<<< HEAD
import 'package:aiml_mobile_2024/screens/infra_info.dart';
=======
import 'package:aiml_mobile_2024/screens/Navigation.dart';
import 'package:aiml_mobile_2024/screens/Sample_showData.dart';
import 'package:aiml_mobile_2024/screens/Navigation_Naver.dart';
>>>>>>> deb3a21d905bf5f2b041de00bf5e51dc802a3200
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../screens/ShowMap.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart';
import 'screens/LogIn.dart'; // ShowCustomSearchMessages.dart 파일 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NaverMapSdk.instance.initialize(clientId: '1dtmwihlto',
      onAuthFailed: (ex) {
        print("******네이버맵 인증 오류: $ex ******");
      });
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
        // 임시로 회원가입으로 해놓은 화면
        '/infra_info': (context) => MapScreen(),
        '/navigator': (context) => Navigator(),
        '/search_missing_person': (context) => FriendsList(),
        '/message': (context) => ShowCustomSearchMessage(),
        '/MyPage' : (context) => MyPage(),
      },
    );
  }
}