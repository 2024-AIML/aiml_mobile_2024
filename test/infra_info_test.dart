import 'package:flutter/material.dart';

/*void main() {
  runApp(const infra_info());
}

/* class infra_info extends StatelessWidget {
  const infra_info({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          InfraInfo(),
        ]),
      ),
    );
  }
}

class InfraInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 430,
          height: 932,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 832,
                child: Container(
                  width: 430,
                  height: 100,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 430,
                  height: 70,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 34,
                top: 851,
                child: Container(
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 160,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 241,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 322,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 642,
                child: Container(
                  width: 385,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 804,
                child: Container(
                  width: 385,
                  height: 28,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 131,
                child: Container(
                  width: 385,
                  height: 465,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 657,
                child: SizedBox(
                  width: 350,
                  height: 17,
                  child: Text(
                    '원이약국',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 252,
                top: 610,
                child: SizedBox(
                  width: 149,
                  height: 17,
                  child: Text(
                    'v 거리순',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 610,
                child: SizedBox(
                  width: 45,
                  height: 17,
                  child: Text(
                    'v 병원',
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 79,
                top: 610,
                child: SizedBox(
                  width: 45,
                  height: 17,
                  child: Text(
                    'v 약국',
                    style: TextStyle(
                      color: Color(0xFFE05959),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 237,
                top: 658,
                child: SizedBox(
                  width: 149,
                  height: 17,
                  child: Text(
                    '50m',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 696,
                child: Container(
                  width: 385,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 711,
                child: SizedBox(
                  width: 350,
                  height: 17,
                  child: Text(
                    '일출약국',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 750,
                child: Container(
                  width: 385,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 765,
                child: SizedBox(
                  width: 350,
                  height: 17,
                  child: Text(
                    '인생약국',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 814,
                child: SizedBox(
                  width: 350,
                  height: 17,
                  child: Text(
                    '홍대참신한약국',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 854,
                child: Container(
                  width: 352,
                  height: 33,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/30x30"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/30x30"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 159,
                        top: 3,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/30x30"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 242,
                        top: 2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/30x30"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 322,
                        top: 2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/30x30"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 237,
                top: 711,
                child: SizedBox(
                  width: 149,
                  height: 17,
                  child: Text(
                    '50m',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 237,
                top: 764,
                child: SizedBox(
                  width: 149,
                  height: 17,
                  child: Text(
                    '50m',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 237,
                top: 818,
                child: SizedBox(
                  width: 149,
                  height: 17,
                  child: Text(
                    '50m',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} */ */