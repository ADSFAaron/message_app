import 'package:flutter/material.dart';
import 'page/chat.dart';
import 'package:message_app/page/chat.dart';
import 'page/friend.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'page/login.dart';

// TODO 製作快取快速讀取用戶資訊及朋友以及聊天資訊
// TODO 串接後端 以及資料庫 儲存必要文件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int allMessageindex = 21;
  int beenTaped = 999;
  List<FriendDetail> friendDetail = [];
  List<MessageDetail> messageDetail = [];
  List<Widget> friendList = [];
  List<Widget> chatList = [];
  FriendDetail myself;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loginBoolean = false;

  List<Widget> _widgetOptions(BuildContext context) => <Widget>[
        CustomScrollView(
          key: ValueKey<int>(0),
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.purple,
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: 120.0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Friend'),
                  background: FlutterLogo(),
                ),
                leading: IconButton(
                  icon: Icon(Icons.menu, size: 30),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.add_circle, size: 30),
                    tooltip: 'Add Friend',
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AddFriendPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ));
                    },
                  ),
                ]),
            SliverGrid(
              //用來建list 裡面再放東西
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate(
                friendList,
              ),
            ),
          ],
        ),
        CustomScrollView(
          key: ValueKey<int>(1),
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.menu, size: 30),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              backgroundColor: Colors.lightGreen,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 80.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Message'),
                background: FlutterLogo(),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      showPopupWindow(
                        context,
                        offsetX: 5,
                        offsetY: 70,
                        //childSize:Size(240, 800),
                        gravity: KumiPopupGravity.rightTop,
                        //curve: Curves.elasticOut,
                        duration: Duration(milliseconds: 300),
                        bgColor: Colors.black.withOpacity(0),
                        onShowStart: (pop) {
                          print("showStart");
                        },
                        onShowFinish: (pop) {
                          print("showFinish");
                        },
                        onDismissStart: (pop) {
                          print("dismissStart");
                        },
                        onDismissFinish: (pop) {
                          print("dismissFinish");
                        },
                        onClickOut: (pop) {
                          print("onClickOut");
                        },
                        onClickBack: (pop) {
                          print("onClickBack");
                        },
                        childFun: (pop) {
                          return StatefulBuilder(
                              key: GlobalKey(),
                              builder: (popContext, popState) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  height: 76,
                                  width: 200,
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            _cleanMessage();
                                            Navigator.of(context).pop();
                                          },
                                          title: Text(
                                            "全部刪除",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                );
                              });
                        },
                      );
                    })
              ],
            ),
            SliverList(
              //用來建list 裡面再放東西
              delegate: SliverChildListDelegate(
                chatList,
              ),
            ),
          ],
        ),
      ];

  void _cleanMessage() {
    setState(() {
      messageDetail.clear();
    });
  }

  void _createChat(FriendDetail friend) async {
    int wh = -1;
    try {
      wh = messageDetail.indexWhere((element) => element.friend == friend);
      setState(() {
        messageDetail.removeAt(wh);
        messageDetail.insert(
            0,
            MessageDetail(
              friend: friend,
              message: "壓著往左滑看看",
            ));
      });
    } catch (e) {
      print("no index");
      setState(() {
        messageDetail.insert(
            0,
            MessageDetail(
              friend: friend,
              message: "壓著往左滑看看",
            ));
      });
    }
//    print("try");
    await Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
        //TODO 修改chat裡面的資料 ex 頭貼名字那些
        friend: friend,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deleteMessage(int index) {
    setState(() {
      print(index);
      print(messageDetail.elementAt(index).friend.name);
      messageDetail.removeAt(index);
    });
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    myself = FriendDetail(hasPhoto: false, name: "未登錄");
    friendDetail = loadFriend();
    messageDetail = loadMessage(allMessageindex, friendDetail);
  }

  @override
  Widget build(BuildContext context) {
    friendList = createFContainer(context);
    chatList = createChatContainer(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/2.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myself.hasPhoto
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image:
                                      DecorationImage(image: myself.photoClip)))
                          : Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                  backgroundColor: Colors.purpleAccent,
                                  radius: 40,
                                  child: myself.icon)),
                      Text(
                        myself.name,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(5.0, 5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(-5.0, 5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(5.0, -5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(-5.0, -5.0),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(children: [
                ListTile(
                  title: Text("Home"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                loginBoolean
                    ? ListTile( //TODO 新增alertDialog確定是否登出
                        title: Text("登出"),
                        onTap: () {
                          setState(() {
                            loginBoolean=false;
                            myself = FriendDetail(name: "未登入",hasPhoto: false);
                          });
                        },
                      )
                    : ListTile(
                        title: Text("登入"),
                        onTap: () async {
                          myself =
                              await Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(0.0, 1.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ));
                          if(myself.name!="未登入"){
                            setState(() {
                              loginBoolean=true;
                            });
                          }
                        },
                      ),
              ]),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.brown),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: _widgetOptions(context).elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purpleAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Comment',
            backgroundColor: Colors.lightGreen,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> createFContainer(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < friendDetail.length; i++) {
      InkWell iw = InkWell(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue[200 + i % 4 * 100],
            height: 100,
            child: Stack(
              children: [
                Hero(
                    tag: "friendDetail$i",
                    child: Material(
                        type: MaterialType.transparency,
                        child: friendDetail.elementAt(i).hasPhoto
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: friendDetail
                                            .elementAt(i)
                                            .photoClip)))
                            : Container(
                                alignment: Alignment.center,
                                child: friendDetail.elementAt(i).icon))),
                Hero(
                    tag: "NameDetail$i",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(friendDetail.elementAt(i).name,
                            style: TextStyle(color: Colors.white, shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(5.0, 5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(-5.0, 5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(5.0, -5.0),
                              ),
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pink,
                                offset: Offset(-5.0, -5.0),
                              ),
                            ])),
                      ),
                    ))
              ],
            ),
          ),
          onTap: () async {
            ReturnFValue result =
                await Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => PersonDetailPage(
                ftag: "friendDetail$i",
                ntag: "NameDetail$i",
                friend: friendDetail.elementAt(i),
              ),
            ));
            print(result.str);
            if (result.str == "sendMessage") _createChat(result.friend);
//            else if (result.str == "block") print("block"); //TODO 剩餘兩個button
          });
      list.add(iw);
    }
    return list;
  }

  List<Widget> createChatContainer(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < messageDetail.length; i++) {
      Slidable con = Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'delete',
              color: Colors.white,
              icon: Icons.delete,
              onTap: () => _deleteMessage(i),
            )
          ],
          actionExtentRatio: 1 / 4,
          child: ListTile(
            tileColor: Colors.orange[200 + (i % 4) * 100],
            leading: messageDetail.elementAt(i).friend.hasPhoto
                ? Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                messageDetail.elementAt(i).friend.photoClip)))
                : Container(
                    height: 90,
                    width: 90,
                    child: CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        radius: 35,
                        child: messageDetail.elementAt(i).friend.icon)),
            title: Text(
              messageDetail.elementAt(i).friend.name,
              style: TextStyle(fontSize: 30),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
            subtitle: Text(
              "壓著往左滑看看",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 800),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ChatPage(
                  friend: messageDetail.elementAt(i).friend,
                  myself: myself,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            },
            onLongPress: () {
              print("longPress");
            },
          ));
      list.add(con);
    }
    return list;
  }
}
