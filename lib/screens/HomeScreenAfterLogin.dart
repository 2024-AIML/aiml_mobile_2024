import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiml_mobile_2024/screens/MyPage.dart';
import 'package:aiml_mobile_2024/screens/Community.dart';
import 'package:aiml_mobile_2024/screens/FriendsLocation.dart';
import 'package:aiml_mobile_2024/screens/ShelterLocation.dart';
import 'package:aiml_mobile_2024/screens/ShowCustomSearchMessage.dart';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // Import for CommonScaffold
import '../service/HttpServiceForAPI.dart'; // Import for API calls
import 'AddFriend.dart';
import 'FriendsNotification.dart';
import 'Guidelines.dart';
import 'MorseCode.dart';
import 'MyPage.dart';
import 'InfraLocation.dart';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:aiml_mobile_2024/service/LogOut.dart';



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
        color: Colors.green[100],
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


class HomeScreenAfterLogin extends StatefulWidget {
  @override
  _HomeScreenAfterLoginState createState() => _HomeScreenAfterLoginState();
}

class _HomeScreenAfterLoginState extends State<HomeScreenAfterLogin> {
  List<Map<String, dynamic>> posts = [];
  String userName = '';
  final List<Color> cardColors = [Colors.blue[50]!, Colors.green[50]!, Colors.pink[50]!];

  @override
  void initState() {
  super.initState();
  fetchPosts();
  fetchUserInfo();

}

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();
    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://54.180.158.5:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userName = userData['name'] ?? 'Unknown';
        });
      } else {
        print("Failed to load user info: ${response.statusCode}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  Future<void> fetchPosts() async {
    try{
      final response = await http.get(Uri.parse('http://54.180.158.5:8081/post/'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // 데이터를 Map 형식으로 변환 후 posts 리스트에 저장
        setState(() {
          posts = data.map((post) {
            return {
              'title': post['title'],
              'content': post['content'],
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {setState(() {
      posts = [{'title': '저 홍대 4공학관인데 살려주세요', 'content': '여기에 사람이 8명이나 있는데 이 글 보신다면 찾으러 와주세요'},
        {'title': '내 눈앞에 미사일 날라감 ㅋㅋ', 'content': '이거 실제 상황임?'},
        {'title': '이 상황에서 어떻게 살아남냐고?', 'content': '요즘 같은 난리통에 다들 멘붕인거 알겠는데, 어쨋든 살아남아야 하지 않겠냐? 내가 몇 가지 생존 팁 좀 풀어 본다. 뭐 기본적으로 물이랑 먹을 거 챙겨두는 거 필수고, 어디 안전하게 숨을 곳 있는지 미리 알아둬라. 그리고 막 나가지 말고 눈치껏 상황 파악 잘 하면서 살아남자고. 다들 자신만의 팁 있으면 공유하자. 여기서라도 살아남아야지.'},
        {'title': '아 배고프다', 'content': '우리집 통조림 다 떨어졌는데 통조림 나눔 좀 해주세요'},];
    });}}


    @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text(''),
      pages: [
        Stack(
          children: [
            Center(child: _buildHomeContent()),

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
          SizedBox(height: 50),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '안녕하세요,',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    ' $userName 님!',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
            ),

          SizedBox(height: 20.0),

          // Notification Box
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.red[300],
                          size: 24),
                      SizedBox(width: 8.0),
                      Text(
                        '재난알림',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
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

          SizedBox(height: 50.0),

          // Nearby Places Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Text.rich(
                  TextSpan(
                    text: '지금 ',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(
                        text: '내 주변은',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: InfraScreen(),
            ),
          ),

          SizedBox(height: 50),

          // Community Board Section
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Text(
                  '우리 동네 게시판',
                  style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),


    posts.isNotEmpty
    ? Column(
    children: posts.take(3).map((post) {
      final int index = posts.indexOf(post);
      final Color cardColor = cardColors[index % cardColors.length];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽 아이콘
            Container(
              margin: EdgeInsets.only(right: 10.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 24,
              ),
            ),
            // 카드 본체
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[400]!, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        post['title'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        post['content'] ?? 'No Content',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[700],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
    )
        : Center(child: CircularProgressIndicator()),



    SizedBox(height: 10.0),
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
                      currentUserId: '',
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
               logout(context);
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
}