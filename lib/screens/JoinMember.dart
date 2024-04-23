import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart';


class JoinMember extends StatefulWidget {
  @override
  _JoinMemberState createState() => _JoinMemberState();
}

class _JoinMemberState extends State<JoinMember> {
  String _selectedGender = '남자';
  String _selectedSpecial = '해당 없음';

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('회원가입'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fieldTitle('이름'),
              textFieldHint('이름을 입력하세요'),
              SizedBox(height: 20.0),

              fieldTitle('이메일'),
              textFieldHint('이메일을 입력하세요'),
              SizedBox(height: 20.0),

              fieldTitle('비밀번호'),
              textFieldHint('비밀번호를 입력하세요', obscureText: true),
              SizedBox(height: 20.0),

              fieldTitle('비밀번호 확인'),
              textFieldHint('비밀번호를 한 번 더 입력하세요', obscureText: true),
              SizedBox(height: 20.0),

              Text('성별', style: sectionTitleStyle()),
              genderRadioTile('남자'),
              genderRadioTile('여자'),
              SizedBox(height: 20.0),

              Text('특이사항', style: sectionTitleStyle()),
              specialRadioTile('해당 없음'),
              specialRadioTile('신체 장애'),
              ElevatedButton(
                onPressed: () {
                  // Action on press
                },
                child: Text('회원가입'),
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