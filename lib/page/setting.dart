import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingPage extends StatefulWidget {
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  FirebaseAuth auth;

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp();
    super.initState();
    auth = FirebaseAuth.instance;
  }



  void myBottomSheet(BuildContext context,int type) {
    //type 0改背景 1改大頭貼
    File _image;
    final picker = ImagePicker();
    // showBottomSheet || showModalBottomSheet
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 120,
              child: ListView(
                children: [
                  ListTile(title:Text("從相片挑選",)),
                  ListTile(title: Text("相機拍照"),),
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
                    color: Colors.red,
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
