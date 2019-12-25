import 'package:flutter/material.dart';

class BottomTabBarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _BottomTabBarControllerState();
  }
}

class _BottomTabBarControllerState extends State {

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[

        ],
      ),
    );
  }

}