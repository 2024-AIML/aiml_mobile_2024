import 'package:aiml_mobile_2024/widget/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:aiml_mobile_2024/widget/NaverMapWidget.dart';

class Navigation_Naver extends StatefulWidget {
  @override
  _Navigation_NaverState createState() => _Navigation_NaverState() ;
}

class _Navigation_NaverState extends State<Navigation_Naver> {

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