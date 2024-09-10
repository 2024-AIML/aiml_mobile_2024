import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/SearchFriend.dart';
import '../widget/CommonScaffold.dart';

class FriendLocation extends StatefulWidget {
  @override
  _FriendLocationState createState() => _FriendLocationState();
}

class _FriendLocationState extends State<FriendLocation> {
  List<String> friends = [];
  List<String> filteredFriends = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  Position? _currentPosition;
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _getCurrentLocation();
  }

  Future<void> _fetchFriends() async {
    setState(() {
      isLoading = true; // 데이터 로딩 중
    });
    try {
      // API 주소를 입력하세요.
      final response = await http.get(Uri.parse('api 주소 여기 입력'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          friends = data.cast<String>();
          filteredFriends = friends; // 초기에는 전체 목록 표시
        });
      } else {
        // 오류 처리
        print('Failed to load friends');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // 로딩 완료
      });
    }
  }

  // 검색 필터링
  void _filterFriends(String query) {
    List<String> results = [];
    if (query.isEmpty) {
      results = friends;
    } else {
      results = friends
          .where((friend) =>
          friend.toLowerCase().contains(query.toLowerCase())) // 대소문자 구분 없이 검색
          .toList();
    }
    setState(() {
      filteredFriends = results;
    });
  }

  // 확인 버튼 눌렀을 때 동작
  void _search() {
    _filterFriends(searchController.text);
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

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('내 친구 찾기'),
      body: Column(
        children: [
          if (isLoading) // 로딩 중일 때
            Center(child: CircularProgressIndicator())
          else
            ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: '이름 또는 전화번호를 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0), // 검색 필드와 버튼 간의 간격
                    ElevatedButton(
                      onPressed: _search,
                      child: Text('확인'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0),

              Container(
                height: 100.0,
                color: Colors.grey[300],
                child: Center(
                  child: Text('여기에 친구 개인정보'),
                ),
              ),
              SizedBox(height: 50.0),
              // Adjust the space between the box and the map
              if (_currentPosition != null) // 지도 표시
                Flexible(
                  flex: 15, // 지도 크기 조절
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
              Expanded(
                flex: 4, // Adjust flex value to control the list's size
                child: ListView.builder(
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredFriends[index]),
                    );
                  },
                ),
              ),
            ],
        ],
      ),
    );
  }
}