import 'dart:async';
import 'package:flutter/material.dart';
import '../widget/CommonScaffold.dart'; // Import for CommonScaffold
import '../service/HttpServiceForAPI.dart'; // Import for API calls
import 'AddFriend.dart';
import 'FriendsNotification.dart';
import 'Guidelines.dart';
import 'MorseCode.dart';
import 'MyPage.dart';

class ShowFirstThreeMessages extends StatefulWidget {
  const ShowFirstThreeMessages({Key? key}) : super(key: key);

  @override
  _ShowFirstThreeMessagesState createState() => _ShowFirstThreeMessagesState();
}

class _ShowFirstThreeMessagesState extends State<ShowFirstThreeMessages> {
  List<Message> _latestMessages = [];
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    List<Message> messages = await HttpService.fetchData();
    setState(() {
      _latestMessages = messages.take(3).toList(); // Only show the first three messages
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 100, // Adjust the scroll amount based on your message height
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _latestMessages.isNotEmpty
        ? Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light gray background
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 100, // Adjust height as needed
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels != 0) {
            _scrollController.jumpTo(0); // Reset scroll position to the top when reaching the end
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _latestMessages.length * 2, // Create a loop effect
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.centerLeft, // Left-aligned text
              child: Container(
                margin: EdgeInsets.only(bottom: 8.0), // Space between messages
                child: Text(
                  _latestMessages[index % _latestMessages.length].msg,
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.left,
                ),
              ),
            );
          },
          scrollDirection: Axis.vertical,
        ),
      ),
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}

class HomeScreenAfterLogin extends StatelessWidget {
  final String userName; // Add userName variable

  HomeScreenAfterLogin({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text('홈 화면'),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.black),
          onPressed: () {
            _showMenu(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            _showOptionsModal(context);
          },
        ),
      ],
      pages: [
        _buildHomeContent(),
        // Add more pages here if needed, e.g., InfraLocation(), ShelterLocation(), etc.
      ],
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Text(
                  '안녕하세요 $userName 님!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  '최근 문자',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          ShowFirstThreeMessages(),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  '지금 내 주변은',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          // --------------- 여기에 지도 넣어야해요 아마도 ??????? ----------------







          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  '게시판',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          /// ------- 게시판 글 불러오는 자리
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
}
