import 'package:flutter/material.dart';

class PersonDetailPage extends StatelessWidget{

  String _title;
  String _tag;

  PersonDetailPage( String title1,String tag1){
    _title=title1;
    _tag = tag1;
  }

  Widget build(BuildContext context) {
    print(_tag);
    return Hero(
      tag:_tag,
        child:Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Text("content"),
    ))
    ;
  }
}

class AddFriendPage extends StatelessWidget{
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("_title"),
      ),
      body: Text("content"),
    );
  }
}