import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/FriendService.dart';

class NotificationsPage extends StatefulWidget {
  final String currentUserId; // 현재 로그인한 사용자 ID
  // final String senderUserId;

  NotificationsPage({required this.currentUserId});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentUserName = '사용자 이름 없음';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserName();
  }

  Future<void> _fetchCurrentUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('USER_INFO')
          .doc(widget.currentUserId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          currentUserName = userDoc.get('name') ?? '사용자 이름 없음';
        });
      }
    } catch (e) {
      print('Error fetching current user name: $e');
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('USER_INFO')
            .doc(widget.currentUserId)
            .collection('newNotification')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }

          List<DocumentSnapshot> notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              DocumentSnapshot notification = notifications[index];
              String userID = notification.id;

              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('USER_INFO').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                  if (usersSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }
                  if (!usersSnapshot.hasData || usersSnapshot.data!.docs.isEmpty) {
                    return SizedBox();
                  }

                  String notificationUserName = '알 수 없는 사용자';
                  for (QueryDocumentSnapshot userDoc in usersSnapshot.data!.docs) {
                    if (userDoc.id == userID) {
                      notificationUserName = userDoc.get('name') ?? '알 수 없는 사용자';
                      break;
                    }
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                              '$notificationUserName 님에게 친구 신청이 왔습니다.',
                              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    FriendService friendService = FriendService();
                                    await friendService.acceptFriendRequest(
                                      userID, widget.currentUserId, currentUserName, context,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  ),
                                  child: Text('친구 수락', style: TextStyle(fontSize: 8),),
                                ),
                                SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    FriendService friendService = FriendService();
                                    await friendService.rejectFriendRequest(
                                      userID, widget.currentUserId, currentUserName, context,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black, // 버튼 배경색
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  ),
                                  child: Text('친구 거절', style: TextStyle(fontSize: 8),),
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
