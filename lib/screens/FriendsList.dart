import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget{
  final String Name;
  final String email;

  AddUser(this.Name, this.email);

  @override
  Widget build(BuildContext context){
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    Future<void> addUser(){
      return users
          .add({
        'name' : Name,
        'email' : email
      }).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text("Add User"),
    );
  }
}