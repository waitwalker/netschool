import 'package:flutter/material.dart';

class PlaceholderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaceholderState();
  }
}

class _PlaceholderState extends State<PlaceholderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("占位页"),
    );
  }
}