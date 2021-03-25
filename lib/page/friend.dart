import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReturnFValue {
  final FriendDetail friend;
  final String str;

  ReturnFValue({this.friend, this.str});
}

class FriendDetail {
  final AssetImage photoClip;
  final bool hasPhoto;
  final String name;
  final Icon icon;

  FriendDetail({this.name, this.photoClip, this.hasPhoto, this.icon})
      : assert(hasPhoto == false || icon == null, "沒圖片要有icon"),
        assert(hasPhoto == true || photoClip == null, "有圖片要給圖片");
}

List<FriendDetail> loadFriend() {
  List<FriendDetail> list = [];
  for (int i = 0; i < 21; i++) {
    String str;
    if (i == 1 || i == 4 || i == 7 || i == 11) {
      AssetImage con = AssetImage('images/person/$i.jpg');
      if (i == 1)
        str = "琦玉";
      else if (i == 4)
        str = "五條悟";
      else if (i == 7)
        str = "派大星";
      else
        str = "艾主席";
      list.add(FriendDetail(name: str, hasPhoto: true, photoClip: con));
    } else {
      Icon icon = Icon(
        Icons.person,
        size: 60,
      );
      int j=55+i;
      str = "Person$j";
      list.add(FriendDetail(name: str, hasPhoto: false, icon: icon));
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
                        child: friend.hasPhoto? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: friend.photoClip))):
                        Container(alignment: Alignment.center, child: friend.icon)
                    ))),
            Container(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Hero(
                  tag: ntag,
                  child: Material(
                      type: MaterialType.transparency,
                      child: Text(friend.name,
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
                              ])))),
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
  AddFriendPage({Key key}) : super(key: key);

  _AddFriendPage createState() => _AddFriendPage();
}

class _AddFriendPage extends State<AddFriendPage> {
//  _AddFriendPage();
  final TextEditingController _chatController = new TextEditingController();

  List<Widget> addFriendOutline = [];

  void _submitText(String text) {
    addFriendOutline.clear();
    setState(() {
      if (text == "") {
        addFriendOutline.add(Text(
          "請輸入後再搜尋",
          style: TextStyle(fontSize: 40),
        ));
      } else if (text == '123') {
        Container photo = Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
              // color: Colors.redAccent,
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('images/uglyGuy.jpg'))),
        );
//        CircleAvatar photo = CircleAvatar(
//          radius: 1,
//          child: ClipOval(child:Image.asset('images/7.jpg')),
//        );
        Text name = Text(
          "uglyGuy",
          style: TextStyle(fontSize: 50),
        );
        ElevatedButton addB = ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              padding: MaterialStateProperty.all((EdgeInsets.all(5))),
            ),
            onPressed: () {
              Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "還沒製作",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            },
            child: Text("添加好友"));
        addFriendOutline.add(photo);
        addFriendOutline.add(Container(
          height: 10,
        ));
        addFriendOutline.add(name);
        addFriendOutline.add(Container(
          height: 5,
        ));
        addFriendOutline.add(addB);
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
