import 'package:flutter/material.dart';

class chatPage extends StatelessWidget {

  String _title;

  chatPage( String title1){
    _title=title1;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Text("content"),
    );
  }
}
