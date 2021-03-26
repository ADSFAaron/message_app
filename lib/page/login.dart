import 'package:flutter/material.dart';
import 'register.dart';
import 'friend.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

//TODO 回傳登入資訊
class _LoginPage extends State<LoginPage> {
  // Initially password is obscure
  bool _obscureText = true;
  IconData _iconForPassword = Icons.visibility_off;

  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorText=null;
  void _loginButton(String text1, String text2) {
    print(text1);
    print(text2);
    if (text1 == "123" && text2 == "123") {
      Navigator.of(context).pop(FriendDetail(hasPhoto: false, name: "123"));
    }
    else{
      setState(() {
        errorText="帳號或密碼錯誤，請輸入123再試一次";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("9000 DAMAGE 登入"),
        ),
        body: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              // SingleChildScrollView
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      controller: accountController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "帳號",
                        helperText: "請輸入帳號",
                        // hintText: "使用者帳號",
                        errorText: errorText,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        errorText: errorText,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                            icon: Icon(_iconForPassword),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                                if (_obscureText)
                                  _iconForPassword = Icons.visibility_off;
                                else
                                  _iconForPassword = Icons.remove_red_eye;
                              });
                            }),
                        //remove_red_eye)
                        labelText: "密碼",
                        helperText: "請輸入密碼，嘗試登入一次",
                        // hintText: "使用者密碼",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 52.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48.0,
                    height: 48.0,
                    child: ElevatedButton(
                      child: Text("登入"),
                      onPressed: () {
                        _loginButton(
                            accountController.text, passwordController.text);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48.0,
                    height: 48.0,
                    child: ElevatedButton(
                      child: Text("註冊帳號"),
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 800),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RegisterPage(),
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
                  ),
                ],
              ),
            )));
  }
}
