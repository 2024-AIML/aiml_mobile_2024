import 'package:flutter/material.dart';

import '../widget/CommonScaffold.dart';


class PostDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const PostDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text(title), // 게시글 제목을 앱바에 표시
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(content), // 게시글 내용을 출력
      ),
    );
  }
}