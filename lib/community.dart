import 'package:boggle/community_post.dart';
import 'package:flutter/material.dart';
import 'package:boggle/do_list.dart';
import 'package:boggle/myhome.dart';
import 'package:boggle/mypage.dart';
import 'package:boggle/communityInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class Community extends StatefulWidget {
  final String userId;

  const Community({Key? key, required this.userId}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  var _index = 2; // 페이지 인덱스 0,1,2,3

  final List<CommunityPost> posts = [
    CommunityPost(
      '홍길동',
      'assets/user1.png',
      '2024-05-01 13:17',
      '설거지 바 써보신분?',
      '제가 액체 주방세제에서 고체 주방세제로 바꾸려고 하는데 괜찮은 설거지 바 있으면 추천 부탁드립니다.',
    ),
    CommunityPost(
      '김철수',
      'assets/user2.png',
      '2024-05-01 13:06',
      '주말에 플로깅 가시는 분 있나요?',
      '이번주 무심천에서 진행하는 플로깅에 참여하고 싶은데 혹시 가시는 분 있나요?',
    ),
  ];

  // 페이지 이동 함수
  void _navigateToPage(int index) {
    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = MyHomePage(userId: widget.userId);
        break;
      case 1:
        nextPage = DoList(userId: widget.userId);
        break;
      case 2:
        nextPage = Community(userId: widget.userId);
        break;
      case 3:
        nextPage = MyPage(userId: widget.userId);
        break;
      default:
        nextPage = MyHomePage(userId: widget.userId);
    }
    if (ModalRoute.of(context)?.settings.name != nextPage.toString()) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => nextPage));
    }
  }

  Future<void> _navigateToCommunityPostPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityPostPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        posts.add(CommunityPost(
          'one', // 사용자의 닉네임 -> DB에서 가져올 것
          'assets/usericon.png', // 사용자 아이콘 경로
          result['date'],
          result['title'],
          result['content'],
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'image/boggleimg.png',
          height: 28, // 이미지 높이 설정
          fit: BoxFit.cover, // 이미지 fit 설정
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text('금주의 플로깅에 참여해보세요!'),
                const SizedBox(height: 16.0),
                Image.asset('image/commu.png'), // Updated image path
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommunityPostScreen(post: posts[index]),
                      ),
                    );
                  },
                  child: _buildPost(posts[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
          _navigateToPage(index);
        },
        currentIndex: _index,
        selectedItemColor: const Color.fromARGB(255, 196, 42, 250),
        unselectedItemColor: const Color.fromARGB(255, 235, 181, 253),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: '실천', icon: Icon(Icons.check_circle)),
          BottomNavigationBarItem(label: '커뮤니티', icon: Icon(Icons.group)),
          BottomNavigationBarItem(label: 'MY', icon: Icon(Icons.person)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCommunityPostPage,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 196, 42, 250),
      ),
    );
  }

  Widget _buildPost(CommunityPost post) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('image/usericon.png'),
              ),
              const SizedBox(width: 8.0),
              Text(post.userNickname),
              const Spacer(),
              Text(post.postdate),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(post.postTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4.0),
          Text(post.postContent),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.grey,
                onPressed: () {
                  // Handle like action
                },
              ),
              Text(
                  '${post.likeCount}'), // Static example, replace with dynamic data
              const SizedBox(width: 16.0),
              IconButton(
                icon: const Icon(Icons.comment),
                color: Colors.grey,
                onPressed: () {
                  // Handle comment action
                },
              ),
              Text(
                  '${post.commentCount}'), // Static example, replace with dynamic data
            ],
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

class CommunityPostScreen extends StatefulWidget {
  final CommunityPost post;

  CommunityPostScreen({required this.post});

  @override
  _CommunityPostScreenState createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  bool isLiked = false;
  int likeCount = 0; // 좋아요 개수 초기화
  int commentCount = 0;

  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likeCount;
    commentCount = widget.post.commentCount;
  }

  void _addComment() {
    final comment = _commentController.text;
    if (comment.isNotEmpty) {
      setState(() {
        _comments.add(comment);
        commentCount++;
        widget.post.commentCount = commentCount;
      });
      _commentController.clear();
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    setState(() {
      this.isLiked = !isLiked;
      likeCount += this.isLiked ? 1 : -1;
      widget.post.likeCount = likeCount;
    });
    return !isLiked;
  }

  @override
  void dispose() {
    _commentController.dispose();
    Navigator.pop(context, widget.post); // 변경된 post 객체를 상위 페이지로 전달합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(''), // AppBar의 텍스트를 삭제합니다.
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 196, 42, 250)),
      ),
      body: Container(
        color: Colors.white, // 배경색을 흰색으로 설정합니다.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('image/usericon.png'),
                ),
                const SizedBox(width: 8.0),
                Text(widget.post.userNickname),
                const Spacer(),
                Text(widget.post.postdate),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(widget.post.postTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Padding(padding: const EdgeInsets.all(15.0)),
            Text(widget.post.postContent, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8.0),
            Row(
              children: [
                LikeButton(
                  size: 20,
                  isLiked: isLiked,
                  likeCount: likeCount,
                  onTap: onLikeButtonTapped,
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SizedBox(
                      width: 24, // 원하는 너비 설정
                      height: 24, // 원하는 높이 설정
                      child: Image.asset('image/usericon.png'),
                    ),
                    title: Text(
                      _comments[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.grey), // 글과 댓글 사이에 경계를 추가합니다.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력해주세요.',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 196, 42, 250)),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
