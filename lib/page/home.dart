import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:message_app/main.dart';
import 'chat.dart';
import 'package:message_app/page/chat.dart';
import 'friend.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'setting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.userData, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final DocumentSnapshot userData;
  final User user;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(user: user, userData: userData);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.user, this.userData});

  int _selectedIndex = 1;
  int allMessageindex = 21;
  int beenTaped = 999;
  List<Widget> friendList = [];
  List<Widget> chatList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _widgetOptions(BuildContext context) =>
      <Widget>[friendPage(), chatRoomPage()];

  CollectionReference users;
  FirebaseAuth auth;
  User user;
  DocumentSnapshot userData;

  void initFirebase() async {
    await Firebase.initializeApp().whenComplete(() {
      print("initial completed");
    });

    auth = FirebaseAuth.instance;

    users = FirebaseFirestore.instance.collection('users');
  }

  @protected
  @mustCallSuper
  void initState() {
    initFirebase();
    super.initState();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
    });
    //_checkFinePosPermission();
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
//    messageDetail.add(MessageDetail(friend: none, message: "12"));
    //TODO 處理login前的資訊
  }

  @override
  Widget build(BuildContext context) {
    print(
        "start build main page------------------------------------------------");
    // print(userData.data());
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    children: <Widget>[
                      (user.photoURL != null)
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(user.photoURL))))
                          : Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                  backgroundColor: Colors.purpleAccent,
                                  radius: 40,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ))),
                      Divider(),
                      Text(
                        (user.displayName == null) ? "沒取名" : user.displayName,
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
                ListTile(
                  title: Text("Setting"),
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 800),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SettingPage(),
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
                ListTile(
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
                                Navigator.of(context).pop();
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => InitialPage()));
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
              ]),
            )
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          alignment: Alignment(0, 0.3),
          color: Colors.grey[850],
          child: FaIcon(
            FontAwesomeIcons.connectdevelop,
            color: Colors.white,
            size: MediaQuery.of(context).size.width / 1.5,
          ),
        ),
        IndexedStack(index: _selectedIndex, children: _widgetOptions(context))
      ]),
      bottomNavigationBar: ConvexAppBar(
        color: Colors.black,
        activeColor: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,
            Colors.grey[700],
            Colors.grey[400],
            Colors.grey[700],
            Colors.black,
            Colors.grey[700],
            Colors.grey[400],
            Colors.grey[700],
            Colors.black
          ],
          tileMode: TileMode.repeated,
        ),
        initialActiveIndex: _selectedIndex,
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icon(Icons.home), title: "Home"),
          TabItem(
            icon: Icon(Icons.comment),
            title: "Comment",
          ),
          // TabItem(icon: Icon(Icons.person),title:"myself")
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> createFContainer(BuildContext context, List friendDetail) {
    List<Widget> list = [];
    for (int i = 0; i < friendDetail.length; i++) {
      list.add(OpenContainer(
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return ShortCutFriend(
              photoURL: friendDetail.elementAt(i)['photoURL'],
              username: friendDetail.elementAt(i)['username'],
              i: i);
        },
        openBuilder: (BuildContext context, VoidCallback openContainer) {
          return PersonDetailPage(
            friendEmail: friendDetail.elementAt(i)['email'],
          );
        },
        onClosed: (List list) {
          //TODO 開聊天房間
          // print(list);
          if (list != null) {
            if (list[0] == 'sendMessage') _createChat(list);
          }
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
              return ShortCutChatRoom(
                name: snapshot[i]['roomName'],
                i: i,
                photoURL: snapshot[i]['photoURL'],
              );
            },
            openBuilder: (BuildContext context, VoidCallback openContainer) {
              return ChatPage(
                roomId: snapshot[i]['roomID'],
                roomName: snapshot[i]['roomName'],
              );
            },
          ));
      list.add(con);
    }
    return list;
  }

  Widget friendPage() {
    try {
      return CustomScrollView(
        key: ValueKey<int>(0),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.black,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 80.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Friend'),
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
                  Container(alignment: Alignment.center, color: Colors.white10)
                ]),
              );
            },
          )
        ],
      );
    } catch (e) {
      //print('build friend page error');
      Map<String, dynamic> data = userData.data();
      friendList = createFContainer(context, data['friend']);
      return CustomScrollView(
          key: ValueKey<int>(0),
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.black,
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: 80.0,
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
                      setState(() {});
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
            )
          ]);
    }
  }

  Widget chatRoomPage() {
    try {
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
            backgroundColor: Colors.black,
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
                                          Fluttertoast.showToast(msg: "尚未實作");
                                          // _cleanMessage();
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
                  Map<String, dynamic> map = snapshot.data.data();
                  List _chatList = map['chatRoom'];
                  chatList = createChatContainer(context, _chatList);
                }

                // print(snapshot.data);
                return SliverList(
                  //用來建list 裡面再放東西
                  delegate: SliverChildListDelegate(
                    chatList,
                  ),
                );
              }),
        ],
      );
    } catch (e) {
      Map<String, dynamic> map = userData.data();
      List _chatList = map['chatRoom'];
      chatList = createChatContainer(context, _chatList);
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
            backgroundColor: Colors.black,
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
                                          Fluttertoast.showToast(msg: "尚未實作");
                                          // _cleanMessage();
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
          SliverList(
            //用來建list 裡面再放東西
            delegate: SliverChildListDelegate(
              chatList,
            ),
          )
        ],
      );
    }
  }

  void addChatRoom(String _email, String _id, String _roomName) async {
    DocumentSnapshot document = await users.doc(_email).get();
    List<Map<String, dynamic>> list = List.from(document.data()['chatRoom']);
    var addThing = {
      "roomName": _roomName,
      "roomID": _id,
      "photoUrl": null,
    };
    list.add(addThing);
    users.doc(_email).update({"chatRoom": list});

    // FirebaseFirestore.instance.runTransaction((transaction) async {
    //   DocumentSnapshot freshSnap =
    //   await transaction.get(document.reference);
    //   List<Map<String, dynamic>> list =
    //   List.from(freshSnap.data()['chatRoom']);
    //   var addThing = {
    //     "roomName": _roomName,
    //     "roomID": _id,
    //     "photoUrl": null,
    //   };
    //   list.add(addThing);
    //   transaction.update(freshSnap.reference, {
    //     "chatRoom": list,
    //   });
    // });
  }

  void _createChat(List list) async {
    CollectionReference chatRoom =
        FirebaseFirestore.instance.collection("chatRoom");
    String _roomName = "${list[2]},${user.displayName} Chat";
    //TODO 創建聊天室
    DocumentReference reference = await chatRoom.add({
      'member': [list[1], user.email], // John Doe
      'roomName': _roomName, // Stokes and Sons
      'friendChat': true,
      'photoURL': null,
    });

    //TODO 把雙方的聊天室增加這個剛健的聊天室
    //用function才會跑得比較快 同時跑兩個
    addChatRoom(user.email, reference.id, _roomName);

    //TODO 跳轉道 辣個 chatRoom
    //TODO 現有作法 創建後須等待幾秒才會出現
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatPage(roomName: _roomName, roomId: reference.id),
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

    addChatRoom(list[1], reference.id, _roomName);
  }

  void _cleanMessage() {
    // setState(() {
    //   messageDetail.clear();
    // });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deleteMessage(int index) {
//     setState(() {
//       print(index);
// //      print(messageDetail.elementAt(index).friend.name);
//       messageDetail.removeAt(index);
//     });
  }
}
