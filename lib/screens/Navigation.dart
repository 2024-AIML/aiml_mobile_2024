// import 'dart:html';

import 'package:aiml_mobile_2024/widget/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  var url = "nmap://route/walk?slat=37.4640070&slng=126.9522394&sname=%EC%84%9C%EC%9A%B8%EB%8C%80%ED%95%99%EA%B5%90&dlat=37.5209436&dlng=127.1230074&dname=%EC%98%AC%EB%A6%BC%ED%94%BD%EA%B3%B5%EC%9B%90&appname=com.example.aiml_mobile_2024";
  // 이후 API 만들어서 url GET방식으로 전달
  // slat: type=double, 출발지 위도(31.43 ~ 44.35)
  // slng: type=double, 출발지 경도(122.37 ~ 132.00)
  // sname: type=string, 출발지 이름(URL 인코딩된 문자열)
  // dlat
  // dlng
  // dname


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffD9D9D9),
        ),
        body: Center(
          child: ElevatedButton(
//            onPressed: _launchURL,
          onPressed: () async{
            //await launch(url);
          },
            child: Text('Open URL Scheme'),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }

  _launchURL() async {
    var url = 'nmap://map?&appname=com.example.aiml_mobile_2024';
    //
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   // var store = 'https://play.google.com/store/apps/details?id=com.nhn.andriod.nmap&hl=ko-KR';
    //   // await launchBrowserTab(Uri.parse(store));
    //   throw 'Could not launch &url';
    // }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}