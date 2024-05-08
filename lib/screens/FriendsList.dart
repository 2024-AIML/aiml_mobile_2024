import 'package:flutter/material.dart';
import '../screens/FriendsInfo.dart';


class FriendsList extends StatefulWidget{
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<String> friends = [];
  
  
  void fetchFriends(){

  }
  
  @override
  void initState(){
    super.initState();
    fetchFriends();
  }
  
  
  
  Widget _buildFriendsList(){
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index){
        return ListTile(
          title : Text(friends[index]),
          onTap: (){
            // 타일 누르면 해당 친구의 정보를 보여주는 화면으로 이동함 
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => FriendsInfo(friendsName: friends[index])),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _buildFriendsList(),
    );
  }
}

