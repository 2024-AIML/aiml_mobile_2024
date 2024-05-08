import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(BeforeMember());
}

class BeforeMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment(0.0, -0.6),
          child: Container(
            width: 385, // 박스의 너비
            height: 208, // 박스의 높이
            color: Colors.grey[200], // 박스의 색상
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
                              child: Image.file(
                                File('/Users/yoonjink/Desktop/user.png'),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // 추가: 원과 텍스트 사이 간격 조절
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '홍길동 님',
                              style: TextStyle(
                                fontSize: 18.0,
                                color:Colors.black,
                              ),
                            ),
                            Text(
                              '010 -1234- 5678',
                              style : TextStyle(
                                fontSize : 14.0,
                                color:Colors.black,
                              )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(onPressed: (){}, child: Text('개인정보 수정')),  //{}안에 회원가입 페이지로 이동
                        SizedBox(width: 20),
                        ElevatedButton(onPressed: (){}, child: Text('로그아웃')) //{}안에 클릭시 로그인 페이지로 이동
                      ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}