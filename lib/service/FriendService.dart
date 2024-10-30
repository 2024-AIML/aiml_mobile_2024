import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> acceptFriendRequest(String senderId, String currentUserId, String senderName, BuildContext context) async {
    // 현재 로그인한 사람의 서브 컬렉션에 친구 추가
    DocumentReference currentUserDoc = _firestore.collection('user').doc(currentUserId);
    await currentUserDoc.collection('friends').doc(senderId).set({
      'Follow': true,
    });

    // 친구 요청을 보낸 사람의 서브 컬렉션에 친구 추가
    DocumentReference senderUserDoc = _firestore.collection('user').doc(senderId);
    await senderUserDoc.collection('friends').doc(currentUserId).set({
      'Follow': true,
    });

    // 친구 요청을 수락한 사람에게 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$senderName 의 친구 요청을 수락했습니다.'),
        duration: Duration(seconds: 2),
      ),
    );

    // 친구 요청을 보낸 사람에게 알림 전송
    await senderUserDoc.collection('notifications').doc('unchecked').set({
      'message': '$currentUserId 와의 친구 요청이 수락되었습니다.',
    }, SetOptions(merge: true));

    // 알림 목록에서 첫 번째 알림 삭제
    await _firestore.collection('user').doc(currentUserId).collection('notifications').doc('unchecked').update({
      senderId: FieldValue.delete(),
    });

    // 친구 요청 처리 후 추가 작업 필요
    print('친구 요청이 수락되었습니다: $senderId');
  }

  Future<void> rejectFriendRequest(String senderId, String currentUserId, BuildContext context) async {
    // 친구 요청을 보낸 사람에게 알림 전송
    DocumentReference senderUserDoc = _firestore.collection('user').doc(senderId);

    await senderUserDoc.collection('notifications').doc('unchecked').set({
      'message': '$currentUserId 의 친구 요청이 거절되었습니다.',
    }, SetOptions(merge: true));

    // 알림 목록에서 첫 번째 알림 삭제
    await _firestore.collection('user').doc(currentUserId).collection('notifications').doc('unchecked').update({
      senderId: FieldValue.delete(),
    });

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