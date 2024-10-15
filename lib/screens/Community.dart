import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart';
import 'PostDetailPage.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {

  // final List<Map<String, String>> posts = [
  //   {'title': 'title1', 'content': 'This is the content of post1.'},
  //   {'title': 'title2', 'content': 'This is the content of post2.'},
  //   {'title': 'title3', 'content': 'This is the content of post3.'}
  // ];

  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts(); // API 호출
  }

  // Post 데이터를 가져오는 함수
  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/post/'));

    if(response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // 데이터를 Map 형식으로 변환 후 posts 리스트에 저장
      setState(() {
        posts = data.map((post) {
          return {
            'title': post['title'],
            'content': post['content'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void navigateToContent(String title, String content) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailPage(title: title, content: content),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('커뮤니티'),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: posts.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: ListTile(
                    title: Text(post['title']!), // 게시글 제목 출력
                    onTap: () {
                      // 제목을 클릭하면 내용 페이지로 이동
                      navigateToContent(post['title']!, post['content']!);
                    },
                  ),
                );
              }
          )
      ),
    );
  }
}