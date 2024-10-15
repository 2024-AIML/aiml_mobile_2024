import 'package:shared_preferences/shared_preferences.dart';

// JWT 토큰을 저장하는 함수
Future<void> saveJwtToken(String token) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwtToken', token);
}

// JWT 토큰을 불러오는 함수
Future<String?> getJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}

// JWT 토큰을 삭제하는 함수
Future<void> removeJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwtToken');
}