//FriendsList.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:aiml_mobile_2024/service/token_storage.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  String userId = 'Unknown';
  bool isLoading = true;

  Future<void> fetchUserId() async {
    try {
      String? jwtToken = await getJwtToken();

      if (jwtToken != null) {
        final response = await http.get(
          Uri.parse('http://3.36.69.187:8081/api/member/info'),
          headers: {
            'Authorization': 'Bearer $jwtToken',
          },
        );

        if (response.statusCode == 200) {
          var userData = jsonDecode(response.body);
          setState(() {
            userId = userData['id'] ?? 'Unknown';
            isLoading = false;
          });
        } else {
          print("Failed to load user info: ${response.statusCode}, ${response.body}");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("JWT Token is missing");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user ID: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Stream<QuerySnapshot> getFriendsListStream() {
    if (userId == 'Unknown') {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('USER_INFO')
        .doc(userId)
        .collection('FRIENDS')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: getFriendsListStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('오류가 발생했습니다: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                '친구 목록이 비어 있습니다.',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          List<DocumentSnapshot> friends = snapshot.data!.docs;

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> friendData = friends[index].data() as Map<String, dynamic>;
              String friendName = friendData.containsKey('name') ? friendData['name'] : 'Unknown';
              String friendPhone = friendData.containsKey('phoneNum') ? friendData['phoneNum'] : 'Unknown';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(
                    friendName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(friendPhone),
                  trailing: Icon(Icons.person, color: Colors.black),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
