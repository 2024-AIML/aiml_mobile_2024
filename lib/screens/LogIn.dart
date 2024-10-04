import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  // 아직 firebase 와 원만한 합의가 안 됐어요

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // Future<void> _signInWithEmailAndPassword() async{
  //   try{
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: _emailContoller.text,
  //       password: _pwController.text,
  //     );
  //     print('로그인 성공 : ${userCredential.user!.uid}');
  //
  //     // 홈으로 이동하든지 작업 넣어놓기
  //
  //   }
  //   catch(e){
  //     print('로그인 실패 : $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('로그인'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            SizedBox(height: 10.0),

            //Text('이름'),
            SizedBox(
              width: 25.0,
              child: TextField(
                controller: _emailContoller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "이메일을 입력하세요",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.green[900]!,)
                    )
                ),
              ),
            ),
            SizedBox(height: 10.0),

            //Text('이메일'),
            SizedBox(
              width: 25.0,
              child: TextField(
                controller: _pwController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "비밀번호를 입력하세요",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.green[900]!,)
                    )
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              // onPressed: _signInWithEmailAndPassword,
              onPressed: (){

              },
              style: ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.white),
              child: Text('로그인'),
            ),
            SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinMember()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.white),
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}