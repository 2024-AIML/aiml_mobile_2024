import 'dart:convert';
import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendLocation extends StatefulWidget {
  @override
  _FriendLocationState createState() => _FriendLocationState();
}

class _FriendLocationState extends State<FriendLocation> {
  List<Map<String, dynamic>> friends = [];
  TextEditingController searchController = TextEditingController();
  Position? _currentPosition;
  NaverMapController? _mapController;
  List<NMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchFriendList();

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

  void _moveToFriendLocation(double latitude, double longitude,name) {
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(latitude, longitude),
        ),
      );
      final friendMarker = NMarker(
        id: 'friend_marker_${latitude}_${longitude}', // 고유 ID
        position: NLatLng(latitude, longitude), // 위치 설정
      );

      // 마커 탭 리스너 설정 (필요하면 지원 여부 확인)
      friendMarker.setOnTapListener((overlay) {
        print('Marker tapped for $name');
      });

      // 마커 지도에 추가
      _mapController!.addOverlay(friendMarker);
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
          // 상단 친구 추가 버튼
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  _showAddFriendDialog(context);
                },
                icon: Icon(Icons.person_add, color: Colors.black),
              ),
            ),
          ),
          // 지도 영역
          if (_currentPosition != null)
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
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
            ),
          // 검색 바
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: '친구 검색',
                      labelStyle: TextStyle(color: Colors.green[900]),
                      hintText: '친구 이름을 입력하세요',
                      prefixIcon: Icon(Icons.search, color: Colors.green[900]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.green[900]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // 검색 로직
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),
          // 친구 목록
          Expanded(
            child: FutureBuilder(
              future: _fetchFriendList(),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('친구 목록이 없습니다.'));
                }

                List<DocumentSnapshot> friends = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> friendData =
                    friends[index].data() as Map<String, dynamic>;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                        title: Text(friendData['name'] ?? '이름 없음'),
                        subtitle: Text(friendData['email'] ?? '이메일 없음'),
                        onTap: () {
                          // 친구 위치로 이동
                          double latitude = friendData['latitude'];
                          double longitude = friendData['longitude'];
                          String friendName = friendData['name'];
                          _moveToFriendLocation(latitude, longitude, friendName);
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
