import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String baseUrl = "http://10.0.2.2:3000/api/user/";

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
  String errorText;

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
                        errorText: checkUsername(myController.text),
                      ),
                    )),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      controller: accountController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "請輸入帳號",
                        errorText: errorText,
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
//              errorText: "errorText",
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
                  onPressed: () => btnEvent(myController.text,
                      accountController.text, password.text, context),
                )
              ],
            ),
          )),
        ));
  }

  String checkUsername(String value) {
    if ((value.length < 6 || value.length > 16 )&& value.isNotEmpty) return "密碼需要介於6~16個字之間";
    return null;
  }

  String validatePassword(String value) {
    if (value != password.text) {
      return "密碼不相同";
    }
    return null;
  }

  void btnEvent(String _username, String _account, String _password,
      BuildContext context) async {
//    print(_username);
    var map = {
      "username": _username,
      "account": _account,
      "password": _password,
      "hasImage": false
    };
    var client = http.Client();
    try {
      var uriResponse = await client.post(Uri.parse(baseUrl + "create"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(map));
//      print(await client.get(uriResponse.bodyFields['uri']));
      print(uriResponse.body);
      if (uriResponse.body == "success") {
        await showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  content: Text(
                    "登入成功",
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: <Widget>[
                    CupertinoButton(
                      child: Text("登入"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Text("還是登入"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
        Navigator.of(context).pop();
      }
      else if(uriResponse.body=="is already created"){
        setState(() {
          errorText="帳號已被註冊";
        });
      }
      else{
        print("-----------------ERROR-----------------");
      }
    } catch (e) {
      print(e);
    }
  }
}
