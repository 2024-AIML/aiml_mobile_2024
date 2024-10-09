import 'package:wow/screens/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wow/screens/AddFriend.dart';
import 'package:wow/screens/FriendsNotification.dart';
import 'package:wow/screens/MyPage.dart';

import 'firebase_options.dart';
import 'screens/JoinMember.dart';
import 'screens/ShowCustomSearchMessage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // FirebaseOptions 설정
  );
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NaverMapSdk.instance.initialize(clientId: '1dtmwihlto',
  //     onAuthFailed: (ex) {
  //       print("******네이버맵 인증 오류: $ex ******");
  //     });
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
        // '/infra_info': (context) => InfraScreen(),
        // '/navigator': (context) => ShelterLocationScreen(),
        // '/search_missing_person': (context) => FriendLocation(),
        '/message': (context) => ShowCustomSearchMessage(),
        '/MyPage' : (context) => MyPage(),
        '/Signup': (context) => JoinMember(),
        // '/login': (context)=>Login(),
        '/AddFriend':(context)=>AddFriend(),
      },
    );
  }
}