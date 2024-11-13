import 'dart:convert';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';
import 'package:aiml_mobile_2024/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MyPage extends StatefulWidget{
  //const Member({Key? key}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userName = '';
  String userPhone = '';
  String userId = '';
  Position? _currentPosition; // 현재 위치 저장
  String locationName = '';
  bool isLocationSaved = false; // 위치 저장 여부 추적


  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    fetchUserInfo(); // 페이지 로드 시 사용자 정보 가져오기
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    await _getCurrentLocation();
    // if (status.isGranted) {
    //   // 권한이 허용되었습니다.
    //   print("Location permission granted");
    //   await _getCurrentLocation(); // 위치 정보를 가져옵니다.
    // } else if (status.isDenied) {
    //   // 권한이 거부되었습니다.
    //   print("Location permission denied");
    // } else if (status.isPermanentlyDenied) {
    //   // 사용자 설정에서 권한을 영구적으로 거부한 경우
    //   print("Location permission permanently denied");
    //   openAppSettings(); // 사용자에게 앱 설정으로 이동하도록 안내합니다.
    // }
  }


  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://43.202.6.121:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userId = userData['id'] ?? 'Unknown';
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

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Current Location: $_currentPosition");
      await _getLocationName();
      await saveLocation();
    } catch (e) {
      print("Could not get the Location; $e");
    }
  }

  Future<void> _getLocationName() async {
    final latitude = _currentPosition!.latitude;
    final longitude = _currentPosition!.longitude;

    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyAWxd0Oro0zSSYhUMaKnlf1rOf-3O_tOhI'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['results'].isNotEmpty) {
        setState(() {
          locationName =
          jsonResponse['results'][0]['formatted_address']; // 첫 번째 주소를 사용
        });
      }
    } else {
      print("Failed to get location name: ${response.statusCode}");
    }
  }

  Future<void> saveLocation() async {
    if (_currentPosition != null) {
      final locationData = {
        "id": userId,
        "locationName": locationName, // 자동으로 가져온 위치 이름
        "latitude": _currentPosition!.latitude.toString(),
        "longitude": _currentPosition!.longitude.toString(),
      };
      print("Location data to be sent: $locationData");

      String? jwtToken = await getJwtToken();

      final response = await http.post(
        Uri.parse('http://43.202.6.121:8081/geocoding/userlocation'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(locationData),
      );

      if (response.statusCode == 200) {
        print("Location saved successfully!");
        setState(() {
          isLocationSaved = true; // 위치가 성공적으로 저장됨
        });
      } else {
        print("Failed to save location: ${response.statusCode}, ${response
            .body}");
      }
    }
  }

  Future<void> logout() async {
    // JWT 토큰 가져오기
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.post(
        Uri.parse('http://43.202.6.121:8081/logout'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('MyPage'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column( // Wrap the list in a Column to provide multiple children
        children: [
          Align(
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
                              SizedBox(height: 5.0), // Spacing between elements
                              Text(
                                userName.isNotEmpty
                                    ? userName
                                    : '이름을 불러오는 중...',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 5.0), // Spacing between elements
                              Text(
                                userPhone.isNotEmpty
                                    ? userPhone
                                    : '전화번호를 불러오는 중...',
                                style: TextStyle(
                                  fontSize: 14.0,
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
                            // Navigation logic for ChangeInfo screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('회원정보 수정'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
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
      ),
    );
  }
}