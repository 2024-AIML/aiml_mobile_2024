import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
  Image? mapImage;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchMapData();
    _getCurrentLocation();
  }

  Future<void> _fetchMapData() async {
    final String clientID = 'e0em8isfp0';
    final String clientSecret = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
    final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=1170&h=1170&center=127.1054221,37.3591614&level=16';

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': clientID,
      'X-NCP-APIGW-API-KEY': clientSecret,
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = Image.memory(imageBytes);
        setState(() {
          mapImage = image;
        });
      } else {
        throw Exception('지도 데이터를 가져오는데 실패했습니다.');
      }
    } catch (e) {
      print('지도 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infra Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mapImage != null)
            mapImage!,
          if (mapImage == null)
            CircularProgressIndicator(),
          if (_currentPosition != null)
            Text(
              '현재 위치: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
            ),
          if (_currentPosition == null)
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapScreen(),
  ));
}
