import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static const String _url = "https://apis.data.go.kr/1741000/DisasterMsg3/getDisasterMsg1List?serviceKey=VeY2XtWCnhlTOdeDRkQ4Ssywy6pcEOdsSUc04Tliqo2eFIiqwbA72TaBiSVUnFcr25qVrNegTEMG8G1vY%2Bnm2g%3D%3D&type=json";

  static Future<List<String>> fetchData() async {
    final uri = Uri.parse(_url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      // JSON 응답 구조에 따라 경로를 수정하세요.
      final messages = decodedData['DisasterMsg'][1]['row'] as List;

      List<String> tempMessages = messages.map<String>((message) => message['msg'] as String).toList();
      return tempMessages;
    } else {
      throw Exception('Failed to load data');
    }
  }
}