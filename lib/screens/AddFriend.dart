//AddFriend.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:http/http.dart' as http;

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController _controller = TextEditingController();
  String userId = 'Unknown';
  String userName = 'Unknown';
  String userPhone = 'No phone';

  // 사용자 정보를 가져오는 함수
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
          userName = userData['name'] ?? 'Unknown';
          userPhone = userData['phoneNum'] ?? 'Unknown';
        });
      } else {
        print("사용자 정보 로딩 실패: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT 토큰이 없습니다.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  // 사용자 검색 함수
  Future<List<DocumentSnapshot>> searchUsers(String searchQuery) async {
    List<DocumentSnapshot> users = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('USER_INFO').get();

    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      if ((data.containsKey('phoneNum') && data['phoneNum'].toString().contains(searchQuery)) ||
          (data.containsKey('name') && data['name'].toString().contains(searchQuery)) ||
          (data.containsKey('email') && data['email'].toString().contains(searchQuery))) {
        users.add(document);
      }
    }

    return users;
  }

  // 전화번호 마스킹 함수
  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 7) return phoneNumber;

    String firstThree = phoneNumber.substring(0, 3);
    String lastFour = phoneNumber.substring(phoneNumber.length - 4);
    String masked = '';
    for (int i = 0; i < phoneNumber.length - 7; i++) {
      masked += '*';
    }
    return '$firstThree$masked$lastFour';
  }

  // 이메일 마스킹 함수
  String maskEmail(String email) {
    if (!email.contains('@')) return email;

    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    if (username.length > 3) {
      username = username.substring(0, username.length - 3) + '***';
    }
    return '$username@$domain';
  }

  // 친구 요청을 보내는 함수
  Future<void> sendFriendRequest(BuildContext context, String currentUserId, String friendUserId) async {
    try {
      DocumentReference friendDocRef = FirebaseFirestore.instance.collection('USER_INFO').doc(friendUserId);
      CollectionReference notificationRef = friendDocRef.collection('newNotification');

      await notificationRef.doc(currentUserId).set({
        'senderId': currentUserId,
        'type': 'friend_request',
        'timestamp': FieldValue.serverTimestamp(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('친구 요청 성공', style: TextStyle(color: Colors.black, fontSize: 13)),
          content: Text('친구 요청을 성공적으로 보냈습니다.', style: TextStyle(fontSize: 10)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );

      print('친구 요청을 성공적으로 보냈습니다.');
    } catch (e) {
      print('친구 요청을 보내는 도중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 추가'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '추가하고 싶은 사람의 정보를 입력하세요',
                labelStyle: TextStyle(color: Colors.black),
                hintText: '상대방의 전화번호, 이름, 이메일 중 하나를 입력하세요',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String searchQuery = _controller.text;
                print('검색어: $searchQuery');

                List<DocumentSnapshot> foundUsers = await searchUsers(searchQuery);
                print('찾은 사용자 수: ${foundUsers.length}');

                if (foundUsers.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('검색 결과', style: TextStyle(color: Colors.black, fontSize: 13)),
                      content: Text('일치하는 사용자가 없습니다.', style: TextStyle(color: Colors.black, fontSize: 10)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('확인', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('검색 결과', style: TextStyle(color: Colors.black, fontSize: 13)),
                      content: Container(
                        color: Colors.white,
                        width: double.maxFinite,
                        height: 300,
                        child: ListView.builder(
                          itemCount: foundUsers.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userData = foundUsers[index].data() as Map<String, dynamic>;
                            String friendUserId = foundUsers[index].id;
                            return Card(
                              elevation: 0,
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '이름: ${userData['name']}',
                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '전화번호: ${maskPhoneNumber(userData['phoneNum'] ?? '')}',
                                        style: TextStyle(color: Colors.black, fontSize: 10),
                                      ),
                                      Text(
                                        '이메일: ${maskEmail(userData['email'] ?? '')}',
                                        style: TextStyle(color: Colors.black, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () async {
                                      String currentUserId = userId;
                                      await sendFriendRequest(context, currentUserId, friendUserId);
                                      print("친구 요청을 보냈습니다. ${userData['name']}");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: Text(
                                      '친구 신청',
                                      style: TextStyle(color: Colors.white, fontSize: 8),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(
                '검색',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
