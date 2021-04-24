import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SettingPage extends StatefulWidget{
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final FlexSchemeData flexSchemeData;
  SettingPage({ @required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.flexSchemeData,});
  _SettingPage createState()=>_SettingPage(themeMode: themeMode,onThemeModeChanged: onThemeModeChanged,flexSchemeData: flexSchemeData);
}

class _SettingPage extends State<SettingPage> {
  _SettingPage({ @required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.flexSchemeData,});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final FlexSchemeData flexSchemeData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "個人資料",
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(title: Text("個人設定"),onTap: ()=>Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PersonSettingPage(),
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
                )
            ),),
            Padding(
              padding:
              const EdgeInsets.all(10),
              child: FlexThemeModeSwitch(
                themeMode: themeMode,
                onThemeModeChanged: onThemeModeChanged,
                flexSchemeData: flexSchemeData,
              ),
            ),
          ],
        ));
  }
}

class PersonSettingPage extends StatefulWidget{
  _PersonSettingPage createState()=>_PersonSettingPage();
}

class _PersonSettingPage extends State<PersonSettingPage>{
  FirebaseAuth auth;

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp();
    super.initState();
    auth = FirebaseAuth.instance;
  }

  void uploadPhoto(_source,int changeWhere)async{
    // 先從 _source 獲取照片資訊並上傳至
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: _source);
    String name = pickedFile.path.toString().split('/').last;
    File file = File(pickedFile.path);
    // print(pickedFile.runtimeType);
    String download;
    try {
      TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
          .ref('user/image/' + name)
          .putFile(file);
      download = await snapshot.ref.getDownloadURL();
      //_submitContent(download, 'image');
    } catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
    }
    print(download);
    //修改firestore內部使用者資料

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot future = await users.doc(auth.currentUser.email).get();

    //從新刷新
    Navigator.of(context).pop();


  }

  void myBottomSheet(BuildContext context,int changeWhere) {
    //type 0改背景 1改大頭貼
    if(changeWhere ==0){
      Fluttertoast.showToast(msg: "還在開發");
      return;
    }
    // showBottomSheet || showModalBottomSheet
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 120,
              child: ListView(
                children: [
                  ListTile(title:Text("從相片挑選",),onTap: ()=>uploadPhoto(ImageSource.gallery, changeWhere),),
                  ListTile(title: Text("相機拍照"),onTap: ()=>uploadPhoto(ImageSource.camera, changeWhere),),
                ],
              )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "個人資料",
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  GestureDetector(
                      onTap:()=>myBottomSheet(context,0),
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/2.jpg"),
                                  fit: BoxFit.cover))
                      )),
                  Center(
                      child: GestureDetector(
                          onTap:()=>myBottomSheet(context,1),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.height / 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap:()=>myBottomSheet(context,0),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),
                  Align(
                      alignment: Alignment(0.4,0.4),
                      child: GestureDetector(
                          onTap:()=>myBottomSheet(context,1),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),
                ],
              ),
            ),
            //BIO
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: TextField(),
              ),
            ),
          ],
        ));
  }
}