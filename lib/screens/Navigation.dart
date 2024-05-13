import 'package:aiml_mobile_2024/widget/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:aiml_mobile_2024/widget/NaverMapWidget.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState() ;
}

class _NavigationState extends State<Navigation> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'infra_info',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffD9D9D9),
          ),
          body: Center(
            child: Container(
              width: 385,
              height: 465,
              // child: Infra_info_NaverMapWidget(),
              child: NaverMapWidget(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBarWidget(),
        )

    );
  }

}