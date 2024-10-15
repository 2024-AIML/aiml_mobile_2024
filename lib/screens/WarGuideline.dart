import 'package:flutter/material.dart';

class WarGuideline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전시 행동 요령'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('전시 일반 행동 요령'),
            _buildGuideContent(
              '집을 중심으로 정부의 방송(TV, 라디오)을 청취하며 안내에 따라 행동합니다.\n'
                  '· 비상대비 물자를 점검하고 화재ㆍ폭발 위험이 있는 가스와 전원 차단\n'
                  '· 단수ㆍ단전ㆍ가스공급 중단을 대비한 물자 준비\n'
                  '· 필요시 정부의 안내에 따라 대피소로 신속히 대피\n'
                  '· 어린이와 노약자는 미리 대피\n'
                  '· 통신망이 마비되지 않도록 불필요한 전화사용은 자제\n',
            ),
            _buildSectionTitle('대피령이 발령되면 신속하게 대피합니다.'),
            _buildGuideContent(
              '· 준비해 둔 비상대비 물자를 가지고 신속히 대피\n'
                  '· 영업장에서는 영업을 중단하고 손님 대피 유도\n'
                  '· 운행중인 차량은 공터나 도로 우측에 정차 후 대피\n'
                  '· 대피한 뒤에도 계속 정부의 방송을 들으며 안내에 따라 행동\n',
            ),
            _buildSectionTitle('전시 동원 및 피해 복구에 동참합니다.'),
            _buildGuideContent(
              '· 동원령이 선포되면 병력ㆍ인력ㆍ물자 동원대상자는 지정된 일시와 장소에 응소\n'
                  '· 헌혈, 부상자 진료, 전재민 구호 등 자원봉사 활동 동참\n'
                  '· 군사작전 및 피해복구를 위한 차량 및 주민 이동통제에 우선 협조\n',
            ),
            _buildSectionTitle('적 포격 도발 시 행동 요령'),
            _buildGuideContent(
              '· 침착하고 신속하게 대피소로 대피\n'
                  '· 운전 중인 차량은 도로 우측에 정차 후 대피\n'
                  '· 화재 발생시 유독가스에 주의하며 신속히 대피\n',
            ),
            _buildSectionTitle('민방공 경보 발령 시 행동 요령'),
            _buildGuideContent(
              '· 경계경보: 적의 공격이 예상될 때는 대피 준비\n'
                  '· 공습경보: 적의 공격 임박 시 대피소로 신속히 이동\n'
                  '· 화생방경보: 방독면 착용 후 대피\n',
            ),
            _buildSectionTitle('화생방 공격 시 행동 요령'),
            _buildGuideContent(
              '· 화학무기, 생물학무기, 핵무기 공격 시 정부의 안내에 따라 신속히 대피 및 조치\n',
            ),
            SizedBox(height: 16),
          Text('[출처:국민재난안전포털]',style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGuideContent(String content, {Color?color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WarGuideline(),
  ));
}
