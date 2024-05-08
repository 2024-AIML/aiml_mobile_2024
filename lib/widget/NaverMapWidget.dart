import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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
