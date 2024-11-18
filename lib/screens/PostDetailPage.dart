import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const PostDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경을 흰색으로 설정
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 제목 영역
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white, // 박스 배경 흰색
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.green[900]!, width: 1.5), // 테두리 색상 green[900]
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 내용 영역
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // 박스 배경 흰색
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.green[900]!, width: 1.5), // 테두리 색상 green[900]
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content,
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
