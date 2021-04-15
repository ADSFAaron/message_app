import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String baseUrl = "http://140.138.152.96:3001/api/user/";
//final String baseUrl = "http://10.0.2.2:3001/api/user/";

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController myController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController checkPassword = TextEditingController();
  UserCredential userCredential;

  bool passwordOk = false;
  List<String> error = [null, null, null, null];

  void initState(){
    myController.text="zhon";
    accountController.text='henry890811@gmail.com';
    password.text="123456789";
    checkPassword.text="123456789";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
              child: SingleChildScrollView(
            // SingleChildScrollView
            child: Column(
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "請輸入使用者名稱",
                        errorText: error[0],
                      ),
                    )),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      controller: accountController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "請輸入 E-mail",
                        errorText: error[1],
                      ),
                    )),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "請輸入密碼",
                        errorText: error[2],
                      ),
                    )),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      obscureText: true,
                      controller: checkPassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "確認密碼",
                        errorText: validatePassword(checkPassword.text),
                        //prefixIcon: Icon(Icons.lock),
                      ),
                    )),
                Container(
                  height: 100,
                ),
                ElevatedButton(
                  child: Text('確認'),
                  onPressed: () => btnEvent(
                      myController.text, accountController.text, password.text),
                )
              ],
            ),
          )),
        ));
  }

  String validatePassword(String s) {
    if (password.text != s) {
      setState(() {
        passwordOk = false;
      });
      return "密碼不相同";
    } else
      passwordOk = true;
  }

  void btnEvent(
    String _username,
    String _account,
    String _password,
  ) async {
    if (passwordOk == false) return;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _account, password: _password);
      User user = userCredential.user;
      user.updateProfile(displayName: _username);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          backgroundColor: Colors.grey,
          msg: "The password provided is too weak.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          error[2] = 'The password provided is too weak.';
        });
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          backgroundColor: Colors.grey,
          msg: "The account already exists for that email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          error[1] = 'The account already exists for that email.';
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    print(userCredential);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(_account).set({
      "email":_account,
      "username":_username,
      "friend":[],
      "chatRoom":[],
      "photoURL": null,
      "bio":"這人很懶啥都沒留下"
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));


    if (userCredential != null) {
      Fluttertoast.showToast(msg: "創建帳號成功");
      Navigator.pop(context);}
  }
}
