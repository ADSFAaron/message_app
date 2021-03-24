import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonDetailPage extends StatelessWidget {
  final String ftag;
  final String ntag;

  PersonDetailPage({Key key, this.ftag, this.ntag});

  Widget build(BuildContext context) {
    // print(_tag);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 50,
            ),
            Container(
                color: Colors.blue,
                alignment: Alignment.center,
                height: 300,
                child: Hero(
                    tag: ftag,
                    child: Material(
                        type: MaterialType.transparency,
                        child: Icon(Icons.person_outline, size: 100)))),
            Container(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Hero(
                  tag: ntag,
                  child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "PersonNameHere",
                        style: TextStyle(fontSize: 40),
                      ))),
            ),
            Container(
              height: 10,
            ),
            Container(
              child: Text(
                "Detail Here",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(child: Text("123")),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: [
                            Icon(Icons.message, size: 60),
                            Text("傳訊息")
                          ],
                        )),
                    onTap: () {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.grey,
                        msg: "還沒製作",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    },
                  ),
                  InkWell(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: [Icon(Icons.delete, size: 60), Text("刪除")],
                        )),
                    onTap: () {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.grey,
                        msg: "還沒製作",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    },
                  ),
                  InkWell(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: [Icon(Icons.block, size: 60), Text("封鎖")],
                        )),
                    onTap: () {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.grey,
                        msg: "還沒製作",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class AddFriendPage extends StatefulWidget {
  AddFriendPage({Key key}) : super(key: key);

  _AddFriendPage createState() => _AddFriendPage();
}

class _AddFriendPage extends State<AddFriendPage> {
//  _AddFriendPage();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加好友"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/2,
          child:Container(
            child: Column(
              children: [
                Text("123"),
                ElevatedButton(
                  child:
                    Text("搜尋"),
                  onPressed: ()=>{print('press')},
                )
              ],
            ),
          )
          )
        ],
      )
    );
  }
}
