import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/FriendsInfo.dart';
import '../screens/AddFriend.dart';
import '../screens/FriendsNotification.dart';

// 현재 로그인된 사용자 정보
Future<String?> fetchCurrentUserInfo() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  } catch (e) {
    print('Error fetching current user info: $e');
    return null;
  }
}

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () async {
              String? currentUserId = await fetchCurrentUserInfo();
              if (currentUserId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(currentUserId: currentUserId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('로그인되지 않은 사용자입니다')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: UserFriendsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFriend()),
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}

class UserFriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchCurrentUserInfo(),
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('로그인 되지 않은 사용자입니다.'));
        }
        String currentUserId = snapshot.data!;

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('USER_INFO')
              .doc(currentUserId)
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
              return Center(child: Text('검색된 친구가 없습니다'));
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: ListTile(
                    title: Text(doc.id),
                    onTap: () async {
                      try {
                        DocumentSnapshot locationDoc = await FirebaseFirestore.instance
                            .collection('USER_LOCATION')
                            .doc(doc.id)
                            .get();

                        if (locationDoc.exists) {
                          double longitude = locationDoc['longitude'] ?? 0.0;
                          double latitude = locationDoc['latitude'] ?? 0.0;

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendsInfo(
                                friendsName: doc.id,
                                friendsLocation: GeoPoint(latitude, longitude),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No location data found for ${doc.id}')),
                          );
                        }
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
      },
    );
  }
}
