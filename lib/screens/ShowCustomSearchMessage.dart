import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold를 import
import '../service/HttpServiceForAPI.dart'; // API 호출을 위한 HttpService import

class ShowCustomSearchMessage extends StatefulWidget {
  const ShowCustomSearchMessage({Key? key}) : super(key: key);

  @override
  _ShowCustomSearchMessageState createState() => _ShowCustomSearchMessageState();
}

class _ShowCustomSearchMessageState extends State<ShowCustomSearchMessage> {
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
      _filteredMessages = messages;
    });
  }

  void _filterMessages(String query) {
    setState(() {
      _filteredMessages = _messages.where((message) =>
          message.locationName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _search() {
    String query = _searchController.text;
    _filterMessages(query);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text("재난 안전 문자 목록"),
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
              // itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      _filteredMessages[index].create_date,
                      style: TextStyle(fontSize: 12.0),
                    ),

                    Card(
                      margin: EdgeInsets.all(10.0),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          _filteredMessages[index].msg,
                          style: TextStyle(fontSize: 14.0),
                          // 여기에 Card 내용을 추가할 수 있습니다.
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
