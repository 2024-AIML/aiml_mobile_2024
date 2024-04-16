import 'package:flutter/material.dart';
import '../service/HttpServiceForAPI.dart'; // HttpService를 불러옵니다.

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Message> _messages = [];
  List<Message> _filteredMessages = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    List<Message> messages = await HttpService.fetchData();

    setState(() {
      _messages = messages;
      _filteredMessages = messages; // 처음에는 필터링 되지 않은 모든 메시지
    });
  }

  void _filterMessages(String query){
    setState(() {
      _filteredMessages = _messages
          .where((message) => message.locationName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _search(){
    String query = _searchController.text;
    _filterMessages(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재난 안내 문자 목록'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '검색',
                      hintText: '지역 이름을 입력하세요',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                ElevatedButton(
                  onPressed: _search,
                  child: Text('확인'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      _filteredMessages[index].msg,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  elevation: 5,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}