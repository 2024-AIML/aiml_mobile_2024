import 'dart:convert';
import '../service/token_storage.dart';
import '../widget/CommonScaffold.dart';
import '../screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyPage extends StatefulWidget{
  //const Member({Key? key}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // 페이지 로드 시 사용자 정보 가져오기
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://13.209.84.51:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userName = userData['name'] ?? 'Unknown'; // name이 null이면 'Unknown'
          userPhone = userData['phoneNum'] ?? 'No phone';
        });
      } else {
        print("Failed to load user info: ${response.statusCode}, ${response
            .body}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  Future<void> logout() async {
    // JWT 토큰 가져오기
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.post(
        Uri.parse('http://localhost:8081/logout'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        // 로그아웃 성공 시 JWT 토큰 삭제
        await removeJwtToken();

        // 로그아웃 시 로그인 페이지로 이동
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      } else if (response.statusCode == 302) { // 302 에러
        var redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print("Redirecting to: $redirectUrl");
          Navigator.pushReplacementNamed(context, '/HomeScreen');
        }
      } else {
        print("Failed to logout: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('MyPage'),
      pages: [Align(
        alignment: Alignment(0.0, -0.6),
        child: Container(
          width: 385, // Box width
          height: 208, // Box height
          color: Colors.white, // Box color
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 360,
                  height: 140,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: ClipOval(
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/image/user.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // Spacing between image and text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$userName', // Display fetched name
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '$userPhone', // Display fetched phone number
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5.0), // Spacing between elements
                          Text(
                            userName.isNotEmpty ? userName : '이름을 불러오는 중...',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 5.0), // Spacing between elements
                          Text(
                            userPhone.isNotEmpty
                                ? userPhone
                                : '전화번호를 불러오는 중...',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //context,
                        // MaterialPageRoute(builder: (context) => ChangeInfo(documentId:documentId),),
                        // );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black,foregroundColor: Colors.white),
                      child: Text('회원정보 수정'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black,foregroundColor: Colors.white),
                      child: Text('로그아웃'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ],
    );
  }
}