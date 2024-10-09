import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/FriendService.dart'; // FriendService 임포트

class NotificationsPage extends StatelessWidget {
  final String currentUserId = 'user01'; // 현재 로그인한 사용자 ID
  final String senderUserId;

  NotificationsPage({required this.senderUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
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

          Map<String, dynamic> uncheckedData =
          snapshot.data!.data() as Map<String, dynamic>;
          if (uncheckedData.isEmpty) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }

          List<String> userIDs = uncheckedData.keys.toList();

          return ListView.builder(
            itemCount: userIDs.length,
            itemBuilder: (context, index) {
              String userID = userIDs[index];
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('user').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                  if (usersSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(); // 데이터 로딩 중에는 아무 것도 표시하지 않음
                  }
                  if (!usersSnapshot.hasData || usersSnapshot.data!.docs.isEmpty) {
                    return SizedBox(); // 사용자 데이터가 없으면 아무 것도 표시하지 않음
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
                      title: Text('사용자 이름: $userName'),
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
                          SizedBox(width: 8), // 버튼 사이의 간격
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
                        // 해당 사용자의 프로필 페이지로 이동하거나 필요한 작업을 수행할 수 있습니다.
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
