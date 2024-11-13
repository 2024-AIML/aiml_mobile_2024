import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  final String msg;
  final String locationName;
  final String createDate;

  Message({required this.msg, required this.locationName, required this.createDate});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msg: json['MSG_CN'],
      locationName: json['RCPTN_RGN_NM'],
      createDate: json['REG_YMD'],
    );
  }
}

class HttpService {
  static const String _baseUrl = "https://www.safetydata.go.kr/V2/api/DSSP-IF-00247";
  static const String _serviceKey = "TESW96301ZIAHFS6"; // 실제 키로 교체

  // 마지막 페이지 번호를 계산
  static Future<int> fetchLastPage() async {
    final url = Uri.parse("$_baseUrl?serviceKey=$_serviceKey&type=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final totalCount = decodedData['totalCount'];
      final numOfRows = decodedData['numOfRows'];
      final lastPage = (totalCount + numOfRows - 1) ~/ numOfRows;
      return lastPage;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 마지막 페이지의 데이터를 가져오기
  static Future<List<Message>> fetchData() async {
    final lastPage = await fetchLastPage();
    final url = Uri.parse("$_baseUrl?serviceKey=$_serviceKey&type=json&pageNo=$lastPage");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final messages = decodedData['body'] as List;
      return messages.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() async {
  try {
    List<Message> lastPageMessages = await HttpService.fetchData();
    for (var message in lastPageMessages) {
      print("Message: ${message.msg}");
      print("Location: ${message.locationName}");
      print("Date: ${message.createDate}");
      print('------------------');
    }
  } catch (e) {
    print(e);
  }
}
