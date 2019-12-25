import 'package:flutter/material.dart';

class HomeSecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _HomeSecondState();
  }
}

class _HomeSecondState extends State<HomeSecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页2"),
      ),
      body: Container(
        child: RaisedButton(child: Icon(Icons.delete),onPressed: (){},),
      ),
    );


  }
}