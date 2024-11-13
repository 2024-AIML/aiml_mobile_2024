import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'PostDetailPage.dart';
import 'package:aiml_mobile_2024/screens/WritePost.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts(); // API 호출
  }

  // Post 데이터를 가져오는 함수
  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://43.202.6.121:8081/post/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: posts.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                title: post['title'] ?? 'No Title',
                                content: post['content'] ?? 'No Content',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.black, width: 2.0),

                          ),
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title']!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['content']!,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WritePost()),
                      );
                    },
                    icon: Icon(Icons.add_circle_outlined),
                    iconSize: 70.0,
                    color: Colors.black, // Increase the size of the icon
                  ),
                ),
              ], // children
            ),
          ),
        ], // children
      ),
    );
  }
}
