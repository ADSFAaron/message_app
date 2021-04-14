import 'package:flutter/material.dart';
import 'package:message_app/page/friend.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//TODO modify
//final String chatRoomUrl = "http://10.0.2.2:3001/api/message/";
final String chatRoomUrl = "http://140.138.152.96:3001/api/message/";

class MessageDetail {
//  @required
//  final FriendDetail friend;
//  final String message;
//  Container photoClipContainer;

  MessageDetail();

  void initState() {
//    photoClipContainer = friend.hasPhoto
//        ? Container(
//            width: 70,
//            height: 70,
//            alignment: Alignment.center,
//            decoration: BoxDecoration(
//                shape: BoxShape.circle,
//                image: DecorationImage(image: friend.photoClip)))
//        : Container(
//            width: 70,
//            height: 70,
//            alignment: Alignment.center,
//            child: CircleAvatar(
//                backgroundColor: Colors.purpleAccent,
//                radius: 35,
//                child: friend.icon));
  }
}

//final List<String> l = ['a', 'b', 'c'];

Stream<List<Map<String, dynamic>>> count(FriendDetail myself) async* {
//  await Future.delayed(Duration(seconds: 5));
//  print("start strean");
  while (true) {
    try {
      if (myself.account != null) {
        var response = await http.post(Uri.parse(baseUrl + "getChatRoom"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"account": myself.account}));
        //    print(response.body);

        Map<String, dynamic> json = jsonDecode(response.body);
        List<Map<String, dynamic>> products = [];
        List<dynamic> list = json['chatRoom'];
//        print(list);
        list.forEach((element) {
          products.add(element);
        });
//        print(products[0]['roomId']);
        yield products;
      }
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      //    print("error");
      //    print(e);
    }
  }
}

class ChatPage extends StatefulWidget {
  @required
//  final FriendDetail friend;
  @required
  final FriendDetail myself;
  final String roomId;
  final String roomName;

  ChatPage({Key key, this.myself, this.roomId, this.roomName})
      : super(key: key);

  @override
  _ChatPage createState() => _ChatPage(myself, roomId, roomName);
}

class _ChatPage extends State<ChatPage> {
//  FriendDetail friend;
  FriendDetail myself;

  String roomId;
  String roomName = "沒有成員";

  _ChatPage(FriendDetail _myself, String _roomId, String _roomName) {
    myself = _myself;
    roomId = _roomId;
    roomName = _roomName;
  }

  List<Widget> _messages = [];
  final TextEditingController _chatController = TextEditingController();

  void _submitText(String text) async {
    if (text == '') return;
    _chatController.clear(); // 清空controller資料
    print(roomId);
    var response = await http.patch(Uri.parse(chatRoomUrl + roomId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "SendingAccount": myself.account,
          "time": DateTime.now().toString(),
          "message": text
        }));
    print(response.body);
    print("end submit");
//    setState(() {
//      _messages.insert(
//          0,
//          MessageBox(
//            text: text,
//            myself: myself,
//            other: false,
//          ));
////      _messages.insert(
////          0,
////          MessageBox(
////            text: text,
////            other: true,
////            friend: friend,
////          ));
//    });
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
  }

  Stream<List<Map<String, dynamic>>> loadMessage() async* {
    //TODO 獲取資料
    try {
//    List<Widget> l=[];
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      var response = await http.post(Uri.parse(chatRoomUrl + roomId));
//      print(response.body);
      Map<String, dynamic> json = jsonDecode(response.body)[0];
//      print(json);
      List<Map<String, dynamic>> messageList = [];
      List<dynamic> list = json['messageList'];
//        print(list);
      list.forEach((element) {
        messageList.add((element));
      });
//      print(list);
      yield messageList;
//      await Future.delayed(Duration(seconds: 1));
//      await Future.delayed(Duration(seconds: 6));
//      print(json['messageList']);
    }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> returnMess(List<Map<String, dynamic>> list) {
    List<Widget> l = [];
//    print("create Message");
    FriendDetail fr = FriendDetail(name: "other", hasPhoto:false, account: "1");
    for (int index = 0;index<list.length;index++){
      MessageBox bx = MessageBox(text: list.elementAt(index)['message'],
        other:list.elementAt(index)['SendingAccount']==myself.account?false:true,
        myself: list.elementAt(index)['SendingAccount']==myself.account?myself:null,
        friend: list.elementAt(index)['SendingAccount']==myself.account?null:fr,
      );
      l.insert(0,bx);
    }
    return l;
  }

  Widget build(BuildContext context) {
//    print("startBuild");
    return Scaffold(
        appBar: AppBar(title: Text(roomName)),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: loadMessage(),
                      builder: (context, snapshot) {
//                        if (snapshot.hasError) {
//                          return Container(color: Colors.red);
//                        }
//                        if (snapshot.connectionState ==
//                            ConnectionState.waiting) {
//                          return Container(
//                            child: CircularProgressIndicator(),
//                          );
//                        }
//                        if (snapshot.connectionState == ConnectionState.done) {
////                print("done");
//                          return Container(
//                            child: Text("end"),
//                          );
//                        }
                        if (!snapshot.hasData) {

                        } else {
                          _messages = returnMess(snapshot.data);

                        }
                        return ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          reverse: true,
                          // 加入reverse，讓它反轉
                          itemBuilder: (context, index) => _messages[index],
                          itemCount: _messages.length,
                        );
                      })),
              SafeArea(
                  child: Row(children: [
                Flexible(
                    child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(),
                    hintText: '輸入文字',
                  ),
                  controller: _chatController,
                  onSubmitted: _submitText, // 綁定事件給_submitText這個Function
                )),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _submitText(_chatController.text))
              ])),
            ],
          ),
        ));
  }
}

class MessageBox extends StatelessWidget {
  final String text;
  final bool other;
  final FriendDetail friend;
  final FriendDetail myself;

  MessageBox({Key key, this.text, this.other, this.friend, this.myself})
      : assert(other == false || myself == null),
        assert(other == true || friend == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double clipSize = 60;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            other ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: other
            ? <Widget>[
                friend.hasPhoto
                    ? Container(
                        width: clipSize,
                        height: clipSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: friend.photoClip)))
                    : Container(
                        width: clipSize,
                        height: clipSize,
                        alignment: Alignment.center,
                        child: CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            radius: 35,
                            child: friend.icon)),
                Container(
                  width: 5,
                ),
                Flexible(
                  child: Container(
                    color: Colors.grey,
                    padding: EdgeInsets.all(10.0),
                    child: Text(text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),
                ),
                Container(
                  width: 60,
                ),
              ]
            : <Widget>[
                Container(
                  width: 60,
                ),
                Flexible(
                  child: Container(
                    color: Colors.lightGreen,
                    padding: EdgeInsets.all(10.0),
                    child: Text(text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),
                ),
                Container(
                  width: 5,
                ),
                myself.hasPhoto
                    ? Container(
                        width: clipSize,
                        height: clipSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: myself.photoClip)))
                    : Container(
                        width: clipSize,
                        height: clipSize,
                        alignment: Alignment.center,
                        child: CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            radius: 35,
                            child: myself.icon)),
              ],
      ),
    );
  }
}
