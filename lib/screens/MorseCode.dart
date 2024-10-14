import 'package:flutter/material.dart';

class MorseCodePage extends StatelessWidget {
  // Map of letters to Morse code
  final Map<String, String> morseCodeMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
    'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
    'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '1': '.----', '2': '..---', '3': '...--',
    '4': '....-', '5': '.....', '6': '-....', '7': '--...', '8': '---..',
    '9': '----.', '0': '-----'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모스부호 안내'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '모스부호(Morse Code)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              ' 모스부호는 신호 발생장치의 한 종류로 짧은신호(.)와 긴 긴호(-)를 적절하게 조합하여 문자기호를 표기하는 방식입니다.이를 구조요청에 활용해보세요.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              '모스부호 변환기:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MorseCodeWidget(),

            Text(
              'Morse Code Chart:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...morseCodeMap.entries.map((entry) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                    side:BorderSide(color:Colors.black,width:1.5,)
                ),
                child: ListTile(
                  title: Text('${entry.key}: ${entry.value}',
                      style: TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MorseCodeWidget extends StatefulWidget {
  @override
  _MorseCodeWidgetState createState() => _MorseCodeWidgetState();
}

class _MorseCodeWidgetState extends State<MorseCodeWidget> {
  final TextEditingController _textController = TextEditingController();
  String _morseCodeOutput = '';

  final Map<String, String> _morseCodeMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
    'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
    'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '1': '.----', '2': '..---', '3': '...--',
    '4': '....-', '5': '.....', '6': '-....', '7': '--...', '8': '---..',
    '9': '----.', '0': '-----'
  };

  void _convertToMorseCode(String text) {
    String result = text.toUpperCase().split('').map((char) {
      return _morseCodeMap[char] ?? '';
    }).join(' ');
    setState(() {
      _morseCodeOutput = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: '문자를 입력하세요(영문)',
                  labelStyle: TextStyle(color:Colors.green[900]),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green[900]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _convertToMorseCode(_textController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text('확인'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          '변환 결과:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _morseCodeOutput,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}