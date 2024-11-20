import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiml_mobile_2024/service/token_storage.dart';
import '../service/FriendService.dart';

class NotificationsPage extends StatefulWidget {
  final String senderUserId;

  NotificationsPage({required this.senderUserId});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentUserId = 'Unknown'; // 현재 로그인한 사용자 ID
  String userName = 'Unknown';
  String userPhone = 'No phone';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://3.38.101.112:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          currentUserId = userData['id'] ?? 'Unknown';
          userName = userData['name'] ?? 'Unknown';
          // userPhone = userData['phoneNum'] ?? 'No phone';
        });
      } else {
        print("Failed to load user info: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('USER_INFO')
            .doc(currentUserId)
            .collection('notifications')
            .doc('unchecked')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }
          Map<String, dynamic> uncheckedData = snapshot.data!.data() as Map<String, dynamic>;
          if (uncheckedData.isEmpty) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }

          List<String> userIDs = uncheckedData.keys.toList();

          return ListView.builder(
            itemCount: userIDs.length,
            itemBuilder: (context, index) {
              String userID = userIDs[index];
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('USER_INFO').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                  if (usersSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }
                  if (!usersSnapshot.hasData || usersSnapshot.data!.docs.isEmpty) {
                    return SizedBox();
                  }

                  String userName = '사용자 이름 없음';
                  for (QueryDocumentSnapshot userDoc in usersSnapshot.data!.docs) {
                    if (userDoc.id == userID) {
                      userName = userDoc.get('name') ?? '사용자 이름 없음';
                      break;
                    }
                  }

                  return Card(
                    child: ListTile(
                      title: Text('친구 이름: $userName'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              FriendService friendService = FriendService();
                              await friendService.acceptFriendRequest(userID, currentUserId, userName, context);
                            },
                            child: Text('친구 수락'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              FriendService friendService = FriendService();
                              await friendService.rejectFriendRequest(userID, currentUserId, context);
                            },
                            child: Text('친구 거절'),
                          ),
                        ],
                      ),
                      onTap: () {
                      },
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
