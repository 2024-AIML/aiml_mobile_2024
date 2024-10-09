// lib/screens/SearchFriend.dart
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart';

class SearchFriend extends StatefulWidget {
  final List<String> friends;
  final ValueChanged<List<String>> onFilteredFriendsChanged;

  SearchFriend({
    required this.friends,
    required this.onFilteredFriendsChanged,
  });

  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  void _filterFriends(String query) {
    List<String> results = [];
    if (query.isEmpty) {
      results = widget.friends;
    } else {
      results = widget.friends
          .where((friend) =>
          friend.toLowerCase().contains(query.toLowerCase())) // 대소문자 구분 없이 검색
          .toList();
    }
    widget.onFilteredFriendsChanged(results);
  }

  void _search() {
    _filterFriends(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text("Search Bar"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: '이름 또는 전화번호를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10.0), // 검색 필드와 버튼 간의 간격
              ElevatedButton(
                onPressed: _search,
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}