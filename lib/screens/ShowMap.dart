import 'dart:async';
//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../service/InfraInfoService.dart';

class InfraScreen extends StatefulWidget {
  @override
  _InfraScreenState createState() => _InfraScreenState();
}

class _InfraScreenState extends State<InfraScreen> {
  final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  Image? mapImage;
  String? selectedLocation;
  final List<String> select = ['병원', '약국'];
  List _hospitals = [];
  List _pharmacies = [];
  List<NMarker> markers = [];
  Position? _currentPosition;
  NaverMapController? _controller;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchMapData();
    _getCurrentLocation();
    _fetchHospitals();
    _fetchPharmacies();
    _updateMarkers();
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
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      _fetchHospitals();
      _fetchPharmacies();

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
    if (_currentPosition != null) {
      try {
        final data = await InfraInfoService.fetchHospitals(
            _currentPosition!.latitude, _currentPosition!.longitude);
        print(data);
        setState(() {
          _hospitals = data;
          isLoading = false;
        });
        _updateMarkers();
      } catch (e) {
        print('Error fetching hospitals: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchPharmacies() async {
    if (_currentPosition != null) {
      try {
        final data = await InfraInfoService.fetchPharmacies(
            _currentPosition!.latitude, _currentPosition!.longitude);
        print(data);
        setState(() {
          _pharmacies = data;
          isLoading = false;
        });
        _updateMarkers();
      } catch (e) {
        print('Error fetching hospitals: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _updateMarkers() {
    setState(() {
      markers = [];
      if (selectedLocation == '병원') {
        markers = _hospitals.map((hospital) {
          print('Adding marker for hospital: ${hospital.name}, Lat: ${hospital
              .latitude}, Lon: ${hospital.longitude}');
          return NMarker(
            id: hospital.name,
            position: NLatLng(hospital.latitude, hospital.longitude),
          );
        }).toList();


      } else if (selectedLocation == '약국') {
        markers = _pharmacies.map((pharmacy) {
          return NMarker(
            id: pharmacy.name,
            position: NLatLng(pharmacy.latitude, pharmacy.longitude),
          );
        }).toList();
      }
      print('Markers list: $markers');

      if (_controller != null) {
        _controller!.clearOverlays().then((_) {
          for (var marker in markers) {
            _controller!.addOverlay(marker).then((_) {
              print('Marker added to map.');
              setState(() {

              });
            }).catchError((e) {
              print('Error adding marker: $e');
            });
          }
        }).catchError((e) {
          print('Error clearing overlays: $e');
        });
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
                                _updateMarkers(); // Update markers when '약국' radio button is selected
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
                                _updateMarkers(); // Update markers when '병원' radio button is selected
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (selectedLocation == '병원')
                    Expanded(
                      child: ListView.builder(
                        itemCount: _hospitals.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_hospitals[index].name),
                            subtitle: Text(
                                '${_hospitals[index].distance?.toStringAsFixed(
                                    2)} km'),
                          );
                        },
                      ),
                    ),
                  if (selectedLocation == '약국')
                    Expanded(
                      child: ListView.builder(
                        itemCount: _pharmacies.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_pharmacies[index].name),
                            subtitle: Text(
                              '${_pharmacies[index].distance?.toStringAsFixed(2)}km'
                            )
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