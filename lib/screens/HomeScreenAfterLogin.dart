import 'dart:async';
import 'package:aiml_mobile_2024/screens/Community.dart';
import 'package:aiml_mobile_2024/screens/FriendsLocation.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/screens/ShowCustomSearchMessage.dart';
import 'SignIn.dart';
import 'JoinMember.dart';
import 'HomeScreen.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // Import for CommonScaffold
import '../service/HttpServiceForAPI.dart'; // Import for API calls
import 'AddFriend.dart';
import 'FriendsNotification.dart';
import 'Guidelines.dart';
import 'MorseCode.dart';
import 'MyPage.dart';
import 'InfraLocation.dart';

class ShowFirstThreeMessages extends StatefulWidget {
  const ShowFirstThreeMessages({Key? key}) : super(key: key);

  @override
  _ShowFirstThreeMessagesState createState() => _ShowFirstThreeMessagesState();
}

class _ShowFirstThreeMessagesState extends State<ShowFirstThreeMessages> {
  List<Message> _latestMessages = [];
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    List<Message> messages = await HttpService.fetchData();
    setState(() {
      _latestMessages = messages.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 130, // 메시지 박스 높이 조정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 메시지 출력 부분
          Expanded(
            child: _latestMessages.isNotEmpty
                ? PageView.builder(
              controller: _pageController,
              itemCount: _latestMessages.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // 메시지 내부 여백
                  child: Center(
                    child: Text(
                      _latestMessages[index].msg,
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 8.0),

          // 도트 인디케이터
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_latestMessages.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.grey[500] // 현재 페이지에 해당하는 도트 색
                      : Colors.grey[300], // 나머지 도트 색
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}



class HomeScreenAfterLogin extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text(''), // You can set a title if needed
      pages: [
        Stack(
          children: [
            Center(child: _buildHomeContent()), // Correct usage without extra comma

            Positioned(
              top: 3.0,
              right: 16.0,
              child: IconButton(
                onPressed: () {
                  _showOptionsModal(context);
                },
                icon: Icon(Icons.person),
              ),
            ),

            Positioned(
              top: 3.0,
              right: 56.0,
              child: IconButton(
                onPressed: () {
                  _showMenu(context);
                },
                icon: Icon(Icons.help_outline, color: Colors.black),
              ),
            ),
          ],
        ),
        Community(),
        ShelterLocationScreen(),
        FriendLocation(),
        ShowCustomSearchMessage(),
        // Add more pages here if needed
      ],
    );
  }



  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjusts box padding from the sides
            child: Container(
              padding: EdgeInsets.all(20.0), // Padding inside the box
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting text
                  Row(
                    children: [
                      Text(
                        '안녕하세요,',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        ' 님!',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),



                  Row(
                    children: [
                      Text(
                        '최근 안내 문자',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  Padding(
                    padding: EdgeInsets.zero,
                    child: ShowFirstThreeMessages(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30.0,),








          // -------------------- 약국이랑 병원 등등 지도 표시하기 ---------------

          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Text.rich(
                  TextSpan(
                    text: '지금 ',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(
                        text: '내 주변은',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 400.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
              child: InfraScreen(),
            ),
          ),


SizedBox(height: 30),
          // ---------------게시판 ------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Text(
                  '우리 동네 게시판',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.0),




          // ------- 게시판 글 불러오는 자리
          // ---------- 여기부터는 임시로 넣어놓은 박스임
          Container(
            height: 80.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Center(
              child: Text(
                '게시물 게시물 게시물',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          Container(
            height: 80.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Center(
              child: Text(
                '게시물 게시물 게시물',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          Container(
            height: 80.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Center(
              child: Text(
                '게시물 게시물 게시물',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 30.0,),
        ],
      ),
    );
  }
}

void _showOptionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('마이페이지'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search_outlined),
              title: const Text('친구추가'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriend()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add_outlined),
              title: const Text('친구요청'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(
                      senderUserId: '',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () {
                Navigator.pop(context);
                // Implement logout functionality here
              },
            )
          ],
        ),
      );
    },
  );
}

void _showMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('모스부호 변환기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MorseCodePage()),
                );
              },
            ),
            ListTile(
              title: const Text('행동 지침 안내'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidelinePage()),
                );
              },
            ),
          ],
        ),
      );
    },
  );

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('마이페이지'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_search_outlined),
                title: const Text('친구추가'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFriend()),
                  );
                },
              ),
              ListTile(
                  leading: const Icon(Icons.group_add_outlined),
                  title: const Text('친구요청'),
                  onTap:(){
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>  NotificationsPage(senderUserId: '',)),
                    );
                  }
              ),

              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('로그인'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('회원가입'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> JoinMember()),
                  );
                },
              ),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  onTap:(){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()),);
                  }
              )
            ],
          ),
        );
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('모스부호 변환기'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MorseCodePage()),
                  );
                },
              ),
              ListTile(
                title: const Text('행동 지침 안내'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuidelinePage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


}