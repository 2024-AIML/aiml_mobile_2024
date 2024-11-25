import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/token_storage.dart';
import '../service/FriendService.dart'; // 친구 수락/거절 처리

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String userId = '';
  String userName = '사용자 이름 없음';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
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
          userName = userData['name'] ?? 'Unknown';
        });
      } else {
        print("사용자 정보 로딩 실패: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT 토큰이 없습니다.");
    }
  }

  // senderId에 해당하는 사용자의 이름을 fetch하는 함수
  Future<String> fetchSenderName(String senderId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('USER_INFO')
          .doc(senderId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        return data?['name'] ?? '알 수 없는 사용자';
      } else {
        return '알 수 없는 사용자';
      }
    } catch (e) {
      print('Error fetching sender Name: $e');
      return '알 수 없는 사용자';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 신청 알림'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: userId.isEmpty
          ? Center(child: CircularProgressIndicator()) // 사용자 정보 로딩 중
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('USER_INFO')
            .doc(userId)
            .collection('newNotification')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('오류가 발생했습니다: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }

          List<DocumentSnapshot> notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> notificationData =
              notifications[index].data() as Map<String, dynamic>;

              String senderId = notificationData['senderId'] ?? 'Unknown';

              // senderId에 해당하는 이름을 가져옵니다.
              return FutureBuilder<String>(
                future: fetchSenderName(senderId),
                builder: (context, AsyncSnapshot<String> senderNameSnapshot) {
                  if (senderNameSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (senderNameSnapshot.hasError) {
                    return Center(
                      child: Text('사용자 이름 로딩 실패: ${senderNameSnapshot.error}'),
                    );
                  }

                  String senderName = senderNameSnapshot.data ?? '알 수 없는 사용자';

                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$senderName 님에게 친구 신청이 왔습니다.',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 친구 수락 버튼
                                ElevatedButton(
                                  onPressed: () async {
                                    FriendService friendService =
                                    FriendService();
                                    await friendService.acceptFriendRequest(
                                      senderId,
                                      userId,
                                      userName,
                                      context,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                  ),
                                  child: Text(
                                    '친구 수락',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                // 친구 거절 버튼
                                ElevatedButton(
                                  onPressed: () async {
                                    FriendService friendService =
                                    FriendService();
                                    await friendService.rejectFriendRequest(
                                      senderId,
                                      userId,
                                      userName,
                                      context,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                  ),
                                  child: Text(
                                    '친구 거절',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
