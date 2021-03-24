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
              alignment: Alignment.center,
              child: Text(
                "Detail Here\nabc\ndefg\nhijklm\nnopqrs\ntuvwxyz",
                style: TextStyle(fontSize: 20,),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: Text("")),
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
  final TextEditingController _chatController = new TextEditingController();

  List<Widget> AddFriendOutline = [];

  void _submitText(String text) {
    AddFriendOutline.clear();
    setState(() {
      if (text == '123') {
        CircleAvatar photo = CircleAvatar(
          radius: 90,
          backgroundColor: Colors.purple,
          child: Icon(Icons.person, size: 100),
        );
        Text Name = Text(
          "123",
          style: TextStyle(fontSize: 50),
        );
        ElevatedButton addB = ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              padding: MaterialStateProperty.all((EdgeInsets.all(5))),
            ),
            onPressed: () {
              Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "還沒製作",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            },
            child: Text("添加好友"));
        AddFriendOutline.add(photo);
        AddFriendOutline.add(Container(height: 10,));
        AddFriendOutline.add(Name);
        AddFriendOutline.add(Container(height: 5,));
        AddFriendOutline.add(addB);
      } else {
        AddFriendOutline.add(Text(
          "並未找到$text",
          style: TextStyle(fontSize: 40),
        ));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("添加好友"),
        ),
        body: InkWell(
            onTap: () {
              print("tap");
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Container(
                    color: Colors.grey[400],
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                          Flexible(
                              child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              helperText: "輸入 123 試試看",
                              helperStyle: TextStyle(color: Colors.yellow),
                              focusedBorder: OutlineInputBorder(
                                  //點擊的時候顯示
                                  borderSide: BorderSide(
                                color: Colors.green, //边框颜色为绿色
                                width: 5, //宽度为5
                              )),
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30), //边角为30
                                ),
                                borderSide: BorderSide(
                                  color: Colors.amber, //边线颜色为黄色
                                  width: 5, //边线宽度为2
                                ),
                              ),
                              hintText: '輸入文字',
                            ),
                            controller: _chatController,
                            onSubmitted:
                                _submitText, // 綁定事件給_submitText這個Function
                          )),
                          ElevatedButton(
                            child: Text("搜尋"),
                            onPressed: () {
                              _submitText(_chatController.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AddFriendOutline,
                    )),
                    color: Colors.blue,
                  ),
                )
              ],
            )));
  }
}
