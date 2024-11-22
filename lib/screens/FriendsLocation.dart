import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiml_mobile_2024/screens/AddFriend.dart';

class FriendLocation extends StatefulWidget {
  @override
  _FriendLocationState createState() => _FriendLocationState();
}

class _FriendLocationState extends State<FriendLocation> {
  List<Map<String, dynamic>> defaultFriends = [
    {
      'name': 'Hong',
      'phoneNum': '010-1234-5678',
      'latitude': 37.5563,
      'longitude': 126.9239,
    },
    {
      'name': 'Pae',
      'phoneNum': '010-2345-6789',
      'latitude': 37.5580, // 변경
      'longitude': 126.9260, // 변경
    },
    {
      'name': 'Yoon',
      'phoneNum': '010-3456-7890',
      'latitude': 37.5540, // 변경
      'longitude': 126.9220, // 변경
    },
    {
      'name': 'Na',
      'phoneNum': '010-4567-8901',
      'latitude': 37.5600, // 변경
      'longitude': 126.9200, // 변경
    },
    {
      'name': 'Ko',
      'phoneNum': '010-5678-9012',
      'latitude': 37.5520, // 변경
      'longitude': 126.9280, // 변경
    },
  ];


  TextEditingController searchController = TextEditingController();
  Position? _currentPosition;
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<List<DocumentSnapshot>> _fetchFriendList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USER_INFO')
          .doc('현재 사용자 ID') // Replace with the logged-in user's ID
          .collection('friends')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching friend list: $e');
      return [];
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _moveToFriendLocation(double latitude, double longitude, String name) {
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(latitude, longitude),
        ),
      );

      // 마커 생성
      final friendMarker = NMarker(
        id: 'friend_marker_${latitude}_${longitude}', // 고유 ID
        position: NLatLng(latitude, longitude),
        caption: NOverlayCaption( // 캡션 설정
          text: name, // 캡션에 표시할 이름
          textSize: 20, // 캡션 텍스트 크기
          color: Colors.green[700]!, // 캡션 텍스트 색상


        ),
      );

      // 마커 클릭 리스너 추가
      friendMarker.setOnTapListener((overlay) async {
        if (_currentPosition != null) {
          double currentLat = _currentPosition!.latitude;
          double currentLng = _currentPosition!.longitude;

          // 네이버 지도 URL 생성
          final Uri routeUrl = Uri.parse(
            'nmap://route/walk?slat=$currentLat&slng=$currentLng&sname=%EC%97%AC%EA%B8%B0%20%EC%9E%90%EB%A6%AC&dlat=$latitude&dlng=$longitude&dname=$name&appname=com.example.my_app',
          );

          // URL 실행
          if (await canLaunchUrl(routeUrl)) {
            await launchUrl(routeUrl);
          } else {
            print('Could not launch $routeUrl');
          }
        } else {
          print('Current position is null');
        }
      });

      // 마커 지도에 추가
      setState(() {
        _mapController!.addOverlay(friendMarker);
      });
    }
  }





  void _showAddFriendDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFriend()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 상단 친구 추가 버튼 및 제목
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "친구 위치",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showAddFriendDialog(context);
                  },
                  icon: Icon(Icons.person_add, color: Colors.black),
                ),
              ],
            ),
          ),

          // 지도 영역
          if (_currentPosition != null)
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                ),
                onMapReady: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
              ),
            )
          else
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
              child: Center(child: CircularProgressIndicator()),
            ),

          // 친구 목록
          Expanded(
            child: FutureBuilder(
              future: _fetchFriendList(),
              builder: (context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> friends = [];
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  friends = snapshot.data!
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                } else {
                  friends = defaultFriends;
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> friendData = friends[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.0), // 항목 간 간격
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all(color:Colors.green,width:2.0)
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        // 타일 크기 조정
                        leading:  Icon(
                              Icons.person, color: Colors.green, size: 24.0),
                        title: Text(
                          friendData['name'] ?? '이름 없음',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          friendData['phoneNum'] ?? '연락처 없음',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.grey, size: 16.0),
                        onTap: () {
                          double latitude = friendData['latitude'];
                          double longitude = friendData['longitude'];
                          String friendName = friendData['name'];
                          _moveToFriendLocation(
                              latitude, longitude, friendName);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}