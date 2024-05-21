import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsInfo extends StatelessWidget{
  final String friendsName;
  final GeoPoint friendsLocation;

  FriendsInfo({required this.friendsName, required this.friendsLocation});

  @override
  Widget build(BuildContext context){
    return CommonScaffold(title: Text('친구 정보'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('친구 이름 : $friendsName'),
              SizedBox(height: 20,),
              Text('친구 위치 : ${friendsLocation.latitude}, ${friendsLocation.longitude}'),
            ],
          ),
        )
    );
  }
}