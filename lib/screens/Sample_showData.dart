import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 이거 아직 오류 뜸

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Demo'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _db.collection('sample').snapshots(),
          builder: (context, snapshot) {
            // 데이터가 로드 중이거나 에러가 발생한 경우
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            // 데이터가 있을 경우
            else {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {

                  var doc = snapshot.data?.docs[index];
                  var email = doc?['email'];
                  var name = doc?['name'];

                  // 가져온 데이터를 ListTile로 표시
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
