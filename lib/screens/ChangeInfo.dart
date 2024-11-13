import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart';
import 'HomeScreen.dart';

//회원정보 수정하는 페이지

class ChangeInfo extends StatefulWidget {
  final String documentId; // Pass the document ID to identify the user

  ChangeInfo({required this.documentId});

  @override
  _ChangeInfoState createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  String _selectedGender = '남자';
  String _selectedSpecial = '해당 없음';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController id1Controller = TextEditingController();
  TextEditingController id2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.documentId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;


        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          id1Controller.text = userData['id1'] ?? '';
          id2Controller.text = userData['id2'] ?? '';
          emailController.text = userData['email'] ?? '';
          pwController.text = userData['pw'] ?? '';
          _selectedGender = userData['gender'] ?? '남자';
          _selectedSpecial = userData['special'] ?? '해당 없음';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      CollectionReference _user = FirebaseFirestore.instance.collection('user');

      // 사용자 정보를 갱신
      await _user.doc(widget.documentId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'id1': id1Controller.text,
        'id2': id2Controller.text,
        'pw': pwController.text,
        'gender': _selectedGender,
        'special': _selectedSpecial,
      });
      print('User information updated successfully!');
      _showUpdateSuccessDialog();
    } catch (e) {
      print('Error updating user information: $e');
    }
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원정보가 성공적으로 수정되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('회원정보 수정'),
        backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
     body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10.0),
              fieldTitle('이름'),
              SizedBox(
                width: 25.0,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "이름을 입력하세요"
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              fieldTitle('핸드폰 번호'),
              SizedBox(
                width: 25.0,
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "핸드폰 번호를 입력하세요"
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              fieldTitle('주민등록번호'),
              Row(
                children: [
                  SizedBox(
                    width: 200.0,
                    child: TextField(
                      controller: id1Controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "생년월일 6자리"
                      ),
                    ),
                  ),
                  Text(" - "),
                  SizedBox(
                    width: 150.0,
                    child: TextField(
                      controller: id2Controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "뒷자리 7자리"
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              fieldTitle('이메일'),
              SizedBox(
                width: 25.0,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "이메일을 입력하세요"
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              fieldTitle('비밀번호'),
              SizedBox(
                width: 25.0,
                child: TextField(
                  controller: pwController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "비밀번호를 입력하세요"
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 10.0),

              fieldTitle('비밀번호 확인'),
              SizedBox(
                width: 25.0,
                child: TextField(
                  controller: checkController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "비밀번호를 한 번 더 입력하세요"
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 15.0),

              Text('성별', style: sectionTitleStyle()),
              genderRadioTile('남자'),
              genderRadioTile('여자'),
              SizedBox(height: 20.0),

              Text('특이사항', style: sectionTitleStyle()),
              specialRadioTile('해당 없음'),
              specialRadioTile('뭔가... 뭔가다'),
              ElevatedButton(
                onPressed: _updateUserInfo, // Call the update method
                child: Text('회원정보 수정하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(String title) => Padding(
    padding: EdgeInsets.only(left: 20.0),
    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
  );

  TextStyle sectionTitleStyle() => TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0);

  Widget genderRadioTile(String label) => RadioListTile(
    title: Text(label),
    value: label,
    groupValue: _selectedGender,
    onChanged: (value) {
      setState(() {
        _selectedGender = value.toString();
      });
    },
  );

  Widget specialRadioTile(String label) => RadioListTile(
    title: Text(label),
    value: label,
    groupValue: _selectedSpecial,
    onChanged: (value) {
      setState(() {
        _selectedSpecial = value.toString();
      });
    },
  );
}
