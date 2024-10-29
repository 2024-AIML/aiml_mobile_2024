import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart';

class BeforeMember extends StatefulWidget {
  @override
  _BeforeMemberState createState() => _BeforeMemberState();
}

class _BeforeMemberState extends State<BeforeMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  // Correctly initializing the AppBar
        title: Text('Before Member'),
        actions: [], // Add actions if needed
      ),
      body: Align(
        alignment: Alignment(0.0, -0.6),
        child: Container(
          width: 385, // Box width
          height: 208, // Box height
          color: Colors.grey[200], // Box color
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 372,
                  height: 148,
                  color: Color(0xFFCECECE),
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
                      SizedBox(width: 20), // Space between image and text
                      Text(
                        '환영합니다.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the sign-up page
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('회원가입'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login page
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('로그인'),
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


