import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:aiml_mobile_2024/screens/JoinMember.dart';
import 'package:aiml_mobile_2024/screens/LogIn.dart';
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // CommonScaffold.dart file import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: const Text('Home'),
      body: const Center(
        child: Text(
          ".", // Body content (can be modified as needed)
        ),
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/image/user.png', // Replace with your image path
            width: 35, // Adjust size if needed
            height: 35,
          ),
          onPressed: () {
            _showOptionsModal(context); // Show the options when the icon is tapped
          },
        ),
      ],
    );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Page'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Add Friend'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFriend()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Log In'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Sign Up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>JoinMember()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


