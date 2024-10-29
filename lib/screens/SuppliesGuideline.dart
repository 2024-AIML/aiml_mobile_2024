import 'package:flutter/material.dart';

class SuppliesguidelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대피 준비물'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: ListView(
          children: [
            Text(
              '대피 준비물',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '· 생수, 간편식, 손전등, 상비약, 라디오(건전지), 화장지(물티슈), 우의, 담요, 방독면, 마스크 등\n'
                  '· 가능하면 평소에 가족수대로 비상용 가방을 준비',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '준비물',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '· 비상식량, 음료수, 손전등, 건전지, 성냥, 라이터, 휴대용 라디오, 비상의류, 속옷, 병따개, 화장지, 수건, '
                  '구급용품, 귀중품(현금/보험증서), 안경 등(생활용품), 생리용품, 종이기저귀\n'
                  '· 귀중품 및 중요한 서류: 중요한 서류는 방수가 되는 비닐에 보관\n'
                  '· 여분의 자동차 키와 집 열쇠 세트\n'
                  '· 신용카드, 현금카드 및 현금\n'
                  '· 편안한 신발, 가벼운 우비, 얇은 담요, 보온력이 좋은 옷 등\n'
                  '· 가족 연락처, 행동요령, 지도 등이 있는 재해지도 또는 수첩',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text('[출처:국민재난안전포털]',style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
