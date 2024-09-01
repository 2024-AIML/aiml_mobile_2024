import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../service/ShelterInfoService.dart';
import 'package:csv/csv.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class ShelterScreen extends StatefulWidget {
  @override
  _ShelterScreenState createState() => _ShelterScreenState();
}

class _ShelterScreenState extends State<ShelterScreen> {
  final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  Image? mapImage;
  String? selectedLocation;
  List<Shelter> _shelters = [];
  List<NMarker> markers = [];
  Position? _currentPosition;
  NaverMapController? _controller;
  bool isLoading = true;

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
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      _fetchShelters();

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

  Future<void> _fetchShelters() async {
    if (_currentPosition != null) {
      try {
        // Load shelters from CSV file
        List<Shelter> shelters = await loadSheltersFromCsv();

        // Calculate distances and filter out distant shelters
        final List<Shelter> nearbyShelters = [];
        for (var shelter in shelters) {
          double distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            shelter.latitude_EPSG4326,
            shelter.longitude_EPSG4326,
          );
          shelter.distance = distanceInMeters / 1000; // Convert to kilometers

          if (shelter.distance <= 10) { // Filter out shelters beyond 10 km
            nearbyShelters.add(shelter);
          }
        }

        // Sort shelters by distance
        nearbyShelters.sort((a, b) => a.distance.compareTo(b.distance));

        setState(() {
          _shelters = nearbyShelters;
          isLoading = false;
        });

        _updateMarkers();
      } catch (e) {
        print('Error loading shelters from CSV: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }




  Future<List<Shelter>> loadSheltersFromCsv() async {
    final ByteData data = await rootBundle.load('assets/shelters/shelters.csv');
    final Uint8List bytes = data.buffer.asUint8List();
    final String content = utf8.decode(bytes);

    final List<List<dynamic>> rows = const CsvToListConverter().convert(content);

    List<Shelter> shelters = [];

    for (var i = 1; i < rows.length; i++) { // Skip header row
      var row = rows[i];
      Shelter shelter = Shelter.fromCsv(row);
      shelters.add(shelter);
    }

    return shelters;
  }

  void _updateMarkers() {
    if (_controller != null) {
      List<NMarker> newMarkers = _shelters.map((shelter) {
        return NMarker(
          id: shelter.InfraName,
          position: NLatLng(shelter.latitude_EPSG4326, shelter.longitude_EPSG4326),
        );
      }).toList();

      setState(() {
        markers = newMarkers;
      });
      for (var marker in markers){_controller!.addOverlay(marker);}
    }
  }
  Future<void> sendShelterClickedEvent(String InfraName) async {
    final String apiUrl = 'backend api 여기에 입력';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'shelter_id': InfraName}, // Sending shelter ID as data
      );

      if (response.statusCode == 200) {
        print('Shelter click event sent successfully');
      } else {
        print('Failed to send shelter click event');
      }
    } catch (e) {
      print('Error sending shelter click event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주변 대피소'),
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
                    _updateMarkers();
                  });
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _shelters.length,
              itemBuilder: (context, index) {
                final shelter = _shelters[index];

// Determine the text color based on Capacity
                Color capacityColor;
                if (shelter.Capacity == 0) {
                  capacityColor = Colors.red;
                } else if (shelter.Capacity > 1000) {
                  capacityColor = Colors.green;
                } else {
                  capacityColor = Colors.orange;
                }

                return InkWell(
                  onTap: () async {
                    // Assuming you have an API endpoint to fetch shelter details
                    final url = 'nmap://route/walk?slat=37.4640070&slng=126.9522394&sname=%EC%84%9C%EC%9A%B8%EB%8C%80%ED%95%99%EA%B5%90&dlat=37.5209436&dlng=127.1230074&dname=%EC%98%AC%EB%A6%BC%ED%94%BD%EA%B3%B5%EC%9B%90&appname=com.example.aiml_mobile_2024/${shelter.InfraName}';
                    final Uri uri = Uri.parse(url);

                    await sendShelterClickedEvent(shelter.InfraName);

                    if (await canLaunchUrl(uri)){
                      await launch(url);
                    }else{
                      print('Could not launch $url');
                    }
                  },

                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        flex:3,
                        child: Text(
                          shelter.InfraName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(), // Pushes the following widgets to the right
                      Text(
                        '${shelter.distance.toStringAsFixed(2)} km',
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 20), // Adjust space between distance and capacity
                      Text(
                        ' ${shelter.Capacity.toInt()}',
                        style: TextStyle(color:capacityColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}