import 'package:wow/screens/HomeScreenAfterLogin.dart';

import '../firebase_options.dart';
import '../screens/AddFriend.dart';
import '../screens/MorseCode.dart';
import '../screens/MyPage.dart';
import '../screens/FriendsList.dart';
import '../screens/JoinMember.dart';
import '../screens/Navigation.dart';
import '../screens/Sample_showData.dart';
import '../screens/ShelterLocation.dart';
import '../service/LocationUpdate.dart';
import '../screens/PostDetailPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart';
import 'screens/LogIn.dart'; // ShowCustomSearchMessages.dart 파일 import
import 'screens/Address.dart';
import 'screens/ShelterLocation.dart';
import 'screens/InfraLocation.dart';
import '../screens/FriendsLocation.dart';
import '../screens/BeforeMember.dart';
import '../screens/ChangeInfo.dart';
import '../service/LocationUpdate.dart';
import '../screens/SignIn.dart';
import '../screens/HomeScreen.dart';
import '../screens/InfraLocation.dart';
import '../screens/ShelterLocation.dart';
import '../screens/FriendsLocation.dart';
import '../screens/ShowCustomSearchMessage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NaverMapSdk.instance.initialize(clientId: 'vbuyb9r3k9',
  //     onAuthFailed: (ex) {
  //       print("******네이버맵 인증 오류: $ex ******");
  //     });
  runApp(MyApp());
}
git
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreenAfterLogin(userName: 'main.dart 에서 바꿀 수 있음',),
        // 임시로 회원가입으로 해놓은 화면
        // '/infra_info': (context) => InfraScreen(),
        // '/navigator': (context) => ShelterLocationScreen(),
        // '/search_missing_person': (context) => FriendLocation(),
        '/message': (context) => ShowCustomSearchMessage(),
        '/MyPage' : (context) => MyPage(),
        '/Signup': (context) => JoinMember(),
        '/login': (context)=>SignIn(),
        '/AddFriend':(context)=>AddFriend(),
        '/HomeScreen':(context)=>HomeScreen(),
        '/HomeAfterLogin' : (context) => HomeScreenAfterLogin(userName: '나중에 바꿔야함'),
        //'/ChangeInfo':(context)=>ChangeInfo(documentId: documentId),
      },
    );
  }
}