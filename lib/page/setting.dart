import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget{

  _SettingPage createState()=> _SettingPage();
}

class _SettingPage extends State<SettingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting'),),
      body: ListView(
        children: [
          ListTile(title: Text("風格"),),
        ],
      )
    );
  }
}