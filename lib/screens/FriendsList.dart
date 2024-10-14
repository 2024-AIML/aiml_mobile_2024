import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/FriendsInfo.dart';
import '../screens/AddFriend.dart';
import '../screens/FriendsNotification.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Friends'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // '알림 받기' 아이콘을 눌렀을 때 수행할 작업을 여기에 추가하세요.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage(senderUserId: '',)),
              );
            },
          ),
        ],
      ),
      body: UserFriendsList(),
      floatingActionButton: Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFriend()),
            );
          },
        ),
      ),
    );
  }
}

class UserFriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc('user01')
          .collection('friends')
          .where('Follow', isEqualTo: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No friends found.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return Card(
              child: ListTile(
                title: Text(doc.id), // 문서의 ID 필드 값 출력
                onTap: () async {
                  try {
                    DocumentSnapshot friendDoc = await FirebaseFirestore.instance
                        .collection('user')  // 컬렉션 경로 확인
                        .doc('user01')
                        .collection('friends')
                        .doc(doc.id) // 문서 ID 확인
                        .get();

                    print('Friend Doc Data: ${friendDoc.data()}'); // 데이터 확인

                    GeoPoint friendLocation = friendDoc['loca'];
                    if (friendLocation == null) {
                      friendLocation = GeoPoint(0, 0); // 기본 위치 설정
                    }

                    print('Friend Location: $friendLocation'); // 위치 확인

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendsInfo(
                          friendsName: doc.id,
                          friendsLocation: friendLocation,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error retrieving friend location: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error retrieving friend location')),
                    );
                  }
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}