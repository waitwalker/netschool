import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dayuwen/common/color/color.dart';
import 'package:flutter_dayuwen/common/redux/app_state.dart';
import 'package:flutter_dayuwen/pages/login/app_login_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

///
/// @name SelectIdentityPage
/// @description 选择身份页面
/// @author lca
/// @date 2019-11-21
///
class SelectIdentityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectIdentityState();
  }
}

class _SelectIdentityState extends State<SelectIdentityPage> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 30,top: 100),
                  child: Text("欢迎加入龙之门大语文",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w500),),
                ),
              ),

              Container(
                child: Expanded(
                  child: ListView.builder(itemBuilder: _itemBuilder,itemCount: 2,),),
              ),
            ],
          ),
        )
      );
    });
  }

  ///
  /// @name dataSource
  /// @description 数据源
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-21
  ///
  List<Map> dataSource = [
    {
      "title":"我是学生",
      "icon":"lib/resources/images/student_avatar.png",
      "color":ETTColor.student_select_identity_color,
    },
    {
      "title":"我是老师",
      "icon":"lib/resources/images/teacher_avatar.png",
      "color":ETTColor.teacher_select_identity_color,
    },
  ];

  ///
  /// @name _itemBuilder
  /// @description 卡片
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-21
  ///
  Widget _itemBuilder(BuildContext context, int index) {
    Map map = dataSource[index];
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return AppLoginPage(index: index + 1,);
        }));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25,right: 25),
        child: Column(
          children: <Widget>[
            Container(height: 30,),
            Container(
              decoration: BoxDecoration(
                color: map["color"],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20,bottom: 5,top: 5),
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(map["icon"]),
                          )
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 60),
                    child: Text(map["title"],style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}