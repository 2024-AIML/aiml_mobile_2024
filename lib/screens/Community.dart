import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'PostDetailPage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:aiml_mobile_2024/screens/WritePost.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  List<NMarker>markers = [];
  Position? _currentPosition;
  NaverMapController? _controller;
  bool isLoading = true;
  Image? mapImage;

  // final List<Map<String, String>> posts = [
  //   {'title': 'title1', 'content': 'This is the content of post1.'},
  //   {'title': 'title2', 'content': 'This is the content of post2.'},
  //   {'title': 'title3', 'content': 'This is the content of post3.'}
  // ];

  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchPosts(); // API 호출
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
  // Post 데이터를 가져오는 함수
  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://13.209.84.51:8081/post/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // 데이터를 Map 형식으로 변환 후 posts 리스트에 저장
      setState(() {
        posts = data.map((post) {
          return {
            'title': post['title'],
            'content': post['content'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void navigateToContent(String title, String content) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailPage(title: title, content: content),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentPosition != null)
            Expanded(
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
                    _controller = controller;
                  });
                },
              ),
            ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: posts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:(context)=>PostDetailPage(
                                  title: post['title'] ?? 'No Title',
                                  content: post['content']?? 'No Content',
                                ),
                            ),
                            );
                          },

                       child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color:Colors.black,width:2.0,)
                          ),
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title']!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['content']!,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 10.0,
                    right: 10.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WritePost()),
                        );
                      },
                      icon: Icon(Icons.add_circle),
                      iconSize: 90.0,
                      color: Colors.grey[300],// Increase the size of the icon
                    ),
                  ),
                ], //children
              )
          )
        ], //children
      ),
    );
  }
}