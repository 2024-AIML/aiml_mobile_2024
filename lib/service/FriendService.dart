//FriendService.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 친구 요청 수락
  Future<void> acceptFriendRequest(
      String senderId,
      String currentUserId,
      String senderName,
      BuildContext context,
      ) async {
    DocumentReference currentUserDoc =
    _firestore.collection('USER_INFO').doc(currentUserId);
    DocumentReference senderUserDoc =
    _firestore.collection('USER_INFO').doc(senderId);

    try {
      // 친구 관계 업데이트
      await _updateFriendStatus(currentUserDoc, senderId, true);
      await _updateFriendStatus(senderUserDoc, currentUserId, true);

      // 발신자에게 알림
      await senderUserDoc.collection('unchecked').doc(currentUserId).set({
        'message': '$currentUserId 와의 친구 요청이 수락되었습니다.',
      }, SetOptions(merge: true));

      // 처리된 요청 제거 및 확인된 알림 추가
      await _removeNotification(currentUserDoc, senderId);
      await _addCheckedNotification(currentUserDoc, senderId, '$senderName 의 친구 요청이 수락되었습니다.');

      // 사용자에게 성공 메시지 표시
      _showSnackBar(context, '$senderName 의 친구 요청을 수락했습니다.');

      print('친구 요청이 수락되었습니다: $senderId');
    } catch (e) {
      print('친구 요청 처리 중 오류 발생: $e');
      _showSnackBar(context, '친구 요청을 처리하는 중 오류가 발생했습니다.');
    }
  }

  /// 친구 요청 거절
  Future<void> rejectFriendRequest(
      String senderId,
      String currentUserId,
      String currentUserName,
      BuildContext context,
      ) async {
    DocumentReference currentUserDoc =
    _firestore.collection('USER_INFO').doc(currentUserId);

    try {
      // 처리된 요청 제거
      await _removeNotification(currentUserDoc, senderId);

      // 사용자에게 성공 메시지 표시
      _showSnackBar(context, '$senderId 의 친구 요청을 거절했습니다.');

      print('친구 요청이 거절되었습니다: $senderId');
    } catch (e) {
      print('친구 요청 거절 중 오류 발생: $e');
      _showSnackBar(context, '친구 요청을 처리하는 중 오류가 발생했습니다.');
    }
  }

  /// 친구 상태 업데이트
  Future<void> _updateFriendStatus(DocumentReference userDoc, String friendId, bool followStatus) async {
    await userDoc.collection('friends').doc(friendId).set({
      'Follow': followStatus,
    });
  }

  /// 알림 제거 (처리된 요청)
  Future<void> _removeNotification(DocumentReference userDoc, String notificationId) async {
    await userDoc.collection('newNotification').doc(notificationId).delete();
  }

  /// 확인된 알림 추가
  Future<void> _addCheckedNotification(
      DocumentReference userDoc,
      String senderId,
      String message,
      ) async {
    await userDoc.collection('checked').doc(senderId).set({
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// 스낵바 표시
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
