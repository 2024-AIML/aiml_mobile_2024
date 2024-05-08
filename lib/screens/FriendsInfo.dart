import 'package:aiml_mobile_2024/widget/CommonScaffold.dart';
import 'package:flutter/material.dart';

class FriendsInfo extends StatelessWidget{
  final String friendsName;

  FriendsInfo({required this.friendsName});

  @override
  Widget build(BuildContext context){
    return CommonScaffold(title: Text('친구 정보'),
        body: Center(
          child: Text('친구 이름 : $friendsName'),
        )
    );
  }
}