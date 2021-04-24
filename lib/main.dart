import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:message_app/shared/constants.dart';
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
  int themeIndex = 6;
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
        colors: myFlexSchemes[themeIndex].light,
        surfaceStyle: FlexSurface.medium,
        // Use comfortable on desktops instead of compact, devices as default.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: AppFonts.mainFont,
      ).toTheme,
      // We do the exact same definition for the dark theme, but using
      // FlexColorScheme.dark factory and the dark FlexSchemeColor instead.
      darkTheme: FlexColorScheme.dark(
        colors: myFlexSchemes[themeIndex].dark,
        surfaceStyle: FlexSurface.medium,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: AppFonts.mainFont,
      ).toTheme,
      // Use the above dark or light theme based on active themeMode.
      themeMode: themeMode,
      home: InitialPage(
        themeMode: themeMode,
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            themeMode = mode;
          });
        },
        schemeIndex: themeIndex,
        onSchemeChanged: (int index) {
          setState(() {
            themeIndex = index;
          });
        },
        flexSchemeData: myFlexSchemes[themeIndex],),
    );
  }
}

class InitialPage extends StatefulWidget {
  InitialPage({@required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.schemeIndex,
    @required this.onSchemeChanged,
    @required this.flexSchemeData,});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int schemeIndex;
  final ValueChanged<int> onSchemeChanged;
  final FlexSchemeData flexSchemeData;
  _InitialPage createState() => _InitialPage(themeMode: themeMode,onThemeModeChanged: onThemeModeChanged,flexSchemeData: flexSchemeData,schemeIndex: schemeIndex,onSchemeChanged: onSchemeChanged);
}

class _InitialPage extends State<InitialPage> {
  _InitialPage({@required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.schemeIndex,
    @required this.onSchemeChanged,
    @required this.flexSchemeData});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int schemeIndex;
  final ValueChanged<int> onSchemeChanged;
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
            .push(MaterialPageRoute(builder: (context) => MyHomePage(user: user,userData: userData,themeMode: themeMode,onThemeModeChanged: onThemeModeChanged,flexSchemeData: flexSchemeData,schemeIndex: schemeIndex,onSchemeChanged: onSchemeChanged)));
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


const FlexSchemeColor myScheme1Light = FlexSchemeColor(
  primary: Color(0xFF4E0028),
  primaryVariant: Color(0xFF320019),
  secondary: Color(0xFF003419),
  secondaryVariant: Color(0xFF002411),
  // The built in schemes use their secondary variant color as their
  // custom app bar color, it could of course be any color, but for consistency
  // we will do the same in this custom FlexSchemeColor.
  appBarColor: Color(0xFF002411),
);
// Create a corresponding custom flex scheme color for a dark theme.
const FlexSchemeColor myScheme1Dark = FlexSchemeColor(
  primary: Color(0xFF9E7389),
  primaryVariant: Color(0xFF775C69),
  secondary: Color(0xFF738F81),
  secondaryVariant: Color(0xFF5C7267),
  // Again we use same secondaryVariant color as optional custom app bar color.
  appBarColor: Color(0xFF5C7267),
);

// You can build a scheme the long way, by specifying all the required hand
// picked scheme colors, like above, or can also build schemes from a
// single primary color. With the [.from] factory, then the only required color
// is the primary color, the other colors will be computed. You can optionally
// also provide the primaryVariant, secondary and secondaryVariant colors with
// the factory, but any color that is not provided will always be computed for
// the full set of required colors in a FlexSchemeColor.

// In this example we create our 2nd scheme from just a primary color
// for the light and dark schemes. The custom app bar color will in this case
// also receive the same color value as the one that is computed for
// secondaryVariant color, this is the default with the [from] factory.
final FlexSchemeColor myScheme2Light =
FlexSchemeColor.from(primary: const Color(0xFF4C4E06));
final FlexSchemeColor myScheme2Dark =
FlexSchemeColor.from(primary: const Color(0xFF9D9E76));

// For our 3rd custom scheme we will define primary and secondary colors, but no
// variant colors, we will not make any dark scheme definitions either.
final FlexSchemeColor myScheme3Light = FlexSchemeColor.from(
  primary: const Color(0xFF993200),
  secondary: const Color(0xFF1B5C62),
);

// Create a list with all color schemes we will use, starting with all
// the built-in ones and then adding our custom ones at the end.
final List<FlexSchemeData> myFlexSchemes = <FlexSchemeData>[
  // Use the built in FlexColor schemes, but exclude the placeholder for custom
  // scheme, a selection that would typically be used to compose a theme
  // interactively in the app using a color picker, we won't be doing that in
  // this example.
  ...FlexColor.schemesList,
  // Then add our first custom FlexSchemeData to the list, we give it a name
  // and description too.
  const FlexSchemeData(
    name: 'Toledo purple',
    description: 'Purple theme, created from full custom defined color scheme.',
    // FlexSchemeData holds separate defined color schemes for light and
    // matching dark theme colors. Dark theme colors need to be much less
    // saturated than light theme. Using the same colors in light and dark
    // theme modes does not look nice.
    light: myScheme1Light,
    dark: myScheme1Dark,
  ),
  // Do the same for our second custom scheme.
  FlexSchemeData(
    name: 'Olive green',
    description:
    'Olive green theme, created from primary light and dark colors.',
    light: myScheme2Light,
    dark: myScheme2Dark,
  ),
  // We also do the same for our 3rd custom scheme, BUT we create its matching
  // dark colors, from the light FlexSchemeColor with the toDark method.
  FlexSchemeData(
    name: 'Oregon orange',
    description: 'Custom orange and blue theme, from only light scheme colors.',
    light: myScheme3Light,
    // We create the dark desaturated colors from the light scheme.
    dark: myScheme3Light.toDark(),
  ),
];