import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
//TODO
//TODO 建 subDocument

class ChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;

  ChatPage({Key key, @required this.roomId, @required this.roomName})
      : super(key: key);

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
    setState(() {});
  }

  Widget build(BuildContext context) {
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
                          .collection('messages')
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              return handleMessage(document);
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
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => myBottomSheet(context)),
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
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.blueGrey[800],
            )),
      ),
      VerticalDivider(),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: other ? Colors.brown[300] : Colors.greenAccent,
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
                  image: DecorationImage(image: NetworkImage(photoURL))))
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
            children: other ? list.reversed.toList() : list));
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
    );
  }
}

Future getImage(picker,_source) async {
  final pickedFile = await picker.getImage(source: _source);
  print(pickedFile);
}

void myBottomSheet(BuildContext context) {
  File _image;
  final picker = ImagePicker();
  // showBottomSheet || showModalBottomSheet
  showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 200,
            child:
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: <Widget>[
                InkWell(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.camera_alt),Text("相機")]),onTap:()=> getImage(picker,ImageSource.camera),),
                InkWell(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.photo),Text("相片")]),onTap:()=> getImage(picker,ImageSource.gallery),),
                Icon(Icons.airport_shuttle),
                Icon(Icons.all_inclusive),
                Icon(Icons.beach_access),
                Icon(Icons.cake),
                Icon(Icons.free_breakfast),
              ],
            ));
      });
}

FirebaseAuth auth = FirebaseAuth.instance;

Widget handleMessage(QueryDocumentSnapshot document) {
  if (document.data()['type'] == "image") {
    return ImageBox();
  }
  return MessageBox(
    username: document.data()['username'],
    time: document.data()['time'].toDate(),
    photoURL: document.data()['photoURL'],
    other: document.data()['email'] == auth.currentUser.email ? false : true,
    text: document.data()['content'],
  );
}

class ImageBox extends StatelessWidget {
  final String imageURL;
  final bool other;
  final String photoURL;
  final String username;
  final DateTime time;

  ImageBox(
      {Key key,
      this.imageURL,
      this.other,
      this.photoURL,
      this.username,
      this.time})
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
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.blueGrey[800],
            )),
      ),
      VerticalDivider(),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(imageURL), fit: BoxFit.cover)),
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
                  image: DecorationImage(image: NetworkImage(photoURL))))
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
            children: other ? list.reversed.toList() : list));
  }
}
