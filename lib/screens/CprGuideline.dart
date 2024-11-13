import 'package:flutter/material.dart';

class CprGuideline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('심폐소생술 가이드라인'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '심폐소생술(CPR) 가이드라인',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildSectionTitle('1. 반응의 확인'),
              buildParagraph(
                  '환자에게 접근하기 전에 구조자는 현장상황이 안전한지를 우선 확인하여, 안전하다고 판단되면 환자에게 다가가 어깨를 가볍게 두드리며 “괜찮으세요?”라고 물어봅니다. 이때 환자의 반응은 있으나 진료가 필요한 상태이면 119에 연락을 한 다음 환자의 상태를 자주 확인하면서 응급의료상담원의 지시를 따릅니다. 이 때 환자를 옆으로 눕히고, 환자의 한쪽 팔을 머리 밑으로 받쳐주는 자세를 취하게 함으로써, 숨쉬는 길로 이물질이 들어가는 것을 방지해 줄 수 있으며, 이 자세를 회복자세라고 부릅니다.'),
              SizedBox(height: 16),
              buildSectionTitle('2. 119 신고'),
              buildParagraph(
                  '만약 환자가 반응이 없으면, 즉시 119에 신고를 합니다. 만약 신고자가 심장충격기 교육을 받은 경험이 있고 주변에 심장충격기가 있다면 즉시 가져와 사용하며, 이후 순서에 따라 심폐소생술을 시행합니다. 이때 두 명 이상이 현장에 있다면 한 명은 심폐소생술을 시작하면서, 동시에 다른 한 명은 119 신고와 심장충격기를 가져 오는 역할을 맡도록 합니다.'),
              buildParagraph(
                  '119에 신고할 때 응급의료상담원은 발생 장소와 상황, 환자의 수와 상태, 필요한 도움 등에 대해 질문할 것입니다. 구조자가 심폐소생술 교육을 받은 적이 없거나 심폐소생술 시행에 자신이 없다면, 응급의료상담원의 지시를 따라 심폐소생술을 시행할 수 있도록 준비해야 합니다. 구조자는 응급의료상담원이 전화를 끊어도 된다고 할 때까지 전화지시를 따르며 심폐소생술을 계속합니다.'),
              SizedBox(height: 16),
              buildSectionTitle('3. 호흡과 맥박 확인'),
              buildParagraph(
                  '2015년 한국 심폐소생술 지침에 따르면 119신고 후 환자의 호흡을 확인해야 합니다. 심정지 환자의 반응을 확인하면서 호흡을 확인하는 것이 아니라 반응 확인 및 119신고 후에 환자의 호흡을 확인해야합니다. 왜냐하면 호흡의 확인과정이 매우 어려우며, 특히 심정지 호흡이 있는 경우 심정지 상황에 대한 인지가 늦어져 가슴압박의 시작이 지연되기 때문입니다.'),
              buildParagraph(
                  '심정지 호흡은 심정지 환자에게서 첫 수 분간 흔하게 나타나는데, 호흡의 빈도가 적으면서 하품을 하듯이 깊게 숨을 들이쉬는 것처럼 보이는 경우가 흔합니다. 이러한 심정지 호흡의 징후를 놓치게 되면, 심정지 환자의 생존 가능성은 낮아지게 되기 때문에, 신고자는 119 응급의료전화상담원의 도움을 받아 이를 확인하게 됩니다.'),
              buildParagraph(
                  '전문적인 교육을 받지 않은 일반인이 심정지 환자의 맥박을 확인하는 것은 정확도가 떨어지기 때문에 시행하지 않으며, 환자의 반응이 없고 호흡이 없거나 비정상적인 경우에는 심정지 환자로 판단하여 심폐소생술을 바로 시작하는 것이 바람직합니다.'),
              SizedBox(height: 16),
              buildSectionTitle('4. 가슴 압박'),
              buildParagraph(
                  '구조를 요청한 후 가장 먼저 시행해야 하는 것은 가슴압박이며, 효과적인 가슴압박은 심폐소생술 동안 심장과 뇌로 충분한 혈류를 전달하기 위한 필수적 요소입니다.'),
              buildParagraph(
                  '먼저, 가슴의 중앙인 흉골의 아래쪽 절반 부위에 한 쪽 손꿈치를 대고, 다른 한 손을 그 위에 포개어 깍지를 낍니다. 구조자의 팔꿈치를 곧게 펴고, 구조자의 체중이 실리도록 환자의 가슴과 구조자의 팔이 수직이 되도록 합니다. 가슴압박을 효과적으로 하려면 강하게 규칙적으로, 그리고 빠르게 압박해야 합니다.',
                    color:Colors.red,
                    fontWeight:FontWeight.bold,),
              buildParagraph(
                  '성인 심정지의 경우 가슴압박의 속도는 적어도 분당 100회 이상을 유지해야 하지만 분당 120회를 넘지 않아야 하며, 압박 깊이는 약 5cm를 유지하고 6cm를 넘지 않도록 합니다. 또한 가슴압박 이후 다음 압박을 위한 혈류가 심장으로 충분히 채워지도록 각각의 압박 이후 가슴의 이완이 충분히 이루어지도록 합니다.',
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              SizedBox(height: 16),
              buildSectionTitle('5. 기도 열기'),
              buildParagraph(
                  '가슴압박소생술에 더불어 인공호흡을 수행할 의지가 있는 구조자는 다음의 기도열기 및 인공호흡 술기를 배우고 익혀서 시행할 수 있습니다.'),
              buildParagraph(
                  '의식이 없는 환자의 경우 혀가 뒤로 말리면서 기도가 막힐 수 있으므로, 환자의 머리를 뒤로 기울이고 턱을 들어 올려주어서 기도를 열어주어야 합니다. 이 방법은 한 손을 심정지 환자의 이마에 대고 손바닥으로 압력을 가하여 환자의 머리가 뒤로 기울어지게 하면서, 다른 손의 손가락으로 아래턱의 뼈 부분을 머리 쪽으로 당겨 턱을 받쳐주어 머리를 뒤로 기울이는 것입니다.'),
              SizedBox(height: 16),
              buildSectionTitle('6. 인공 호흡'),
              buildParagraph(
                  '인공호흡 또한 심폐소생술에서 중요한 요소 중의 하나이며, 자신 있게 인공호흡을 수행할 수 있는 구조자는 인공호흡을 시행하는 것이 바람직합니다. 먼저 기도를 연 상태에서 2회의 인공호흡을 실시하며, 가장 많이 사용하는 방법은 입-입 인공호흡법은 다음과 같습니다.'),
              buildParagraph(
                  '‘머리기울임-턱들어올리기’ 방법으로 기도를 열어준 상태에서 환자의 입을 벌려줍니다. 머리를 젖힌 손의 엄지와 검지를 이용하여 환자의 코를 막고, 자신의 입을 환자의 입에 밀착 시킵니다. 이 때, 영아의 경우는 구조자의 입으로 아이의 입과 코를 한꺼번에 막고 시행할 수도 있습니다. 한쪽 눈으로 환자의 가슴을 주시하면서, 환자의 가슴이 팽창해 올라올 정도로 공기를 서서히(1~2초) 불어 넣습니다. 입을 떼고 환자의 입에서 불어 넣었던 공기가 다시 배출될 수 있도록 합니다. 같은 방법으로 1회 더 인공호흡을 시행합니다.'),
              SizedBox(height: 16),
              buildSectionTitle('7. 가슴 압박과 인공 호흡의 반복'),
              buildParagraph(
                '119 구조대 혹은 전문 구조자가 도착할 때까지 ',
                color: Colors.black, // 기본 텍스트 색상
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '가슴압박 30회 : 인공호흡 2회',
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,), // 빨간색으로 설정
                    ),
                    TextSpan(
                      text: '의 비율로 심폐소생술을 계속합니다. 만일 심장충격기를 사용할 줄 알고, 119 구조대 혹은 전문 구조자보다 심장충격기가 현장에 먼저 도착하면 즉시 사용합니다.',
                      style: TextStyle(color: Colors.black), // 기본 텍스트 색상
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              buildSectionTitle('8. 일반인 구조자에게 가슴압박소생술의 권고'),
              buildParagraph(
                  '가슴압박소생술은 심폐소생술 중 인공호흡은 하지 않고 가슴압박만을 시행하는 방법입니다. 일반인이 환자를 목격하게 되는 심정지 초기에는 가슴압박소생술을 한 경우와 심폐소생술(인공호흡과 가슴압박)을 한 경우에 생존율의 차이가 없으며, 가슴압박만 시행하더라도 심폐소생술을 전혀 하지 않은 경우보다 생존율을 높일 수 있다고 알려져 있습니다.',
              color: Colors.green[800] ,fontWeight: FontWeight.bold,),
              buildParagraph(
                  '그러나 인공호흡을 잘 수행할 수 있고 시행할 의사가 있다면 가슴압박과 인공호흡을 같이 시행하는 것이 바람직합니다. 만일 구조자가 인공호흡을 자신 있게 수행할 수 없다면, 가슴압박만을 계속하면서 119가 도착할 때까지 구조활동을 계속해야 합니다.'),
              SizedBox(height:16),
              buildParagraph('[출처: 질병관리청]',color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildParagraph(String text, {Color? color, FontWeight? fontWeight}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16,color: color ?? Colors.black),
      ),
    );
  }
}
