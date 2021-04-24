import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'page/home.dart';
import 'page/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    print("myApp build0");
    return MaterialApp(
      builder: EasyLoading.init(),
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
      home: InitialPage(),
    );
  }
}

class InitialPage extends StatefulWidget {
  _InitialPage createState() => _InitialPage();
}

class _InitialPage extends State<InitialPage> {
  bool notLogin = false;
  String nowState = 'Loading...';
  FirebaseAuth auth;
  User user;
  CollectionReference users;
  DocumentSnapshot userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFirebase();
  }

  Future<void> initialFirebase() async {
    setState(() {
      nowState = "正在初始化...";
    });
    await Firebase.initializeApp().whenComplete(() {
      setState(() {
        nowState = "初始化完成";
      });
    });

    FirebaseAuth.instance.authStateChanges().listen((User _user) async {
      if (_user == null) {
        print('User is currently signed out!');
        user = null;
        setState(() {
          notLogin = true;
        });
      } else {
        setState(() {
          user = _user;
          notLogin = false;
          nowState = "登入成功 請稍後...";
        });

        Future.delayed(Duration(seconds: 1));

        setState(() {
          nowState = "正在獲取使用者資料...";
        });
        Future.delayed(Duration(seconds: 1));
        users = FirebaseFirestore.instance.collection('users');
        userData = await users.doc(user.email).get();
        setState(() {
          nowState = "即將進入主畫面";
        });
        Future.delayed(Duration(seconds: 1));
        // print(user);
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(children: [
      Container(
        color: Colors.black,
        alignment: Alignment(0, -0.5),
        child: FaIcon(
          FontAwesomeIcons.connectdevelop,
          color: Colors.white,
          size: MediaQuery.of(context).size.width / 2,
        ),
      ),
      Container(
          child: Center(
        child:
            Text("聊天go", style: TextStyle(fontSize: 60, color: Colors.white)),
      )),
      Container(
        alignment: Alignment(0, 0.5),
        child: (notLogin == false)
            ? AnimatedTextKit(
                animatedTexts: [
                  // TypewriterAnimatedText(
                  //   'Loading...',
                  //   textStyle: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 22.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   speed: const Duration(milliseconds: 100),
                  // ),
                  TypewriterAnimatedText(
                    nowState,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                repeatForever: true,
                //totalRepeatCount: 4,
                // pause: const Duration(milliseconds: 1),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              )
            : InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  child: Center(
                    child: Text(
                      '登入',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
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
                    ))),
      )
    ]));
  }
}
