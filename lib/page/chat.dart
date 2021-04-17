import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/page/friend.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

//TODO modify
//final String chatRoomUrl = "http://10.0.2.2:3001/api/message/";
// final String chatRoomUrl = "http://140.138.152.96:3001/api/message/";

//TODO
//TODO 建 subDocument
// CollectionReference messages = reference.collection('messages');
// messages.add({});

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
  final String roomId;
  final String roomName;

  ChatPage({Key key, this.roomId, this.roomName}) : super(key: key);

  @override
  _ChatPage createState() => _ChatPage(roomId, roomName);
}

class _ChatPage extends State<ChatPage> {
  String roomID;
  String roomName;
  FirebaseAuth auth;

  User user;

  _ChatPage(String _roomId, String _roomName) {
    roomID = _roomId;
    roomName = _roomName;
  }

  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  List<Widget> _messages = [];
  final TextEditingController _chatController = TextEditingController();

  void _submitText(String text) async {
    if (text == '') return;
    _chatController.clear(); // 清空controller資料
    // print(roomID);

    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomID)
        .collection('messages')
        .add({
      'email': user.email,
      'photoURL': user.photoURL,
      'userName': user.displayName,
      'content': text,
      'time': Timestamp.now()
    });
  setState(() {

  });
    // var response = await http.patch(Uri.parse(chatRoomUrl + roomId),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode({
    //       "SendingAccount": myself.account,
    //       "time": DateTime.now().toString(),
    //       "message": text
    //     }));
    // print(response.body);
    // print("end submit");
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

  Stream<List<Map<String, dynamic>>> loadMessage() async* {
    //TODO 獲取資料
//     try {
// //    List<Widget> l=[];
//     while (true) {
//       await Future.delayed(Duration(seconds: 1));
//       var response = await http.post(Uri.parse(chatRoomUrl + roomId));
// //      print(response.body);
//       Map<String, dynamic> json = jsonDecode(response.body)[0];
// //      print(json);
//       List<Map<String, dynamic>> messageList = [];
//       List<dynamic> list = json['messageList'];
// //        print(list);
//       list.forEach((element) {
//         messageList.add((element));
//       });
// //      print(list);
//       yield messageList;
// //      await Future.delayed(Duration(seconds: 1));
// //      await Future.delayed(Duration(seconds: 6));
// //      print(json['messageList']);
//     }
//     } catch (e) {
//       print(e);
//     }
  }

//   List<Widget> returnMess(List<Map<String, dynamic>> list) {
// //     List<Widget> l = [];
// // //    print("create Message");
// //     FriendDetail fr = FriendDetail(name: "other",  account: "1");
// //     for (int index = 0;index<list.length;index++){
// //       MessageBox bx = MessageBox(text: list.elementAt(index)['message'],
// //         other:list.elementAt(index)['SendingAccount']==myself.account?false:true,
// //         myself: list.elementAt(index)['SendingAccount']==myself.account?myself:null,
// //         friend: list.elementAt(index)['SendingAccount']==myself.account?null:fr,
// //       );
// //       l.insert(0,bx);
// //     }
// //     return l;
//   }

  Widget build(BuildContext context) {
//    print("startBuild");
//   FirebaseFirestore.instance.collection('chatRoom').doc(roomID).collection('messages').orderBy(field)
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
                      stream: FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc(roomID)
                          .collection('messages').orderBy("time",descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // print();
                        final int commentCount = snapshot.data.docs.length;
                        if (commentCount > 0) {
                          return ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            reverse: true,
                            // 加入reverse，讓它反轉
                            itemBuilder: (context, index) {
                              final QueryDocumentSnapshot document =
                                  snapshot.data.docs[index];
                              return MessageBox(
                                username: document.data()['username'],
                                time: document.data()['time'].toDate(),
                                photoURL: document.data()['photoURL'],
                                other: document.data()['email']==user.email? false:true,
                                text: document.data()['content'],
                              );
                            },
                            itemCount: commentCount,
                          );
                        }
                        return Center(
                          child: Text("no messages"),
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
  final String photoURL;
  final String username;
  final DateTime time;

  MessageBox(
      {Key key, this.text, this.other, this.photoURL, this.username, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double clipSize = 60;
    List list = <Widget>[
      Container(
        height: 35,
        alignment: Alignment.bottomCenter,
        child: Text(timeago.format(time),
            // overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[800],)),
      ),
      VerticalDivider(),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: other?Colors.white:Colors.greenAccent,
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(fontSize: 18.0, color: Colors.black)),
        ),
      ),
      VerticalDivider(),
      photoURL != null
          ? Container(
          width: clipSize,
          height: clipSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
              DecorationImage(image: NetworkImage(photoURL))))
          : Container(
          width: clipSize,
          height: clipSize,
          alignment: Alignment.center,
          child: CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              radius: 35,
              child: Icon(
                Icons.person,
                size: 30,
              ))),
    ];

    // print(timeago.format(time));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment:
            other ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: other
            ? list.reversed.toList():list
    ));
  }
}

class ShortCutChatRoom extends StatefulWidget {
  final String name;
  final int i;
  final String photoURL;

  ShortCutChatRoom({this.name, this.i, this.photoURL});

  _ShortCutChatRoom createState() => _ShortCutChatRoom(name, i, photoURL);
}

class _ShortCutChatRoom extends State<ShortCutChatRoom> {
  int i;
  String roomName;
  String photoURL;

  _ShortCutChatRoom(String _name, int _i, String _url) {
    roomName = _name;
    i = _i;
    photoURL = _url;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.orange[200 + (i % 4) * 100],
      leading: Container(
          // color: Colors.red,
          height: 90,
          width: 90,
          child: CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              radius: 60,
              child: Icon(
                //TODO 未來支援圖片
                Icons.person,
                size: 45,
              ))),
      title: Text(
        roomName,
        style: TextStyle(fontSize: 30),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
      subtitle: Text(
        "壓著往左滑看看",
        style: TextStyle(color: Colors.red),
      ),
      // onTap: () {
      //   Navigator.of(context).push(PageRouteBuilder(
      //     transitionDuration: Duration(milliseconds: 800),
      //     pageBuilder: (context, animation, secondaryAnimation) =>
      //         ChatPage(
      //           roomId: snapshot.elementAt(i)['roomId'],
      //           myself: myself,
      //           roomName: snapshot.elementAt(i)['roomName'],
      //         ),
      //     transitionsBuilder:
      //         (context, animation, secondaryAnimation, child) {
      //       var begin = Offset(0.0, 1.0);
      //       var end = Offset.zero;
      //       var curve = Curves.ease;
      //
      //       var tween = Tween(begin: begin, end: end)
      //           .chain(CurveTween(curve: curve));
      //       return SlideTransition(
      //         position: animation.drive(tween),
      //         child: child,
      //       );
      //     },
      //   ));
      // },
      // onLongPress: () {
      //   print("longPress");
      // },
    );
  }
}
