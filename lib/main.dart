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
import 'package:flex_color_scheme/flex_color_scheme.dart';

// TODO 製作快取快速讀取用戶資訊及朋友以及聊天資訊
// TODO 串接後端 以及資料庫 儲存必要文件

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  _MyApp createState()=>_MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  void initState() {
    super.initState();
  }
  ThemeMode themeMode = ThemeMode.light;
//TODO 主題可透過這邊作變更
  //TODO 可套用package https://pub.dev/packages/flex_color_scheme
  @override
  Widget build(BuildContext context) {
    print("myApp build");
    const FlexScheme usedFlexScheme = FlexScheme.green;
    print(usedFlexScheme);
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      theme: FlexColorScheme.light(
        scheme: usedFlexScheme,
        // Use comfortable on desktops instead of compact, devices use default.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        //fontFamily: AppFonts.mainFont,
      ).toTheme,
      // We do the exact same definition for the dark theme, but using
      // FlexColorScheme.dark factory and the dark FlexSchemeColor in
      // FlexColor.schemes.
      darkTheme: FlexColorScheme.dark(
        scheme: usedFlexScheme,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
       // fontFamily: AppFonts.mainFont,
      ).toTheme,
      themeMode: themeMode,
      home: InitialPage(
        themeMode: themeMode,
        // On the home page we can toggle theme mode between light and dark.
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            themeMode = mode;
          });
        },
        // Pass in the FlexSchemeData we used for the active theme. Not really
        // needed to use FlexColorScheme, but we will use it to show the
        // active theme's name, descriptions and colors in the demo.
        // We also use it for the theme mode switch that shows the theme's
        // color's in the different theme modes.
        flexSchemeData: FlexColor.schemes[usedFlexScheme],),
    );
  }
}

class InitialPage extends StatefulWidget {
  InitialPage({@required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.flexSchemeData,});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final FlexSchemeData flexSchemeData;
  _InitialPage createState() => _InitialPage(themeMode: themeMode,onThemeModeChanged: onThemeModeChanged,flexSchemeData: flexSchemeData);
}

class _InitialPage extends State<InitialPage> {
  _InitialPage({@required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.flexSchemeData,});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final FlexSchemeData flexSchemeData;

  bool notLogin = false;
  String nowState = 'Loading...';
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

        await Future.delayed(Duration(milliseconds: 60));

        setState(() {
          nowState = "正在獲取使用者資料...";
        });
        await Future.delayed(Duration(milliseconds: 60));
        users = FirebaseFirestore.instance.collection('users');
        userData = await users.doc(user.email).get();
        setState(() {
          nowState = "即將進入主畫面...";
        });
        await Future.delayed(Duration(milliseconds: 60));
        // print(user);
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyHomePage(user: user,userData: userData,themeMode: themeMode,onThemeModeChanged: onThemeModeChanged,flexSchemeData: flexSchemeData)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
