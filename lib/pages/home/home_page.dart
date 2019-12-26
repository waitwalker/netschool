import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
      ),
      body: Container(
        child: RaisedButton(child: Icon(Icons.delete),onPressed: (){},),
      ),
    );

  }
}

class Entry {
  final String title;
  final List<Entry> children;
  Entry(this.title,[this.children = const<Entry>[]]);
}


class EntryItem extends StatelessWidget {

  final Entry entry;

  const EntryItem(this.entry);

  Widget _buildTitles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(title:  Text(root.title),);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}