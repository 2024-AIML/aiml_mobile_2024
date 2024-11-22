import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> acceptFriendRequest(String senderId, String currentUserId, String senderName, BuildContext context) async {
    DocumentReference currentUserDoc = _firestore.collection('USER_INFO').doc(currentUserId);
    DocumentReference senderUserDoc = _firestore.collection('USER_INFO').doc(senderId);

    try {
      await currentUserDoc.collection('friends').doc(senderId).set({
        'Follow': true,
      });

      await senderUserDoc.collection('friends').doc(currentUserId).set({
        'Follow': true,
      });

      // 친구 요청을 보낸 사람에게 알림 전송
      await senderUserDoc.collection('unchecked').doc(currentUserId).set({
        'message': '$currentUserId 와의 친구 요청이 수락되었습니다.',
      }, SetOptions(merge: true));

      // 알림 받은 컬렉션에서 이미 처리된 문서 삭제함
      await currentUserDoc
          .collection('newNotification')
          .doc(senderId)
          .delete();

      await currentUserDoc.collection('checked').doc(senderId).set({
        'message': '$senderName 의 친구 요청이 수락되었습니다.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 사용자에게 알림 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$senderName 의 친구 요청을 수락했습니다.'),
          duration: Duration(seconds: 2),
        ),
      );

      print('친구 요청이 수락되었습니다: $senderId');
    } catch (e) {
      print('친구 요청 처리 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('친구 요청을 처리하는 중 오류가 발생했습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> rejectFriendRequest(String senderId, String currentUserId, String currentUserName, BuildContext context) async {
    DocumentReference senderUserDoc = _firestore.collection('USER_INFO').doc(senderId);
    DocumentReference currentUserDoc = _firestore.collection('USER_INFO').doc(currentUserId);

    // await senderUserDoc.collection('newNotification').doc(currentUserId).set({
    //   'message':'$currentUserName 의 친구 요청이 거절되었습니다.',
    //   'timestamp': FieldValue.serverTimestamp(),
    // });

    // 알림 받은 컬렉션에서 이미 처리된 문서 삭제함
    await currentUserDoc
        .collection('newNotification')
        .doc(senderId)
        .delete();

    // 친구 요청을 거절한 사람에게 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$senderId 의 친구 요청을 거절했습니다.'),
        duration: Duration(seconds: 2),
      ),
    );

    print('친구 요청이 거절되었습니다: $senderId');
  }
}