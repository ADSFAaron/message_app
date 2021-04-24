import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'page/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class InitialPage extends StatefulWidget{
  _InitialPage createState()=>_InitialPage();
}

class _InitialPage extends State<InitialPage>{
  String nowState='Loading...';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children:[
        Container(
            color:Colors.black,
            alignment: Alignment(0,-0.5),
            child:FaIcon(FontAwesomeIcons.connectdevelop,color: Colors.white,size: MediaQuery.of(context).size.width/2,),

        ),
        Container(
        child:Center(
          child: Text("聊天go",style:TextStyle(fontSize: 60,color:Colors.white)),
        )
      ),
        Container(
          alignment: Alignment(0,0.5),
          child:
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Loading...',
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                nowState,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            repeatForever: true,
            //totalRepeatCount: 4,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          )
        )
      ])
    );
  }
}