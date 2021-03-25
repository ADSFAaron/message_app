import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: InkWell(
    onTap: (){FocusScope.of(context).unfocus();},
    child:Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: "請輸入電子信箱",
                    // errorText: "errorText",
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "請輸入密碼",
//              errorText: "errorText",
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "確認密碼",
//              errorText: "errorText",
                    //prefixIcon: Icon(Icons.lock),
                  ),
                )),
            ElevatedButton(
              child: Text('確認'),
              onPressed: btnEvent,
            )
          ],
        ),
      )),
    );
  }

  void btnEvent() {
    Fluttertoast.showToast(
      backgroundColor: Colors.grey,
      msg: "還沒製作",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
