import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({Key? key}) : super(key:key);

  @override
  _NaverMapWidgetState createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
            target: NLatLng(getPosition.latitude, getPosition.longitude),
            zoom: 10,
        ),
        mapType: NMapType.basic,
        activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
        // indoorEnable: true,
        // locationButtonEnable: false,
        // consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) async {
        // mapControllerCompleter.complete(controller);
        // log("onMapReady", name: "onMapReady");
        print("로딩!");
      },
      onMapTapped: (point, latLng) {
        debugPrint("${latLng.latitude}, ${latLng.latitude}");
      },
    );
  }
}