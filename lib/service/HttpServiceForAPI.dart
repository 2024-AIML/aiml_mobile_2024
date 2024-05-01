import 'dart:convert';
import 'package:http/http.dart' as http;

class Message{
  final String msg;
  final String locationName;
  final String create_date;

  Message({required this.msg, required this.locationName, required this.create_date});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(msg: json['msg'], locationName: json['location_name'], create_date: json['create_date']);
  }
}

class HttpService {
  static const String _url = "https://apis.data.go.kr/1741000/DisasterMsg3/getDisasterMsg1List?serviceKey=VeY2XtWCnhlTOdeDRkQ4Ssywy6pcEOdsSUc04Tliqo2eFIiqwbA72TaBiSVUnFcr25qVrNegTEMG8G1vY%2Bnm2g%3D%3D&type=json";

  static Future<List<Message>> fetchData() async {
    final url = Uri.parse(_url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final messages = decodedData['DisasterMsg'][1]['row'] as List;

      List<Message> tempMessages = messages.map<Message>((message) => Message.fromJson(message)).toList();
      return tempMessages;
    }
    else {
      throw Exception('Failed to load data');
    }
  }
}