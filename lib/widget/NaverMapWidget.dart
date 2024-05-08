import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({Key? key}) : super(key:key);

  @override
  _NaverMapWidgetState createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  final String apiKey = 'xLnMgzkSEC6lL8V6M78bOzeTKuGSDwbrhMdUbgcj';
  Image? mapImage;
  String? selectedLocation;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    // _fetchMapData();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        // indoorEnable: true,
        // locationButtonEnable: false,
        // consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) async {
        // mapControllerCompleter.complete(controller);
        // log("onMapReady", name: "onMapReady");
        print("로딩!");
      },
    );
  }
}