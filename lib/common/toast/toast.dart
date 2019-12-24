
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// @name ETTToast
/// @description 显示toast
/// @author lca
/// @date 2019-11-28
///
class ETTToast {

  ///
  /// @name toast
  /// @description 弹出toast
  /// @parameters message 消息
  /// @return
  /// @author lca
  /// @date 2019-11-28
  ///
  static show(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}








