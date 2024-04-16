import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
  Image? mapImage;


  Future<void> _fetchMapData() async
  {
    final String cliendID = 'e0em8isfp0';
    final String clientSecret = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
    final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=1170&h=1170&center=127.1054221,37.3591614&level=16';

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': cliendID,
      'X-NCP-APIGW-API-KEY':clientSecret,
    };    //HTTP 요청 헤더를 추가합니다.

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = Image.memory(imageBytes);
        setState(() {
          mapImage = image;
        });
      }
      else {
        throw Exception('Failed to fetch map data');
      }
    }
    catch (e)
    {
      print('Error fetching map data: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchMapData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Naver Map'),
      ),
      body: Center(
        child: mapImage != null
              ?mapImage
              :CircularProgressIndicator(), // API 호출 완료를 기다리는 동안 로딩 인디케이터를 표시합니다.
      ),
    );
  }
}