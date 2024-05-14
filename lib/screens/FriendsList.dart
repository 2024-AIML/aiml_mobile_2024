import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Friends'),
      ),
      body: UserFriendsList(),
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
                // 여기에 다른 필드들을 출력하거나 필요한 기능을 추가할 수 있습니다.
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
