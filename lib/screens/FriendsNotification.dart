import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/FriendService.dart';

class NotificationsPage extends StatelessWidget {
  final String currentUserId = 'user01'; // 현재 로그인한 사용자 ID 라서 나중에 바꿔야함
  final String senderUserId;

  NotificationsPage({required this.senderUserId});

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
          Map<String, dynamic> uncheckedData = snapshot.data!.data() as Map<String, dynamic>;
          if (uncheckedData.isEmpty) {
            return Center(child: Text('받은 알림이 없습니다.'));
          }

          List<String> userIDs = uncheckedData.keys.toList();

          // 필드 내용 출력
          print('Notifications:');
          uncheckedData.forEach((key, value) {
            print('$key: $value');
          });

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
                  // 사용자 컬렉션에서 userID와 일치하는 문서를 찾아서 해당 문서의 name 필드 값을 가져옴
                  for (QueryDocumentSnapshot userDoc in usersSnapshot.data!.docs) {
                    if (userDoc.id == userID) {
                      userName = userDoc.get('name') ?? '사용자 이름 없음';
                      break;
                    }
                  }

                  // // 필드 내용과 일치하는 문서가 있는지 확인하는 과정 출력
                  // print('Checking for user $userID in user collection:');
                  // bool foundUser = false;
                  // for (QueryDocumentSnapshot userDoc in usersSnapshot.data!.docs) {
                  //   if (userDoc.id == userID) {
                  //     print('User $userID found in user collection');
                  //     foundUser = true;
                  //     break;
                  //   }
                  // }
                  // if (!foundUser) {
                  //   print('User $userID not found in user collection');
                  // }

                  return Card(
                    child: ListTile(
                      title: Text('User Name: $userName'),
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