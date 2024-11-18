import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'PostDetailPage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
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
    try{
    final response = await http.get(Uri.parse('http://3.34.139.173:8081/post/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      // 데이터를 Map 형식으로 변환 후 posts 리스트에 저장
      setState(() {
        posts = data.map((post) {
          return {
            'title': post['title'],
            'content': post['content'],
            'latitude': post['latitude'],
            'longitude': post['longitude'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {setState(() {
    posts = [{'title': '저 홍대 4공학관인데 살려주세요', 'content': '여기에 사람이 8명이나 있는데 이 글 보신다면 찾으러 와주세요'},
      {'title': '내 눈앞에 미사일 날라감 ㅋㅋ', 'content': '이거 실제 상황임?'},
      {'title': '이 상황에서 어떻게 살아남냐고?', 'content': '요즘 같은 난리통에 다들 멘붕인거 알겠는데, 어쨋든 살아남아야 하지 않겠냐? 내가 몇 가지 생존 팁 좀 풀어 본다. 뭐 기본적으로 물이랑 먹을 거 챙겨두는 거 필수고, 어디 안전하게 숨을 곳 있는지 미리 알아둬라. 그리고 막 나가지 말고 눈치껏 상황 파악 잘 하면서 살아남자고. 다들 자신만의 팁 있으면 공유하자. 여기서라도 살아남아야지.'},
      {'title': '아 배고프다', 'content': '우리집 통조림 다 떨어졌는데 통조림 나눔 좀 해주세요'},];
  });}}

  void navigateToContent(String title, String content) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailPage(title: title, content: content),
        )
    );
  }

  void _addMarker(double latitude, double longitude, String title) {
    final marker = NMarker(
      id: 'marker_${latitude}_${longitude}',
      position: NLatLng(latitude, longitude),
    );

    setState(() {
      markers.add(marker);
    });

    marker.setOnTapListener((overlay) {
      print('Marker tapped: $title');
    });

    setState(() {
      markers.add(marker);
    });

    _controller?.addOverlay(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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

                    for(var marker in markers) {
                      controller.addOverlay(marker);
                    }
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
                      : ListView.separated(
                    itemCount: posts.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white, // 리스트 아이템 간 구분선
                      height: 10.0,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final String title = post['title'] ?? '제목 없음';
                      final String content = post['content'] ?? '내용 없음';


                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                title: title,
                                content: content,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.green[900]!, width: 1.5),
                          ),

                          title: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                content,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green[900],
                            size: 16.0,
                          ),
                          contentPadding: EdgeInsets.all(12.0),
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
                    iconSize: 70.0,
                    color: Colors.green[900], // 버튼 색상
                  ),
                ),
              ],
            ),
          )

        ], //children
      ),
    );
  }
}