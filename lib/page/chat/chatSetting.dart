import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final String photoURL;
  final String roomName;
  final List member;
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
                                modifyName=true;
                              });
                            })
                      ]),
                    )
                  : Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child:
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            suffixIcon:  IconButton(
                                icon: FaIcon(FontAwesomeIcons.check),
                                onPressed: (){
                                  //TODO 更改當前葉面 所有member 的 chatroom ID 等等
                                  changeRoomName();
                                  setState(() {
                                  modifyName = false;
                                });})
                          ),
                        ),
                    ),
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

  void changeRoomName(){

  }
}
