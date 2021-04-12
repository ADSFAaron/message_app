import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:message_app/page/register.dart';

class ReturnFValue {
  final FriendDetail friend;
  final String str;

  ReturnFValue({this.friend, this.str});
}

class FriendDetail {
  @required final String account;
  final NetworkImage photoClip;
  @required
  final bool hasPhoto;
  @required
  final String name;
  Icon icon;

  FriendDetail({@required this.name, this.photoClip,@required this.hasPhoto,@required this.account})
      : assert(hasPhoto == true || photoClip == null, "有圖片要給圖片") {
    if (hasPhoto == false) {
      icon = Icon(
        Icons.person,
        size: 60,
      );
    }
  }
}

Future<List<FriendDetail>> loadFriend(List friendList) async {
//  print("into loadFriend----------------------");
  List<FriendDetail> list = [];
  for (int i = 0; i < friendList.length; i++) {
//    print((friendList.elementAt(i)).runtimeType);
    Map<String,String> json =Map<String,String>.from(friendList.elementAt(i));
//    print("--------------------------");
    try{
    var response = await http.post(Uri.parse(baseUrl + "getFriendData"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"account": json['account']}));
//    print("get response----------------");
//    print(response.body);
    Map<String,dynamic> toJson = jsonDecode(response.body);
    list.add(FriendDetail(
        account: toJson["account"],
        name: toJson['username'],
        hasPhoto: toJson['hasImage'],
        photoClip: toJson['hasImage'] ? NetworkImage(toJson['imageUrl']) : null));
  }catch(e){
      print("no account");
    }
  }
  return list;
}

class PersonDetailPage extends StatelessWidget {
  final String ftag;
  final String ntag;
  final FriendDetail friend;
  PersonDetailPage({
    Key key,
    this.friend,
    this.ftag,
    this.ntag,
  });

  Widget build(BuildContext context) {
//    print(friend.name);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context)
                .pop(ReturnFValue(friend: friend, str: "close"));
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
                        child: friend.hasPhoto
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: friend.photoClip)))
                            : Container(
                                alignment: Alignment.center,
                                child: friend.icon)))),
            Container(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                      tag: ntag,
                      child: Material(
                          type: MaterialType.transparency,
                          child: Text(friend.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.pink,
                                      offset: Offset(5.0, 5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.pink,
                                      offset: Offset(-5.0, 5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.pink,
                                      offset: Offset(5.0, -5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.pink,
                                      offset: Offset(-5.0, -5.0),
                                    ),
                                  ]))))),
            ),
            Container(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Detail Here\nabc\ndefg\nhijklm\nnopqrs\ntuvwxyz",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: Text("")),
            Container(
              //TODO 三個按鈕的功能 封鎖最後 刪除第二
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
                      Navigator.of(context).pop(
                          ReturnFValue(friend: friend, str: "sendMessage"));
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
  AddFriendPage({Key key,@required this.account}) : super(key: key);
  final String account;
  _AddFriendPage createState() => _AddFriendPage(account: account);
}

class _AddFriendPage extends State<AddFriendPage> {
  _AddFriendPage({@required this.account});
  final String account;
//  _AddFriendPage();
  final TextEditingController _chatController = new TextEditingController();

  List<Widget> addFriendOutline = [];

  void _submitText(String text) async {
    addFriendOutline.clear();
    if (text == "") {
      setState(() {
        addFriendOutline.add(Text(
          "請輸入後再搜尋",
          style: TextStyle(fontSize: 40),
        ));
      });
    }
    var response = await http.post(Uri.parse(baseUrl + "getFriendData"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"account": text}));

    setState(() {
//      print("*${response.body}*");
      if (response.body!="not found") {
        print("go to create friend data");

        Map<String,dynamic> json = jsonDecode(response.body);
        print(json);
        FriendDetail friend = FriendDetail(
            account: json["account"],
            name: json['username'],
            hasPhoto: json['hasImage'],
            photoClip: json['hasImage'] ? NetworkImage(json['imageUrl']) : null);

        var photo = friend.hasPhoto?Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
              // color: Colors.redAccent,
              shape: BoxShape.circle,
              image: DecorationImage(image: friend.photoClip)),
        ):Container(
            alignment: Alignment.center,
            child: CircleAvatar(
                backgroundColor: Colors.purpleAccent,
                radius: 40,
                child: friend.icon));
        addFriendOutline.add(photo);
        addFriendOutline.add(Container(
          height: 10,
        ));
        addFriendOutline.add(Text(
          friend.name,
          style: TextStyle(fontSize: 50),
        ));
        addFriendOutline.add(Container(
          height: 5,
        ));
        addFriendOutline.add(ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              padding: MaterialStateProperty.all((EdgeInsets.all(5))),
            ),
            onPressed: () async{
//              print("------------------------------------------");
//              print(account);
              var response = await http.patch(
                Uri.parse(baseUrl+account),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({"account":friend.account})
              );
              if(response.body!='failed'){
                Map<String,dynamic> map = jsonDecode(response.body);
                Navigator.pop(context,map['friend']);
              //TODO pop後friend list 重新刷新
              //TODO 是否需要跳到 friend personDetail page
              }
            },
            child: Text("添加好友")));
      } else {
        addFriendOutline.add(Text(
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
                    color: Colors.yellow,
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
                              helperStyle: TextStyle(color: Colors.red),
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
                      children: addFriendOutline,
                    )),
                    color: Colors.green,
                  ),
                )
              ],
            )));
  }
}
