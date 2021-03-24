import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  final String title;

  chatPage({Key key, this.title}) : super(key: key);

  @override
  _chatPage createState() => _chatPage(title);
}

class _chatPage extends State<chatPage> {
  String _title;

  _chatPage(String title1) {
    _title = title1;
  }

  final List<Widget> _messages = [];
  final TextEditingController _chatController = new TextEditingController();

  void _submitText(String text) {
    if (text == '') return;
    _chatController.clear(); // 清空controller資料
    setState(() {
      _messages.insert(0, MessageBox(text: text, other: false));
      _messages.insert(0, MessageBox(text: text, other: true));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
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
    );
  }

  List<Widget> createChatLog(int index) {
    List<Widget> list = [];
    for (int i = 0; i < index; i++) {
      Container iw = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightBlueAccent,
        ),
        alignment: Alignment.center,
        //color: Colors.blue[200 + i % 4 * 100],
        margin: EdgeInsets.all(5.0),
        height: 50,
        width: 100,
        child: Text("123"),
      );
      list.add(iw);
    }
    return list;
  }
}

class MessageBox extends StatelessWidget {
  final String text;
  final bool other;

  MessageBox({Key key, this.text, this.other}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            other ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: other
            ? <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    radius: 17,
                    child: Icon(
                      Icons.person,
                      size: 30,
                    )),
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
                CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    radius: 17,
                    child: Icon(
                      Icons.person,
                      size: 30,
                    )),
              ],
      ),
    );
  }
}
