import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widget/CommonScaffold.dart';


class JoinMember extends StatefulWidget {
  @override
  _JoinMemberState createState() => _JoinMemberState();
}

class _JoinMemberState extends State<JoinMember> {
  String _selectedGender = '남자';
  String _selectedSpecial = '해당 없음';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController id1Controller = TextEditingController();
  TextEditingController id2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  Future<void> registerUserToFirestore(String name, String email) async{
    try {
      CollectionReference _user = FirebaseFirestore.instance.collection('user');

      String lastFourDigits = phoneController.text.substring(phoneController.text.length - 4);
      String documentId = '${lastFourDigits}_${name}';

      // 사용자 정보 추가
      await _user.doc(documentId).set({
        'name': name,
        'email': email,
      });
      print('사용자 정보가 성공적으로 등록되었습니다!');

      // 사용자 정보 추가 후 필드 초기화
    } catch (e) {
      // 에러 처리
      print('사용자 정보 등록 중 오류가 발생했습니다.');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('회원가입'),
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
                onPressed: () {
                  String name = nameController.text;
                  String email = emailController.text;
                  registerUserToFirestore(name, email);
                },
                child: Text('회원가입하기'),
              ),
            ],
          ),
        ),
      ),
      //context: context,
    );
  }

  Widget fieldTitle(String title) => Padding(
    padding: EdgeInsets.only(left: 20.0),
    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
  );

  Widget textFieldHint(String hint, {bool obscureText = false}) => Container(
    margin: EdgeInsets.symmetric(horizontal: 20.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
      ),
    ),
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