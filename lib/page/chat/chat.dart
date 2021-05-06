import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:message_app/page/chat/chatSetting.dart';
import 'package:message_app/page/setting.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//TODO
//TODO 建 subDocument

class ChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String photoURL;

  final DocumentSnapshot user;

  ChatPage({Key key, @required this.user,@required this.roomId, @required this.roomName,@required this.photoURL})
      : super(key: key);

  @override
  _ChatPage createState() => _ChatPage(roomId, roomName,photoURL,user);
}

class _ChatPage extends State<ChatPage> {
  String photoURL;
  String roomID;
  String roomName;
  FirebaseAuth auth;

  DocumentSnapshot user;

  _ChatPage(String _roomId, String _roomName,String _url,DocumentSnapshot _data) {
    roomID = _roomId;
    roomName = _roomName;
    photoURL= _url;
    user = _data;
  }

  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;

  }

  final TextEditingController _chatController = TextEditingController();

  Future<void> getImage(picker, _source) async {
    final pickedFile = await picker.getImage(source: _source);
    String name = pickedFile.path.toString().split('/').last;
    File file = File(pickedFile.path);
    // print(pickedFile.runtimeType);

    try {

      EasyLoading.show(status: 'loading...');
      TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
          .ref('message/image/' + name)
          .putFile(file);
      String download = await snapshot.ref.getDownloadURL();

      EasyLoading.dismiss();
      _submitContent(download, 'image');
    } catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
    }

    Navigator.of(context).pop();
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
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                children: <Widget>[
                  InkWell(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.camera_alt), Text("相機")]),
                    onTap: () => getImage(picker, ImageSource.camera),
                  ),
                  InkWell(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.photo), Text("相片")]),
                    onTap: () => getImage(picker, ImageSource.gallery),
                  ),
                  Icon(Icons.airport_shuttle),
                  Icon(Icons.all_inclusive),
                  Icon(Icons.beach_access),
                  Icon(Icons.cake),
                  Icon(Icons.free_breakfast),
                ],
              ));
        });
  }

  void _submitContent(String content, String type) async {
    if (content == '') return;
    _chatController.clear(); // 清空controller資料
    // print(roomID);
    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomID)
        .collection('messages')
        .add({
      'email': user.data()['email'],
      'photoURL': user.data()['photoURL'],
      'userName': user.data()['username'],
      'content': content,
      'time': Timestamp.now(),
      'type': type
    });
    setState(() {});
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(roomName),
          backgroundColor: theme.primaryColorDark,
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async{
                  await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChatSetting(roomName: roomName,docId: roomID,photoURL: photoURL,member: [],);
                    }));
                DocumentSnapshot data = await FirebaseFirestore.instance.collection('chatRoom').doc(roomID).get();
                setState(() {
                  roomName = data.data()['roomName'];
                  photoURL = data.data()['phototURL'];
                });
                })
          ],
        ),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              color: theme.primaryColor.blend(theme.backgroundColor, 70),
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
                                  return HandleMessage(
                                    document: document,
                                    auth: auth,
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
                    IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () => myBottomSheet(context)),
                    Flexible(
                        child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(),
                        hintText: '輸入文字',
                      ),
                      controller: _chatController,
                      // onSubmitted: _submitText, // 綁定事件給_submitText這個Function
                    )),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () =>
                            _submitContent(_chatController.text, 'text'))
                  ])),
                ],
              )),
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
    final ThemeData theme = Theme.of(context);
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
            )),
      ),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: other
                ? theme.secondaryHeaderColor
                : theme.colorScheme.secondary,
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(fontSize: 18.0, color: theme.backgroundColor)),
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
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                  backgroundColor:
                      other ? theme.colorScheme.secondary : theme.primaryColor,
                  radius: 35,
                  child: Icon(Icons.person,
                      size: 30, color: theme.backgroundColor))),
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
  String name;
  int i;
  String photoURL;

  ShortCutChatRoom({
    this.name,
    this.i,
    this.photoURL,
  });

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
    print(roomName);
    final ThemeData theme = Theme.of(context);
    return ListTile(
      tileColor: theme.colorScheme.secondary,
      leading: Container(
          height: 90,
          width: 90,
          child: CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: 60,
              child: Icon(
                //TODO 未來支援圖片
                Icons.person,
                size: 45,
                color: theme.secondaryHeaderColor,
              ))),
      title: Text(
        roomName,
        style: TextStyle(fontSize: 30, color: theme.backgroundColor),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
      subtitle: Text(
        "壓著往左滑看看",
        style: TextStyle(color: theme.backgroundColor),
      ),
    );
  }
}

class HandleMessage extends StatelessWidget {
  final QueryDocumentSnapshot document;

  final FirebaseAuth auth;

  HandleMessage({this.document, this.auth});

  @override
  Widget build(BuildContext context) {
    if (document.data()['type'] == "image") {
      return ImageBox(
        username: document.data()['username'],
        time: document.data()['time'].toDate(),
        photoURL: document.data()['photoURL'],
        other:
            document.data()['email'] == auth.currentUser.email ? false : true,
        imageURL: document.data()['content'],
      );
    }
    return MessageBox(
      username: document.data()['username'],
      time: document.data()['time'].toDate(),
      photoURL: document.data()['photoURL'],
      other: document.data()['email'] == auth.currentUser.email ? false : true,
      text: document.data()['content'],
    );
  }
}

class ImageBox extends StatelessWidget {
  final String imageURL;
  final bool other;
  final String photoURL;
  final String username;
  final DateTime time;

  ImageBox(
      {Key key,
      @required this.imageURL,
      @required this.other,
      @required this.photoURL,
      @required this.username,
      @required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Image image = Image.network(imageURL, fit: BoxFit.fill);
    double clipSize = 60;
    List list = <Widget>[
      Container(
        alignment: Alignment.bottomCenter,
        child: Text(timeago.format(time),
            // overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: TextStyle(
              fontSize: 12.0,
            )),
      ),
      Flexible(
        child: Container(
          child: image,
        ),
      ),
      VerticalDivider(),
      photoURL != null
          ? Container(
              width: clipSize,
              height: clipSize,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(photoURL))))
          : Container(
              width: clipSize,
              height: clipSize,
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                  backgroundColor:
                      other ? theme.colorScheme.secondary : theme.primaryColor,
                  radius: 35,
                  child: Icon(Icons.person,
                      size: 30, color: theme.backgroundColor))),
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
