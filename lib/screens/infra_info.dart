import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
//  await _initialize();
//   WidgetsFlutterBinding.ensureInitialized();
//   await NaverMapSdk.instance.initialize(clientId: '1dtmwihlto');
  runApp(const infra_info());
}

//지도 초기화하기
// Future<void> _initialize() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NaverMapSdk.instance.initialize(
//     clientId: '1dtmwihlto',
//     onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
//   );
// }

class infra_info extends StatelessWidget {
  const infra_info({super.key});

  @override
  Widget build(BuildContext context) {

//    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return MaterialApp(
      title: 'infra_info',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffD9D9D9),
        ),
        // body: NaverMap(
        //    options: const NaverMapViewOptions(
        //     indoorEnable: true,
        //     locationButtonEnable: false,
        //     consumeSymbolTapEvents: false,
        //    ),
        //   onMapReady: (controller) async {
        //     mapControllerCompleter.complete(controller);
        //     log("onMapReady", name: "onMapReady");
        //     // print("로딩!");
        //   },
        // ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xffD9D9D9),
          onTap: (int index){
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/');
                break;
              case 1:
                Navigator.pushNamed(context, '/infra_info');
                break;
              case 2:
                Navigator.pushNamed(context, '/navigator');
                break;
              case 3:
                Navigator.pushNamed(context, '/search_missing_person');
                break;
              case 4:
                Navigator.pushNamed(context, '/message');
                break;
              default:
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.place), label: 'infra'),
            BottomNavigationBarItem(icon: Icon(Icons.near_me), label: 'navi'),
            BottomNavigationBarItem(icon: Icon(Icons.youtube_searched_for), label: 'sear'),
            BottomNavigationBarItem(icon: Icon(Icons.mode_comment), label: 'mess')
          ],
        ),
      )

      );
  }

}