import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold.dart 파일 import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      title: Text('Home'), // 홈 화면의 타이틀
      body: Center(
        child: Text("이제 여기에다가 구현하시면 됩니다."
            "다른 것들도 페이지 만들어서 비슷하게 위에다가 연결하시면 될 듯해요..."),
      ),
    );



    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('User Data'),
    //   ),
    //   body: StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection('sample').snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       var users = snapshot.data?.docs;
    //       return ListView.builder(
    //         itemCount: users?.length,
    //         itemBuilder: (context, index) {
    //           var userData = users?[index];
    //           var name = userData?['name'];
    //           var email = userData?['email'];
    //           return ListTile(
    //             title: Text(name),
    //             subtitle: Text(email),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );











  }
}