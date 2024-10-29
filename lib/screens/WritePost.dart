import 'package:flutter/material.dart';

class WritePost extends StatefulWidget {
  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  // Function to handle form submission
  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle post submission (e.g., save to database)
      print('게시글 제목: $_title');
      print('게시글 내용: $_content');

      // Clear the form after submission
      _formKey.currentState!.reset();

      // Display a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글 작성완료!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: '제목',
                    labelStyle: TextStyle(color: Colors.green[900]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.green[900]!,))
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하시오';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '내용',
                    labelStyle: TextStyle(color: Colors.green[900]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green[900]!,))
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('제출'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
