import 'package:flutter/material.dart';
import '../service/HttpServiceForAPI.dart'; // HttpService를 불러옵니다.

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    var messages = await HttpService.fetchData();
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재난 안내 문자'),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding : EdgeInsets.all(15.0),
              child: Text(_messages[index], style: TextStyle(fontSize: 14.0),),
            ),
            elevation: 5,
          );
        },
      ),
    );
  }
}