import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FriendsInfo extends StatefulWidget {
  final String friendsName;
  final GeoPoint friendsLocation;

  FriendsInfo({required this.friendsName, required this.friendsLocation});

  @override
  _FriendsInfoState createState() => _FriendsInfoState();
}

class _FriendsInfoState extends State<FriendsInfo> {
  Image? mapImage;

  @override
  void initState() {
    super.initState();
    _fetchMapData();
  }

  Future<void> _fetchMapData() async {
    print('친구 위치: ${widget.friendsLocation.latitude}, ${widget.friendsLocation.longitude}');

    final String clientID = 'e0em8isfp0';
    final String clientSecret = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
    final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=1170&h=1170&center=${widget.friendsLocation.longitude},${widget.friendsLocation.latitude}&level=16';

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': clientID,
      'X-NCP-APIGW-API-KEY': clientSecret,
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = Image.memory(imageBytes);
        setState(() {
          mapImage = image;
        });
      } else {
        throw Exception('지도 데이터를 가져오는데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('지도 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('친구 이름: ${widget.friendsName}'),
            SizedBox(height: 20),
            if (mapImage != null)
              mapImage!,
            if (mapImage == null)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
