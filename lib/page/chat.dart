import 'package:flutter/material.dart';
import 'package:message_app/page/friend.dart';

class MessageDetail {
  @required
  final FriendDetail friend;
  final String message;
  Container photoClipContainer;

  MessageDetail({this.message, this.friend});

  void initState() {
    photoClipContainer = friend.hasPhoto
        ? Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: friend.photoClip)))
        : Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: CircleAvatar(
                backgroundColor: Colors.purpleAccent,
                radius: 35,
                child: friend.icon));
  }
}

List<MessageDetail> loadMessage(FriendDetail myself,List<FriendDetail> friendDetail) {
  List<MessageDetail> list = [];
  if(myself.name!="123")
    return list;
  for (int i = 0; i < friendDetail.length; i++) {
    list.add(MessageDetail(
      friend: friendDetail.elementAt(i),
    ));
  }
  return list;
}

class ChatPage extends StatefulWidget {
  @required
  final FriendDetail friend;
  @required
  final FriendDetail myself;

  ChatPage({Key key, this.friend, this.myself}) : super(key: key);

  @override
  _ChatPage createState() => _ChatPage(friend, myself);
}

class _ChatPage extends State<ChatPage> {
  FriendDetail friend;
  FriendDetail myself;

  _ChatPage(FriendDetail _friend, FriendDetail _myself) {
    friend = _friend;
    myself = _myself;
  }

  final List<Widget> _messages = [];
  final TextEditingController _chatController = TextEditingController();

  void _submitText(String text) {
    if (text == '') return;
    _chatController.clear(); // 清空controller資料
    setState(() {
      _messages.insert(
          0,
          MessageBox(
            text: text,
            myself: myself,
            other: false,
          ));
      _messages.insert(0, MessageBox(text: text, other: true,
        friend: friend,));
    });
  }

  Widget build(BuildContext context) {
//    print("startBuild");
    return Scaffold(
        appBar: AppBar(title: Text(friend.name)),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true, // 加入reverse，讓它反轉
                  itemBuilder: (context, index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
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
    double clipSize=60;
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
