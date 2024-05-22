import 'dart:async';
//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../service/InfraInfoService.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  Image? mapImage;
  String? selectedLocation;
  final List<String> select = ['병원', '약국'];
  List<dynamic> _hospitals = [];
  List<dynamic> _pharmacies = [];
  List<NMarker> markers = [];
  Position? _currentPosition;
  NaverMapController? _controller;
  final InfraInfoService _infraInfoService = InfraInfoService();


  @override
  void initState() {
    super.initState();
    _fetchMapData();
    _getCurrentLocation();
  }

  Future<void> _fetchMapData() async
  {
    final String clientId = 'vbuyb9r3k9';
    final String clientSecret = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
    final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=1170&h=1170&center=127.1054221,37.3591614&level=16';

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': clientId,
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
      }
      else {
        throw Exception('Failed to fetch map data');
      }
    }
    catch (e) {
      print('Error fetching map data: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      _fetchHospitals();

      if (_controller != null) {
        _controller!.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(
                _currentPosition!.latitude, _currentPosition!.longitude),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> _fetchHospitals() async {
    if (_currentPosition == null) return;

    try {
      final hospitals = await _infraInfoService.fetchHospitals(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      setState(() {
        _hospitals = hospitals;
      });

      _updateMarkers();
    } catch (e) {
      print("Error fetching hospitals: $e");
    }
  }

  void _updateMarkers() {
    setState(() {
      markers = _hospitals.map((hospital) {
        return NMarker(
          id: hospital.name,
          position: NLatLng(hospital.lat, hospital.lng),
        );
      }).toList();
      if (_controller != null) {
        _controller!.clearOverlays();
        for (var marker in markers) {
          _controller!.addOverlay(marker);
        }
      }
    });
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
          if (_currentPosition != null)
            Expanded(
                child: NaverMap(
                  options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                  ),
                  onMapReady: (controller){
                    _controller = controller;
                    _updateMarkers();
                  },
                )
            ),
          if (_currentPosition != null)
            Expanded(
              child: Column(
                children: [
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
                                _updateMarkers();
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
                                _updateMarkers();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _hospitals.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_hospitals[index].name),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _pharmacies.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_pharmacies[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}