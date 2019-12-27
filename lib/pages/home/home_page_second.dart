import 'package:NetSchool/pages/home/second_page.dart';
import 'package:flutter/material.dart';

class HomeSecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeSecondState();
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
        child: RaisedButton(child: Icon(Icons.delete),onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
        },),
      ),
    );


  }
}