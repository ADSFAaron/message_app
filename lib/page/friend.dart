import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReturnFValue {
  final FriendDetail friend;
  final String str;

  ReturnFValue({this.friend, this.str});
}

class FriendDetail {
  @required
  final String account;
  final NetworkImage photoClip;
  @required
  final String name;
  Icon icon;

  FriendDetail(
      {@required this.name, @required this.photoClip, @required this.account}) {
    icon = Icon(
      Icons.person,
      size: 60,
    );
  }
}

class PersonDetailPage extends StatelessWidget {
  final String friendEmail;

  PersonDetailPage({Key key, @required this.friendEmail});

  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
//    print(friend.name);
    final ThemeData theme = Theme.of(context);
    return FutureBuilder(
        future: users.doc(friendEmail).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text('Something went wrong...'),
                ),
              );
            }
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.startTop,
                floatingActionButton: IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                body: Column(
                  children: [
                    Container(
                        color: theme.colorScheme.secondary,
                        alignment: Alignment.center,
                        height: 350,
                        child: data['photoURL'] != null
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(data['photoURL']))))
                            : Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color:theme.primaryColor
                                ))),
                   Container(
                       height: MediaQuery.of(context).size.height-350,
                       child:Column(children:[ Divider(),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(data['username'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color:theme.primaryColor,
                                      offset: Offset(5.0, 5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color:theme.primaryColor,
                                      offset: Offset(-5.0, 5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color:theme.primaryColor,
                                      offset: Offset(5.0, -5.0),
                                    ),
                                    Shadow(
                                      blurRadius: 10.0,
                                      color:theme.primaryColor,
                                      offset: Offset(-5.0, -5.0),
                                    ),
                                  ]))),
                    ),
                    Divider(),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        data['bio'],
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
                              Navigator.of(context).pop(["sendMessage",friendEmail,data['username']]);
                            },
                          ),
                          InkWell(
                            child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Column(
                                  children: [
                                    Icon(Icons.delete, size: 60),
                                    Text("刪除")
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
                                  children: [
                                    Icon(Icons.block, size: 60),
                                    Text("封鎖")
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
                        ],
                      ),
                    )
              ]))],
                ));
          }
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class AddFriendPage extends StatefulWidget {
  AddFriendPage({Key key}) : super(key: key);

  _AddFriendPage createState() => _AddFriendPage();
}

class _AddFriendPage extends State<AddFriendPage> {
  FirebaseAuth auth;
  User user;
//  _AddFriendPage();
  final TextEditingController _chatController = new TextEditingController();

  List<Widget> addFriendOutline = [];

  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    _chatController.text = "123456789@gmail.com";
  }

  void _submitText(String text) async {
    final ThemeData theme = Theme.of(context);
    addFriendOutline.clear();
    if (text == "") {
      setState(() {
        addFriendOutline.add(Text(
          "請輸入後再搜尋",
          style: TextStyle(fontSize: 40),
        ));
      });
    }
    // print(text);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot future = await users.doc(text).get();
    Map<String, dynamic> data = future.data();
    setState(() {
//      print("*${response.body}*");
      if (data != null) {
        // print("go to create friend data");

        //TODO 修改成對的形式
        FriendDetail friend = FriendDetail(
            account: data["email"],
            name: data['username'],
            photoClip: data['photoURL'] != null
                ? NetworkImage(data['photoURL'])
                : null);

        var photo = friend.photoClip != null
            ? Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    // color: Colors.redAccent,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: friend.photoClip)),
              )
            : Container(
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
            onPressed: () async {
              DocumentSnapshot document = await users.doc(user.email).get();
              FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot freshSnap =
                    await transaction.get(document.reference);
                List<Map<String, dynamic>> list =
                    List.from(freshSnap.data()['friend']);
                var addThing = {
                  "email": data['email'],
                  "username": data['username'],
                  "photoUrl": data['photoURL']
                };
                list.add(addThing);
                transaction.update(freshSnap.reference, {
                  "friend": list,
                });
              });
              Navigator.pop(context);
              // try {
              //   users.doc(user.email).update({
              //     "friend": FieldValue.arrayUnion({
              //       "email": data['email'],
              //       "name": data['username'],
              //       "photoUrl": data['photoURL']
              //     })
              //   });
              // } catch (e) {
              //   print(e);
              // }
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
    // print(auth.currentUser);
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
                    // color: Colors.yellow,
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
                              // helperText: "輸入 123 試試看",
                              // helperStyle: TextStyle(color: Colors.red),
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
                          Divider(),
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
                    // color: Colors.green,
                  ),
                )
              ],
            )));
  }
}

class ShortCutFriend extends StatelessWidget {
  final String photoURL;
  final String username;
  final int i;

  ShortCutFriend({this.photoURL, this.username, this.i});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondary,
      alignment: Alignment.center,
      height: 100,
      child: Stack(
        children: [
          photoURL != null
              ? Container(
                  alignment:  Alignment(0,-0.3),
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(photoURL))))
              : Container(
                  alignment: Alignment(0,-0.3),
                  child: Icon(
                    Icons.person,
                    size: 60,
                  color: theme.secondaryHeaderColor,
                    )),
          Container(
            alignment: Alignment(0,0.7),
            child: Text(username,
                style: TextStyle( color: theme.backgroundColor,shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: theme.colorScheme.primary,
                    offset: Offset(5.0, 5.0),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: theme.colorScheme.primary,
                    offset: Offset(-5.0, 5.0),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color:theme.colorScheme.primary,
                    offset: Offset(5.0, -5.0),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color:theme.colorScheme.primary,
                    offset: Offset(-5.0, -5.0),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
