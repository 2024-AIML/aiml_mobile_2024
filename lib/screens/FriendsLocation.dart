import 'dart:convert';
import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../widget/CommonScaffold.dart';

class FriendLocation extends StatefulWidget {
  @override
  _FriendLocationState createState() => _FriendLocationState();
}

class _FriendLocationState extends State<FriendLocation> {
  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> filteredFriends = [];
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
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('api 주소 여기 입력'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          friends = data.cast<Map<String, dynamic>>();
          filteredFriends = friends;
        });
      } else {
        print('Failed to load friends');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterFriends(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results = friends;
    } else {
      results = friends
          .where((friend) =>
          friend['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredFriends = results;
    });
  }

  void _search() {
    String query = searchController.text;
    _filterFriends(query);
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

  void _moveToFriendLocation(double latitude, double longitude) {
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(latitude, longitude),
        ),
      );
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
      appBar: AppBar(
      title: Text('내 친구 찾기'),
      actions: [
        IconButton(
          icon: Icon(Icons.person_add),
          onPressed: () {
            _showAddFriendDialog(context);
          },
        ),
      ],
      ),
     body: Center(child: Stack(
        children: [
          // Map
          if (_currentPosition != null)
            NaverMap(
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
          // Loading Indicator
          if (isLoading)
            Center(child: CircularProgressIndicator()),
          // Search Bar
          Positioned(
            top: 50, // Adjust as needed
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: '검색',
                          labelStyle: TextStyle(color: Colors.green[900]),
                          hintText: '친구 이름을 입력하세요',
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.green[900]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // List of Friends
          Positioned(
            top: 110, // Adjust according to your design
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredFriends[index]['name']),
                  onTap: () {
                    double latitude = filteredFriends[index]['latitude'];
                    double longitude = filteredFriends[index]['longitude'];
                    _moveToFriendLocation(latitude, longitude);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
