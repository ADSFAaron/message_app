import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'page/chat.dart';
import 'package:message_app/page/chat.dart';
import 'page/friend.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'page/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'page/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';

// TODO 製作快取快速讀取用戶資訊及朋友以及聊天資訊
// TODO 串接後端 以及資料庫 儲存必要文件

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  void initState() {
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    // });
  }

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
  int _selectedIndex = 1;
  int allMessageindex = 21;
  int beenTaped = 999;
  FriendDetail none = FriendDetail(name: "none", account: "1");
  List<FriendDetail> friendDetail = [];
  List<MessageDetail> messageDetail = [];
  List<Widget> friendList = [];
  List<Widget> chatList = [];
  FriendDetail myself;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _widgetOptions(BuildContext context) =>
      <Widget>[friendPage(), chatRoomPage()];

  CollectionReference users;
  FirebaseAuth auth;
  User user;

  void initFirebase() async {
    await Firebase.initializeApp().whenComplete(() {
      print("initial completed");
    });

    auth = FirebaseAuth.instance;

    FirebaseAuth.instance.authStateChanges().listen((User _user) {
      if (_user == null) {
        print('User is currently signed out!');
        user = null;
      } else {
        setState(() {
          user = _user;
        });
        print('User is signed in!');
        // print(user);
      }
    });
    users = FirebaseFirestore.instance.collection('users');
  }

  @protected
  @mustCallSuper
  void initState() {
    initFirebase();
    super.initState();

    //_checkFinePosPermission();
    myself = FriendDetail(account: null, name: "未登錄");
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
    //TODO 處理login前的資訊
  }

  @override
  Widget build(BuildContext context) {
//    chatList = createChatContainer(context, []);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/2.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: user == null
                        ? <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              backgroundColor: Colors.purpleAccent,
                              radius: 40,
                              child: Icon(
                                Icons.person,
                                size: 60,
                              ))),
                      Text(
                        "尚未登入",
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
                    ]
                        : <Widget>[
                      user.photoURL != null
                          ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                  NetworkImage(user.photoURL))))
                          : Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              backgroundColor: Colors.purpleAccent,
                              radius: 40,
                              child: Icon(
                                Icons.person,
                                size: 60,
                              ))),
                      Text(
                        (user.displayName == null)
                            ? "沒取名"
                            : user.displayName,
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
                user != null
                    ? ListTile(
                  title: Text("登出"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('確定登出?'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('你正在登出'),
                                Text("請確認是否要登出"),
                              ],
                            ),
                          ),
                          //TODO 處理一下登出的部分
                          actions: <Widget>[
                            TextButton(
                              child: Text('確定'),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                setState(() {
                                  messageDetail = [];
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
                    : ListTile(
                  title: Text("登入"),
                  onTap: () async {
                    user =
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
                  },
                ),
              ]),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: Colors.teal[700],
            alignment: Alignment.center,
            child: (user == null)
                ? ElevatedButton(
              child: Text("登入"),
              onPressed: () async {
                user = await Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      LoginPage(),
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
                //result = json黨 myself資訊
                // if (result == null)
                //   print("null");
                // else
                //   handleLoginMessage(result);
              },
            )
                : null,
          ),
          IndexedStack(
              index: _selectedIndex, children: _widgetOptions(context)),
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

  List<Widget> createFContainer(BuildContext context, List friendDetail) {
    List<Widget> list = [];
    for (int i = 0; i < friendDetail.length; i++) {
      list.add(
          OpenContainer(
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return ShortCutFriend(
                  photoURL: friendDetail.elementAt(i)['photoURL'],
                  username: friendDetail.elementAt(i)['username'],
                  i: i);
            },
            openBuilder: (BuildContext context, VoidCallback openContainer) {
              return PersonDetailPage(
                friendEmail: friendDetail.elementAt(i)['email'],);
            },
            onClosed: (List list) {
              //TODO 開聊天房間
              print(list);
            },
          ));
    }
    return list;
  }

  List<Widget> createChatContainer(BuildContext context, List snapshot) {
//    print("into createChatContainer");
//    print(snapshot);
    List<Widget> list = [];
    for (int i = 0; i < snapshot.length; i++) {
      Slidable con = Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'delete',
                color: Colors.white,
                icon: Icons.delete,
                onTap: () => Fluttertoast.showToast(msg: "尚未開發")
              // _deleteMessage(i),
            )
          ],
          actionExtentRatio: 1 / 4,
          child: OpenContainer(
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return ShortCutChatRoom(name: snapshot[i]['roomName'], i: i,photoURL: snapshot[i]['photoURL'],);
            },
            openBuilder: (BuildContext context, VoidCallback openContainer) {
              return Scaffold(appBar: AppBar(),);
            },
            onClosed: (List list) {
              //TODO 開聊天房間
              print(list);
            },
          )
      );
      list.add(con);
    }
    return list;
  }

  Widget friendPage() {
    return CustomScrollView(
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
                onPressed: () async {
                  // print("-------add---------");
                  // print(myself.account);
                  await Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AddFriendPage(
                          account: myself.account,
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
                  setState(() {});
                },
              ),
            ]),
        FutureBuilder(
          future: users.doc(user.email).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return SliverGrid(
                //用來建list 裡面再放東西
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text("Something went wrong"),
                  )
                ]),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              friendList = createFContainer(context, data['friend']);
              return SliverGrid(
                //用來建list 裡面再放東西
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildListDelegate(
                  friendList,
                ),
              );
            }
            return SliverGrid(
              //用來建list 裡面再放東西
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              ]),
            );
          },
        )
      ],
    );
  }

  Widget chatRoomPage() {
    return CustomScrollView(
      key: ValueKey<int>(3),
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
                                        style: TextStyle(color: Colors.white),
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
        StreamBuilder(
            stream: users.doc(user.email).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("error snapshot");
                return SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: 100,
                        child: Text('Something went wrong'),
                      )
                    ]));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                print("loading");
              }
              if (snapshot.hasData) {
                // print("1");
                Map<String, dynamic> map = snapshot.data.data();
                List _chatList = map['chatRoom'];
                // print(map['chatRoom']);
                chatList = createChatContainer(context, _chatList);
                // DocumentSnapshot a= map['chatRoom'][0];
                // print(a.data());
                // print(snapshot.data.data());
              }

              // print(snapshot.data);
              return SliverList(
                //用來建list 裡面再放東西
                delegate: SliverChildListDelegate(
                  chatList,
                ),
              );
//               if (snapshot.hasError) {
//                 return SliverList(
//                     delegate: SliverChildListDelegate([
//                   Container(
//                     height: 100,
//                     child: Text("error"),
//                   )
//                 ]));
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return SliverList(
//                     delegate: SliverChildListDelegate([
//                   Container(
//                     height: 100,
//                     color: Colors.red,
//                   )
//                 ]));
//               }
//               if (snapshot.connectionState == ConnectionState.done) {
// //                print("done");
//                 return SliverList(
//                     delegate: SliverChildListDelegate([
//                   Container(
//                     height: 100,
//                   )
//                 ]));
//               }
//               if (!snapshot.hasData) {
//                 return SliverList(
//                     delegate: SliverChildListDelegate([
//                   Container(
//                     height: 100,
//                   )
//                 ]));
//               } else
//                 chatList = createChatContainer(context, snapshot.data);
//               return SliverList(
//                 //用來建list 裡面再放東西
//                 delegate: SliverChildListDelegate(
//                   chatList,
//                 ),
//               );
            }),
      ],
    );
  }

  void _createChat(FriendDetail friend) async {
    var response = await http.patch(
        Uri.parse(baseUrl + 'createChat/' + myself.account),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {"chatRoomName": friend.name, "friendAccount": friend.account}));
    String roomId = jsonDecode(response.body);
//    print(response.body);
    print(roomId);
//
//    int wh = -1;
//    try {
//      wh = messageDetail.indexWhere((element) => element.friend == friend);
//      setState(() {
//        messageDetail.removeAt(wh);
//        messageDetail.insert(
//            0,
//            MessageDetail(
//              friend: friend,
//              message: "壓著往左滑看看",
//            ));
//      });
//    } catch (e) {
//      print("no index");
//      setState(() {
//        messageDetail.insert(
//            0,
//            MessageDetail(
//              friend: friend,
//              message: "壓著往左滑看看",
//            ));
//      });
//    }
////    print("try");
//    await Navigator.of(context).push(PageRouteBuilder(
//      transitionDuration: Duration(milliseconds: 800),
//      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
//        friend: friend,
//      ),
//      transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(0.0, 1.0);
//        var end = Offset.zero;
//        var curve = Curves.ease;
//
//        var tween =
//            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      },
//    ));
//    setState(() {
//      _selectedIndex = 1;
//    });
  }

  void _cleanMessage() {
    setState(() {
      messageDetail.clear();
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
//      print(messageDetail.elementAt(index).friend.name);
      messageDetail.removeAt(index);
    });
  }

  //TODO 處理登入後的資料
//   void handleLoginMessage(var result) async {
//     Map<String, dynamic> json = jsonDecode(result);
//     print(json);
// //    print(json);
//     friendDetail = await loadFriend(json['friend']);
//
//     setState(() {
//       myself = FriendDetail(
//           account: json['account'],
//           name: json['username'],
//           hasPhoto: json['hasImage'],
//           photoClip: json['hasImage'] ? json['imageUrl'] : null);
//     });
//   }

  void rebuildFriend(var result) async {
    friendDetail = await loadFriend(result);
    setState(() {});
  }
}
