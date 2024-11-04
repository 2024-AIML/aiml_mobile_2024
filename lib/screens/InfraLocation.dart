import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../service/InfraInfoService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfraScreen extends StatefulWidget {
  @override
  _InfraScreenState createState() => _InfraScreenState();
}

class _InfraScreenState extends State<InfraScreen> {
  final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  List _hospitals = [];
  List _pharmacies = [];
  List<NMarker> markers = [];
  Position? _currentPosition;
  NaverMapController? _controller;
  String? selectedLocation = '병원';
  bool showList = false; // 리스트가 보일지 여부를 제어하는 변수

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchHospitals();
    _fetchPharmacies();
  }

  Future<void> _fetchHospitals() async {
    if (_currentPosition != null) {
      try {
        final data = await InfraInfoService.fetchHospitals(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        setState(() {
          _hospitals = data;
        });
        _updateMarkers();
      } catch (e) {
        print('Error fetching hospitals: $e');
      }
    }
  }

  Future<void> _fetchPharmacies() async {
    if (_currentPosition != null) {
      try {
        final data = await InfraInfoService.fetchPharmacies(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        setState(() {
          _pharmacies = data;
        });
        _updateMarkers();
      } catch (e) {
        print('Error fetching pharmacies: $e');
      }
    }
  }

  void _updateMarkers() {
    setState(() {
      markers = []; // Clear the existing markers
      List<NMarker> newMarkers = []; // Create a new list for markers

      if (selectedLocation == '병원') {
        newMarkers = _hospitals.map((hospital) {
          final NMarker marker = NMarker(
            id: hospital.name,
            position: NLatLng(hospital.latitude, hospital.longitude),
          );

          // Correctly set the onTap listener
          marker.setOnTapListener((NMarker tappedMarker) {
            String url = 'nmap://route/walk?slat=${_currentPosition!.latitude}&slng=${_currentPosition!.longitude}&sname=%EC%84%9C%EC%9A%B8%EB%8C%80%ED%95%99%EA%B5%90&dlat=${hospital.latitude}&dlng=${hospital.longitude}&dname=${hospital.name}&appname=com.example.aiml_mobile_2024';
            launch(url); // Ensure you have imported url_launcher
          });

          return marker;
        }).toList();

      } else if (selectedLocation == '약국') {
        newMarkers = _pharmacies.map((pharmacy) {
          final NMarker marker = NMarker(
            id: pharmacy.name,
            position: NLatLng(pharmacy.latitude, pharmacy.longitude),
          );

          // Correctly set the onTap listener
          marker.setOnTapListener((NMarker tappedMarker) {
            String url = 'nmap://route/walk?slat=${_currentPosition!.latitude}&slng=${_currentPosition!.longitude}&sname=%EC%84%9C%EC%9A%B8%EB%8C%80%ED%95%99%EA%B5%90&dlat=${pharmacy.latitude}&dlng=${pharmacy.longitude}&dname=${pharmacy.name}&appname=com.example.aiml_mobile_2024';
            launch(url); // Ensure you have imported url_launcher
          });

          return marker;
        }).toList();
      }

      // Clear existing overlays and add new markers to the map
      if (_controller != null) {
        _controller!.clearOverlays().then((_) {
          markers = newMarkers; // Assign new markers here
          for (var marker in markers) {
            _controller!.addOverlay(marker).catchError((e) {
              print('Error adding marker: $e');
            });
          }
        }).catchError((e) {
          print('Error clearing overlays: $e');
        });
      }
    });
  }


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      _fetchHospitals();
      _fetchPharmacies();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                if(_currentPosition != null)
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
                        _controller = controller;
                      });
                    },
                    onMapTapped: (point, latLng) {
                      // 지도를 클릭하면 리스트를 닫고 지도를 확장
                      setState(() {
                        showList = false;
                      });
                    },
                  ),

                Positioned(
                  top: 20,
                  left: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLocation = '병원';
                        showList = true; // 리스트를 보여줌
                        _updateMarkers();
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: Colors.red,
                          size: 25,
                        ),
                        Text(
                          '병원',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLocation = '약국';
                        showList = true; // 리스트를 보여줌
                        _updateMarkers();
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.medication_liquid,
                          color: Colors.teal,
                          size: 25,
                        ),
                        Text(
                          '약국',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showList)
            Expanded(
              child: selectedLocation == '병원'
                  ? ListView.builder(
                itemCount: _hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = _hospitals[index];
                  return InkWell(
                      onTap: () async {
                    final String hospitalName = Uri.encodeComponent(hospital.name);
                    final String url = 'nmap://route/walk?slat=${_currentPosition!.latitude}&slng=${_currentPosition!.longitude}&sname=현재위치&dlat=${hospital.latitude}&dlng=${hospital.longitude}&dname=$hospitalName&appname=com.example.aiml_mobile_2024';
                    final Uri uri = Uri.parse(url);

                    if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                  } else {
                  print('Could not launch $url');
                  }
                  },
                  child: ListTile(
                    title: Text(_hospitals[index].name),
                    subtitle: Text(
                      '${_hospitals[index].distance?.toStringAsFixed(2)} km',
                    ),
                  )
                  );
                },
              )
                  : ListView.builder(
                itemCount: _pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = _pharmacies[index];

                  return InkWell(
                      onTap: () async {
                        final String hospitalName = Uri.encodeComponent(pharmacy.name);
                        final String url = 'nmap://route/walk?slat=${_currentPosition!.latitude}&slng=${_currentPosition!.longitude}&sname=현재위치&dlat=${pharmacy.latitude}&dlng=${pharmacy.longitude}&dname=$hospitalName&appname=com.example.aiml_mobile_2024';
                        final Uri uri = Uri.parse(url);

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      } else {
                          print('Could not launch $url');
                          }
                        },
                    child:ListTile(
                      title: Text(_pharmacies[index].name),
                      subtitle: Text (
                      '${_pharmacies[index].distance?.toStringAsFixed(2)} km',
                    ),
                  )
                  );
                },
              ),
            ),
        ],
      ),

    );
  }
}