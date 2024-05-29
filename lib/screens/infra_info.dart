import 'package:aiml_mobile_2024/widget/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:aiml_mobile_2024/widget/NaverMapWidget.dart';

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: '1dtmwihlto',
  onAuthFailed: (ex) {
    print("******네이버맵 인증 오류: $ex ******");
  });
  runApp(const infra_info());
}
//
// class Infra_info_NaverMapWidget extends StatefulWidget {
//   @override
//   _Infra_info_NaverMapWidget createState() => _Infra_info_NaverMapWidget();
// }
//
// class _Infra_info_NaverMapWidget extends State<Infra_info_NaverMapWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           NaverMapWidget(), // 기존 NaverMapWidget의 build 호출
//         ],
//       ),
//     );
//   }
// }

class infra_info extends StatelessWidget {
  const infra_info({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'infra_info',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffD9D9D9),
        ),
        body: Center(
          child: Container(
            width: 385,
            height: 465,
            // child: Infra_info_NaverMapWidget(),
            child: NaverMapWidget(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      )

      );
  }

}*/