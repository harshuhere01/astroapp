import 'package:astro/Pages/call_page.dart';
import 'package:astro/Pages/chat_page.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.userList}) : super(key: key);

  List<dynamic>? userList;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;
  int _selectedPage = 0;
  bool isPageSelected = false;
  PageController _pageController = PageController(
    keepPage: true,
  );

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Search")));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Settings")));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              )),
        ],
        backgroundColor: Colors.yellow[600],
        title: const Text("Call with Astrologer"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 0,
                      text: "Chat",
                      onPressed: () {
                        _changePage(0);
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 1,
                      text: "Call",
                      onPressed: () {
                        _changePage(1);
                      }),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              controller: _pageController,
              children: [
                widget.userList!.isEmpty
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : ChatPage(
                        itemlist: widget.userList,
                      ),
                widget.userList!.isEmpty
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : CallPage(
                        itemlist: widget.userList,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
