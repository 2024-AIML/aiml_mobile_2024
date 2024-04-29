import 'dart:async';
//import 'dart:html';
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
  String? selectedLocation; //  선택된 약국 또는 병원을 저장하기 위한 변수
  final List<String> select = ['병원', '약국'];
  final List<String> items = ['거리순', '정확도순'];


  Future<void> _fetchMapData() async
  {
    final String cliendID = 'e0em8isfp0';
    final String clientSecret = 'SwigVFb4E6Bw3FBWS0VW6Ht4AKh6iD5RLCNI5HdI';
    final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=1170&h=1170&center=127.1054221,37.3591614&level=16';

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': cliendID,
      'X-NCP-APIGW-API-KEY': clientSecret,
    }; //HTTP 요청 헤더를 추가합니다.

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = Image.memory(imageBytes);
        setState(() {
          mapImage = image;
        });


        //약국 위치 표시하는 코드를 여기에 추가
      }
      else {
        throw Exception('Failed to fetch map data');
      }
    }
    catch (e) {
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
        title: Text('Infra Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mapImage != null)
            mapImage!,
          if (mapImage == null)
            CircularProgressIndicator(),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('약국'),
                  leading: Radio<String>(
                    value: '약국',
                    groupValue: selectedLocation,
                    onChanged: (String? value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('병원'),
                  leading: Radio<String>(
                    value: '병원',
                    groupValue: selectedLocation,
                    onChanged: (String? value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: items.first,
                      onChanged: (String? newValue) {
                        // Do something when the value changes
                      },
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}