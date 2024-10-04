import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../service/InfraInfoService.dart';
import '../widget/CommonScaffold.dart';

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
      markers = [];
      if (selectedLocation == '병원') {
        markers = _hospitals.map((hospital) {
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

      if (_controller != null) {
        _controller!.clearOverlays().then((_) {
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
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      if (_controller != null) {
        _controller!.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
        );
      }
      _fetchHospitals();
      _fetchPharmacies();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text("병원 및 약국"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: showList ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.7, // 지도 크기 조정
                  child: NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          _currentPosition?.latitude ?? 37.5665,
                          _currentPosition?.longitude ?? 126.9780,
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
                  return ListTile(
                    title: Text(_hospitals[index].name),
                    subtitle: Text(
                      '${_hospitals[index].distance?.toStringAsFixed(2)} km',
                    ),
                  );
                },
              )
                  : ListView.builder(
                itemCount: _pharmacies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_pharmacies[index].name),
                    subtitle: Text(
                      '${_pharmacies[index].distance?.toStringAsFixed(2)} km',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
