import 'package:aiml_mobile_2024/firebase_options.dart';
import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:aiml_mobile_2024/screens/HomeScreenAfterLogin.dart';
import 'package:aiml_mobile_2024/screens/MorseCode.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:aiml_mobile_2024/screens/FriendsList.dart';
import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/Navigation.dart';
import 'package:aiml_mobile_2024/screens/Sample_showData.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/service/LocationUpdate.dart';
import 'package:aiml_mobile_2024/screens/PostDetailPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShowCustomSearchMessage.dart';
import 'screens/LogIn.dart'; // ShowCustomSearchMessages.dart 파일 import
import 'screens/Address.dart';
import 'screens/ShelterLocation.dart';
import 'screens/InfraLocation.dart';
import '../screens/FriendsLocation.dart';
import '../screens/BeforeMember.dart';
import '../screens/ChangeInfo.dart';
import 'package:aiml_mobile_2024/service/LocationUpdate.dart';
import 'package:aiml_mobile_2024/screens/SignIn.dart';
import 'package:aiml_mobile_2024/screens/HomeScreen.dart';
import 'package:aiml_mobile_2024/screens/InfraLocation.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/screens/FriendsLocation.dart';
import 'package:aiml_mobile_2024/screens/ShowCustomSearchMessage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NaverMapSdk.instance.initialize(clientId: 'vbuyb9r3k9',
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // 임시로 회원가입으로 해놓은 화면
        '/home' :(context)=>HomeScreen(),
        '/infra_info': (context) => InfraScreen(),
        '/navigator': (context) => ShelterLocationScreen(),
        '/search_missing_person': (context) => FriendLocation(),
        '/message': (context) => ShowCustomSearchMessage(),
        '/MyPage' : (context) => MyPage(),
        '/Signup': (context) => JoinMember(),
        '/login': (context)=>SignIn(),
        '/AddFriend':(context)=>AddFriend(),
        '/HomeScreen':(context)=>HomeScreen(),
        //'/ChangeInfo':(context)=>ChangeInfo(documentId: documentId),
      },
    );
  }
}
