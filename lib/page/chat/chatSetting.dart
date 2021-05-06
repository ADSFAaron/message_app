import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSetting extends StatefulWidget {
  final String docId;
  final String photoURL;
  final String roomName;
  final List member;

  ChatSetting(
      {@required this.docId,
      @required this.photoURL,
      @required this.roomName,
      @required this.member});

  _ChatSetting createState() => _ChatSetting(
      docId: docId, photoURL: photoURL, roomName: roomName, member: member);
}

class _ChatSetting extends State<ChatSetting> {
  final String docId;
  String photoURL;
  String roomName;
  List member;

  //TODO 未來問題 更改明子後這邊也得更改

  bool modifyName = false;
  final TextEditingController controller = TextEditingController();

  _ChatSetting(
      {@required this.docId,
      @required this.photoURL,
      @required this.roomName,
      @required this.member});

  @override
  Widget build(BuildContext context) {
    controller.text = roomName;
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat Setting"),
        ),
        body: Stack(children: [
          Container(
            color: Theme.of(context).primaryColor,
          ),
          ListView(
            children: [
              photoURL != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          image: DecorationImage(
                              image: NetworkImage(photoURL),
                              fit: BoxFit.cover)),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Text(
                          "no picture",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 5,
                              color: Theme.of(context).backgroundColor),
                        ),
                      ),
                    ),
              modifyName == false
                  ? Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              roomName,
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 35),
                            ),
                            IconButton(
                                icon: FaIcon(FontAwesomeIcons.pencilAlt),
                                onPressed: () {
                                  setState(() {
                                    modifyName = true;
                                  });
                                })
                          ]),
                    )
                  : Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextField(
                                controller: controller,
                              )),
                          IconButton(
                              icon: FaIcon(FontAwesomeIcons.check),
                              onPressed: () {
                                //TODO 更改當前葉面 所有member 的 chatroom ID 等等
                                changeRoomName();
                              })
                        ],
                      )),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  'member',
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor, fontSize: 20),
                ),
                alignment: Alignment.bottomCenter,
              ),
              Divider(
                  height: 4.0,
                  indent: 20.0,
                  endIndent: 20,
                  color: Colors.orangeAccent),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 20),
              )
              //TODO 放個 grid存放到底有些誰
            ],
          ),
        ]));
  }

  void changeRoomName() async {
    EasyLoading.show(status: 'loading...');
    String newName = controller.text;
    CollectionReference chatRoom =
        FirebaseFirestore.instance.collection('chatRoom');
    chatRoom.doc(docId).update({"roomName": newName});
    DocumentSnapshot data = await chatRoom.doc(docId).get();
    member = data.data()['member'];
    print("chatRoom change success");
    // print(member[0].runtimeType);
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    for (int i = 0; i < member.length; i++) {
      DocumentSnapshot userData = await user.doc(member[i]).get();
      List chatRoom = userData.data()['chatRoom'];
      int rom = chatRoom.indexWhere((element) {
        return (element['roomID'] == docId);
      });
      chatRoom[rom]['roomName'] = newName;
      user.doc(member[i]).update({"chatRoom": chatRoom});
    }
    print("user change success");
    EasyLoading.dismiss();
    setState(() {
      roomName = newName;
      modifyName = false;
    });
  }
}
