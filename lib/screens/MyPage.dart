import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyPage extends StatefulWidget{
  //const Member({Key? key}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text("내 정보"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffD9D9D9),
            ),
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 400,
                  height: 55,
                  // margin: EdgeInsets.only(right: .0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 5.0,),
                      Text(
                        '홍길동',
                        style: TextStyle(fontSize: 16.0,),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        'AAA @ email.com',
                        style: TextStyle(fontSize: 11.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.yellow,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // 첫 번째 버튼 동작
                        },
                        child: Text('개인정보수정',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.yellow,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // 두 번째 버튼 동작
                        },
                        child: Text('로그아웃',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
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