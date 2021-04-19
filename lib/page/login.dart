import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';


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

  String errorText;
  String errorPasswordText;
  // GoogleSignInAccount _currentUser;
  UserCredential userCredential;
  @mustCallSuper
  void initState() {
    super.initState();
    errorText = null;
    errorPasswordText= null;
   accountController.text = "henry890811@gmail.com";
   passwordController.text = "123456789";
  }

  void _loginButton(String text1, String text2) async {
//    print(text1);
//    print(text2);
//  print("button");
//     User user =userCredential
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: text1,
          password: text2
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          backgroundColor: Colors.grey,
          msg: 'No user found for that email.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          errorText ="No user found for that email.";
          errorPasswordText= errorText;
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          backgroundColor: Colors.grey,
          msg: "Wrong password provided for that user.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          errorPasswordText= "Wrong password provided for that user.";
        });
        print('Wrong password provided for that user.');
      }
    }
    print(userCredential);
    if(userCredential!=null)
      Navigator.of(context).pop(userCredential.user);
  }

  Future<UserCredential> signInWithGoogle() async {
    Fluttertoast.showToast(msg: "不知為啥會有問題");
  //TODO 可用但資料庫得處理
  //   print("0");
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  //
  //   print("1");
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //   print("2");
  //   // Create a new credential
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  // print("123");
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text("登入"),
        ),
        body:
        InkWell(
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
                        errorText: errorPasswordText,
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
                  Divider(),
                  SignInButton(
                    Buttons.Google,
                    onPressed: ()=>print('1'),
                  )
                ],
              ),
            ))
    );
  }
}
