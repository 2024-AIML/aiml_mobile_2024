import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FriendsNotification.dart';

class AddFriend extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Future<List<DocumentSnapshot>> searchUsers(String searchQuery) async {
    List<DocumentSnapshot> users = [];

    // Firebase의 user 컬렉션에서 모든 문서 가져오기
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').get();

    // 모든 문서에서 검색어와 일치하는 사용자를 찾기
    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // 전화번호, 이름, 이메일 필드가 존재하는지 확인하고 일치하는지 검사
      if ((data.containsKey('phone') && data['phone'].toString().contains(searchQuery)) ||
          (data.containsKey('name') && data['name'].toString().contains(searchQuery)) ||
          (data.containsKey('email') && data['email'].toString().contains(searchQuery))) {
        users.add(document);
      }
    }

    return users;
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 7) return phoneNumber;

    String firstThree = phoneNumber.substring(0, 3);
    String lastFour = phoneNumber.substring(phoneNumber.length - 4);
    String masked = '';
    for (int i = 0; i < phoneNumber.length - 7; i++) {
      masked += '*';
    }
    return '$firstThree$masked$lastFour';
  }

  String maskEmail(String email) {
    if (!email.contains('@')) return email;

    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    if (username.length > 3) {
      username = username.substring(0, username.length - 3) + '***';
    }
    return '$username@$domain';
  }


  Future<void> sendFriendRequest(BuildContext context, String currentUserId, String friendUserId) async {
    try {
      // 친구의 document 참조
      DocumentReference friendDocRef = FirebaseFirestore.instance.collection('user').doc(friendUserId);

      // 친구의 notification 서브 컬렉션 참조
      CollectionReference notificationRef = friendDocRef.collection('notification');

      // 새로운 알림 문서 생성
      await notificationRef.add({
        'senderId': currentUserId, // 친구 요청을 보낸 사용자 ID
        'timestamp': FieldValue.serverTimestamp(), // 친구 요청 보낸 시간
        'type': 'friend_request' // 알림의 종류 (친구 요청)
      });

      // 성공적으로 친구 요청을 보낸 후, 알림 창 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('친구 요청 성공'),
          content: Text('친구 요청을 성공적으로 보냈습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
              child: Text('확인'),
            ),
          ],
        ),
      );

      print('친구 요청을 성공적으로 보냈습니다.');
    } catch (e) {
      print('친구 요청을 보내는 도중 오류가 발생했습니다: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: '추가하고 싶은 사람의 정보를 입력하세요.',
                  labelStyle: TextStyle(
                    color: Colors.black, // Set the label color to green
                  ),
                  hintText: '상대방의 전화번호, 이름, 이메일 중 하나를 입력하세요',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.green[900]!,))
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String searchQuery = _controller.text;
                print('Search Query: $searchQuery');

                // 사용자 검색
                List<DocumentSnapshot> foundUsers = await searchUsers(searchQuery);
                print('Found Users: ${foundUsers.length}');

                // 검색 결과에 따른 처리
                if (foundUsers.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('검색 결과'),
                      content: Text('일치하는 사용자가 없습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 대화상자 닫기
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // 검색된 사용자를 화면에 표시
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('검색 결과'),
                      content: Container(
                        width: double.maxFinite,
                        height: 300,
                        child: ListView.builder(
                          itemCount: foundUsers.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userData = foundUsers[index].data() as Map<String, dynamic>;
                            String friendUserId = foundUsers[index].id; // 친구의 문서 아이디
                            return Card(
                              child: ListTile(
                                title: Text('Name: ${userData['name']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Phone: ${maskPhoneNumber(userData['phone'] ?? '')}'),
                                    Text('Email: ${maskEmail(userData['email'] ?? '')}'),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    String currentUserId = '1234_hello'; // 현재 사용자 ID, 실제로는 적절한 ID로 바꿔 사용해야 함
                                    await sendFriendRequest(context, currentUserId, friendUserId);
                                    print('친구 요청을 보냈습니다: ${userData['name']}');
                                  },
                                  child: Text('친구 신청'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
              ),
              child: Text(
                '검색',
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage(senderUserId: '',)),
          );
        },
        child: Icon(Icons.notifications, color: Colors.white,),
        tooltip: 'Notifications',
        backgroundColor: Colors.green[900],
      ),
    );
  }
}
