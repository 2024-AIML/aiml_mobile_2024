import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiml_mobile_2024/screens/Community.dart';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritePost extends StatefulWidget {
  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  bool _isSubmitting = false;
  String latitude = '';
  String longitude = '';
  String userId = '';

  @override
  void initState()
  {
    super.initState();
    fetchUserInfo();
  }
  // Function to handle form submission
  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      // API URL for posting
      final url = Uri.parse('http://3.36.69.187:8081/post/');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer YOUR_JWT_TOKEN', // Replace with your JWT token
          },
          body: jsonEncode({
            'title': _title,
            'content': _content,
            'latitude': latitude, // Latitude fetched from Firestore
            'longitude': longitude, // Longitude fetched from Firestore
            'userId': userId, // User ID fetched from user info
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Post submitted successfully');
          _formKey.currentState!.reset();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Community()),
          );

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('게시글 작성완료!')),
          );
        } else {
          print('Failed to submit post: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('게시글 작성 실패: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error submitting post: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('네트워크 오류로 게시글 작성에 실패했습니다.')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://3.36.69.187:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userId = userData['id'] ?? 'Unknown';
          print("uesrId: ${userId}");
        });

        fetchUserLocation(userId);
      } else {
        print("Failed to load user info: ${response.statusCode}, ${response
            .body}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  Future<void> fetchUserLocation(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('USER_LOCATION')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          longitude = data['longitude'] ?? '';
          latitude = data['latitude'] ?? '';
        });
        print('위도: $latitude, 경도: $longitude');
      } else {
        print("위치 정보 알 수 없음");
      }
    } catch (e) {
      print('위치 정보 로딩 실패: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: '제목',
                  labelStyle: TextStyle(color: Colors.green[900]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하시오';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '내용',
                  labelStyle: TextStyle(color: Colors.green[900]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900]!),
                  ),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting ? Colors.grey : Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                      : Text('제출'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
