import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// @Method: appBar
/// @Parameter:
/// @ReturnType:
/// @Description: 系统appBar封装
/// @author: lca
/// @Date: 2019-08-01
///
Widget appBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    leading: GestureDetector(
      child: Icon(Icons.arrow_back_ios),
      onTap: (){
        Navigator.of(context).pop();
      },
    ),
  );
}