import 'dart:convert';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


Future<void> logout(BuildContext context) async {
  String? jwtToken = await getJwtToken(); // JWT 토큰 가져오기

  if (jwtToken != null) {
    final response = await http.post(
      Uri.parse('http://54.180.158.5:8081/logout'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      // 로그아웃 성공 시 JWT 토큰 삭제
      await removeJwtToken();

      // 로그아웃 후 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/HomeScreen');
    } else if (response.statusCode == 302) {
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
    Navigator.pushReplacementNamed(context, '/HomeScreen');
  }
}
