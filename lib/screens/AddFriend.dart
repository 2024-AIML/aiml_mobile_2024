import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFriend extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Future<List<DocumentSnapshot>> searchUsers(String searchQuery) async {
    List<DocumentSnapshot> users = [];

    // Firebase의 user 컬렉션에서 검색어와 일치하는 사용자를 찾습니다.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').get();
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      // 전화번호로 검색하는 경우
      if (data.containsKey('phone') && data['phone'] == searchQuery) {
        users.add(document);
      }
      // 이름으로 검색하는 경우
      else if (data.containsKey('name') && data['name'] == searchQuery) {
        users.add(document);
      }
      // 이메일로 검색하는 경우
      else if (data.containsKey('email') && data['email'] == searchQuery) {
        users.add(document);
      }
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Information',
                hintText: '상대방의 전화번호, 이름, 이메일 중 하나를 입력하세요',
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

                // 검색된 사용자를 화면에 표시
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Search Results'),
                    content: Container(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        itemCount: foundUsers.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userData = foundUsers[index].data() as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              title: Text('Name: ${userData['name']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone: ${maskPhoneNumber(userData['phone'])}'),
                                  Text('Email: ${maskEmail(userData['email'])}'),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // '친구 추가' 버튼 클릭 시 수행할 함수
                                  print('친구 신청: ${userData['name']}');
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
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
