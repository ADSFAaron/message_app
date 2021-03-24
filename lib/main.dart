import 'package:flutter/material.dart';
import 'page/chat.dart';
import 'package:message_app/page/chat.dart';
import 'page/friend.dart';

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
  int index = 21;
  int beenTaped = 999;
  List<Widget> friendList = [];
  List<Widget> chatList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _opendrawer() {
    Scaffold.of(context).openDrawer();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    chatList = createChatContainer(context);
    friendList = createFContainer(21, context);
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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.brown,
                        child: Icon(Icons.person),
                      ),
                      Text(
                        "未登錄",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            shadows:
                            [
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
                  title: Text("登入"),
                  onTap: () {
                    Navigator.of(context).pop();
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

  List<Widget> createFContainer(int index, BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < index; i++) {
      InkWell iw = InkWell(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue[200 + i % 4 * 100],
            height: 100,
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                Hero(
                    tag: "friendDetail$i",
                    child: Material(
                        type: MaterialType.transparency,
                        child: Icon(
                          Icons.person_outline,
                          size: 60,
                        ))),
                Hero(
                    tag: "NameDetail$i",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text("PersonNameHere"),
                    )),
              ],
            ),
          ),
          onTap: () {
            //print(i);
            Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => PersonDetailPage(
                  ftag: "friendDetail$i", ntag: "NameDetail$i"),
            ));
          });
      list.add(iw);
    }
    return list;
  }

  List<Widget> createChatContainer(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < 21; i++) {
      ElevatedButton con = ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all((EdgeInsets.all(10))),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 17,
            ),
            CircleAvatar(
                backgroundColor: Colors.purpleAccent,
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 30,
                )),
            Container(
              width: 10,
            ),
            Column(children: [
              Text(
                "PersonNameHere",
                style: TextStyle(fontSize: 30),
              ),
              Container(
                height: 5,
              ),
              Text(
                "Last message here",
                style: TextStyle(fontSize: 15),
              )
            ])
          ],
        ),
        onLongPress: () => {}, //TODO 預覽畫面
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
              title: "nameHere",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        },
      );
      list.add(con);
    }
    return list;
  }
}
