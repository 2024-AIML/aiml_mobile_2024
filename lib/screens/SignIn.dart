import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../service/token_storage.dart';
import 'JoinMember.dart';
import 'MyPage.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(String id, String password) async {
    // String id = _idController.text; // 'id'로 변경
    // String password = _passwordController.text;

    final url = Uri.parse('http://10.0.2.2:8081/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': id, 'password': password},
    );

    print(response.body);

    if(response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if(responseData.containsKey('token') && responseData['token'] != null) {
        String jwtToken = responseData['token'];
        // JWT 토큰 저장
        await saveJwtToken(jwtToken);

        print('Login succesful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=> MyPage()),
        );
      } else {
        print('Token not found or null');
      }
    } else {
      print('Login failed: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10.0),
            TextField(
              controller: _idController,  // 'id'를 입력받기 위한 컨트롤러
              decoration: InputDecoration(
                labelText: "id",
                // border: OutlineInputBorder(),
                // hintText: "ID를 입력하세요",  // 프롬프트 수정
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                // border: OutlineInputBorder(),
                // hintText: "비밀번호를 입력하세요",
              ),
              obscureText: true,
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: (){
                _signIn(_idController.text, _passwordController.text);
              },
              child: Text('Login'),
              // onPressed: _signIn,
              // child: Text('로그인'),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinMember())
                  );
                }, child: Text('회원가입'))
          ],
        ),
      ),
    );
  }
}