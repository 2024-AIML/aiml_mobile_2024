import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import '../widget/CommonScaffold.dart';

import 'HomeScreen.dart';


class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String name = '홍길동 님'; // Default values
  String phoneNum = '010-1234-5678';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(Uri.parse('http://localhost:8081/UserInfo/get?name=Kim'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        name = data['name']; // Fetch and update the name
        phoneNum = data['phoneNum']; // Fetch and update the phone number
      });
    } else {
      // Handle error
      print('Failed to load user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('MyPage'),
      body: Align(
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
                        children: <Widget>[
                          Text(
                            '$name', // Display fetched name
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '$phoneNum', // Display fetched phone number
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
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
                        //정보수정페이지
                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => ChangeInfo(documentId:documentId),),
                        //);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.white),
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
                      style: ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.white),
                      child: Text('로그아웃'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}