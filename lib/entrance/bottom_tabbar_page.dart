import 'package:NetSchool/pages/home/home_page.dart';
import 'package:NetSchool/pages/home/home_page_second.dart';
import 'package:flutter/material.dart';

class BottomTabBarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _BottomTabBarControllerState();
  }
}

class _BottomTabBarControllerState extends State<BottomTabBarController> {

  final PageController _controller = PageController(initialPage: 0);
  int _currentIndex = 0;
  final Color _unselectedColor = Colors.grey;
  final Color _selectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[
          HomePage(),
          HomeSecondPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _controller.jumpToPage(index);
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _unselectedColor,),
            activeIcon: Icon(Icons.home,color: _selectedColor,),
            title: Text("我的课程",style: TextStyle(color: _currentIndex == 0 ? _selectedColor : _unselectedColor),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: _unselectedColor,),
            activeIcon: Icon(Icons.person,color: _selectedColor,),
            title: Text("个人中心",style: TextStyle(color: _currentIndex == 0 ? _selectedColor : _unselectedColor),),
          ),
        ],
      ),
    );
  }

}