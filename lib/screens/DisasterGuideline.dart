import 'package:flutter/material.dart';

class DisasterGuideline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자연재해 발생시 대피요령'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: ListView(
          children: [
            Text(
              '지진이 발생하면 이렇게 대피합니다.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildGuideSection(
              title: '1. 지진으로 흔들릴 때는?',
              content: '∙ 지진으로 흔들리는 동안은 탁자 아래로 들어가 몸을 보호하고, 탁자 다리를 꼭 잡습니다.',
            ),
            _buildGuideSection(
              title: '2. 흔들림이 멈췄을 때는?',
              content: '∙ 흔들림이 멈추면 전기와 가스를 차단하고, 문을 열어 출구를 확보합니다.',
            ),
            _buildGuideSection(
              title: '3. 건물 밖으로 나갈 때는?',
              content: '∙ 계단을 이용하여 신속하게 이동하고, 엘리베이터는 사용하지 않습니다. 엘리베이터 안에 있으면 모든 층의 버튼을 눌러 먼저 열리는 층에서 내립니다.',
            ),
            _buildGuideSection(
              title: '4. 건물 밖으로 나왔을 때는?',
              content: '∙ 가방이나 손으로 머리를 보호하며, 건물과 거리를 두고 대피합니다.',
            ),
            _buildGuideSection(
              title: '5. 대피 장소를 찾을 때는?',
              content: '∙ 떨어지는 물건에 유의하며 운동장이나 공원 등 넓은 공간으로 신속히 대피합니다. 차량 이용은 금지됩니다.',
            ),
            _buildGuideSection(
              title: '6. 대피 장소에 도착한 후에는?',
              content: '∙ 라디오나 공공기관의 안내 방송을 통해 정보를 확인하고 행동합니다.',
            ),
            SizedBox(height: 20),
            Text(
              '장소에 따라 이렇게 행동합니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildGuideSection(
              title: '1. 집안에 있을 경우',
              content: '∙ 탁자 아래로 들어가 몸을 보호하고, 전기와 가스를 차단한 후 밖으로 나갑니다.',
            ),
            _buildGuideSection(
              title: '2. 집밖에 있을 경우',
              content: '∙ 가방이나 손으로 머리를 보호하고, 넓은 공간으로 신속히 대피합니다.',
            ),
            _buildGuideSection(
              title: '3. 엘리베이터에 있을 경우',
              content: '∙ 모든 층의 버튼을 눌러 가장 먼저 열리는 층에서 내린 후 계단을 이용해 대피합니다.',
            ),
            _buildGuideSection(
              title: '4. 학교에 있을 경우',
              content: '∙ 책상 아래로 들어가 책상 다리를 꼭 잡고, 질서를 지키며 운동장으로 대피합니다.',
            ),
            _buildGuideSection(
              title: '5. 백화점, 마트에 있을 경우',
              content: '∙ 진열장에서 떨어지는 물건으로부터 몸을 보호하고, 흔들림이 멈추면 대피합니다.',
            ),
            _buildGuideSection(
              title: '6. 극장‧경기장에 있을 경우',
              content: '∙ 가방 등으로 몸을 보호하며 자리에 있다가 안내에 따라 대피합니다.',
            ),
            _buildGuideSection(
              title: '7. 전철을 타고 있을 경우',
              content: '∙ 손잡이나 기둥을 잡고, 안내에 따라 안전하게 대피합니다.',
            ),
            _buildGuideSection(
              title: '8. 운전을 하고 있는 경우',
              content: '∙ 비상등을 켜고 서서히 속도를 줄여 차를 세우고 대피합니다.',
            ),
            _buildGuideSection(
              title: '9. 산이나 바다에 있을 경우',
              content: '∙ 산사태와 지진해일을 피할 수 있는 안전한 곳으로 신속하게 이동합니다.',
            ),
            SizedBox(height: 20),
            Text(
              '몸이 불편하신 분은 이렇게 행동합니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildGuideSection(
              title: '1. 시각장애가 있는 경우',
              content: '∙ 라디오로 상황을 파악하고, 도움을 요청하며 대피합니다.',
            ),
            _buildGuideSection(
              title: '2. 거동이 불편하거나 지체장애가 있는 경우',
              content: '∙ 휠체어를 잠그고 머리와 목을 보호한 후 안전한 곳으로 대피합니다.',
            ),
            _buildGuideSection(
              title: '3. 청각장애가 있는 경우',
              content: '∙ 텔레비전의 자막방송 등을 통해 정보를 얻고, 소리를 내어 도움을 요청합니다.',
            ),
            _buildGuideSection(
              title: '4. 발달장애가 있는 경우',
              content: '∙ 가족이나 도움을 줄 사람과 함께 행동하고, 주위 사람의 도움을 요청합니다.',
            ),
            SizedBox(height: 20),
            Text(
              '어린이와 함께 있을 때에는 이렇게 행동합니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildGuideSection(
              title: '1. 유모차 보다는 아기띠를 사용합니다.',
              content: '∙ 유모차 대신 아기띠를 이용해 아이를 안고 대피하고, 신발을 신긴 후 대피합니다.',
            ),
            _buildGuideSection(
              title: '2. 손을 꼭 잡고 행동요령을 확인합니다.',
              content: '∙ 대피 시 손을 꼭 잡고 어린이의 안전을 확인하며 행동합니다.',
            ),
            SizedBox(height: 10,),
            Text('[출처:국민재난안전포털]',style: TextStyle(color:Colors.grey))
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}