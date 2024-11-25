import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:aiml_mobile_2024/screens/HomeScreenAfterLogin.dart';
import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/LogIn.dart';
import 'package:aiml_mobile_2024/screens/SignIn.dart';
import 'package:aiml_mobile_2024/screens/MorseCode.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:aiml_mobile_2024/screens/FriendsNotification.dart';
import 'package:aiml_mobile_2024/screens/Guidelines.dart';
import 'package:aiml_mobile_2024/screens/Community.dart';
import 'package:aiml_mobile_2024/screens/InfraLocation.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/screens/FriendsLocation.dart';
import 'package:aiml_mobile_2024/screens/ShowCustomSearchMessage.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold.dart file import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title:Text('') ,
      pages: [

        Stack(
        children: [
          // Main content of the screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Center the tiles vertically
              children: [
                const Spacer(flex: 3),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/login'); // Replace with your login route
                  },
                  child: Container(
                    width: 300,
                    // Adjust width to your preference
                    height: 60,
                    // Adjust height to your preference
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      // Background color
                      borderRadius: BorderRadius.circular(20),
                      // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 20, // Adjust text size
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between the tiles
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/Signup'); // Replace with your sign-up route
                  },
                  child: Container(
                    width: 300,
                    // Adjust width to your preference
                    height: 60,
                    // Adjust height to your preference
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      // Background color
                      borderRadius: BorderRadius.circular(20),
                      // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 20, // Adjust text size
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),

          Positioned(
            top:3.0,
            right: 16.0,
            child: IconButton(
                onPressed: (){_showOptionsModal(context);
            }, icon: Icon(Icons.person)),
          ),

          Positioned(
              top: 3.0, right: 56.0,
              child: IconButton(onPressed: () {
                _showMenu(context);
              }, icon:Icon(Icons.help_outline, color: Colors.black),))
        ],
      ),
        Community(),               // Page 1 - 내 주변
        ShelterLocationScreen(),     // Page 2 - 길 안내
        FriendLocation(),            // Page 3 - 친구 찾기
        ShowCustomSearchMessage()   // Page 4 - 재난 문자 목록
    ],
    );
  }
}

void _showOptionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('마이페이지'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search_outlined),
              title: const Text('친구추가'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriend()),
                );
              },
            ),
            ListTile(
                leading: const Icon(Icons.group_add_outlined),
                title: const Text('친구요청'),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>  NotificationsPage()),
                  );
                }
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('로그인'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('회원가입'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> JoinMember()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap:(){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()),);
            }
            )
          ],
        ),
      );
    },
  );
}

void _showMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('모스부호 변환기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MorseCodePage()),
                );
              },
            ),
            ListTile(
              title: const Text('행동 지침 안내'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidelinePage()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

