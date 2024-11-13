import 'package:flutter/material.dart';
import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';

class PostDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const PostDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(title),
        backgroundColor: Colors.white,),
      backgroundColor: Colors.white,// 게시글 제목을 앱바에 표시
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(content), // 게시글 내용을 출력
      ),
    );
  }
}