import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dayuwen/common/database/database_manager.dart';
import 'package:flutter_dayuwen/common/network/network_manager.dart';
import 'package:flutter_dayuwen/common/toast/toast.dart';
import 'package:flutter_dayuwen/dao/dao_manager.dart';
import 'package:flutter_dayuwen/models/interface_config_mode.dart';
import 'package:flutter_dayuwen/models/login_model.dart';
import 'package:package_info/package_info.dart';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


///
/// @name AppLoginManager
/// @description 登录管理
/// @author lca
/// @date 2019-10-25
///
class AppLoginManager {

  ///
  /// @name instance
  /// @description 单例模式
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  factory AppLoginManager() => _getInstance();
  static AppLoginManager get instance => AppLoginManager._getInstance();
  static AppLoginManager _instance;
  AppLoginManager._internal() {
    // 初始化
  }
  static AppLoginManager _getInstance() {
    if (_instance == null) {
      _instance = new AppLoginManager._internal();
    }
    return _instance;
  }


  /// 配置model
  Result configModel;

  /// 登录model
  LoginModel loginModel;

  ///
  /// @name _showLoading
  /// @description 显示加载圈
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-29
  ///
  showLoading(BuildContext context) {
    showDialog(context: context,builder: (context) {
      return Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  ///
  /// @name _hideLoading
  /// @description 隐藏加载圈
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-26
  ///
  hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  ///
  /// @name autoLogin
  /// @description 自动登录
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-31
  ///
  autoLogin(BuildContext context) async {
    Map<String,dynamic> map = {
      "imgPrefixUrl":"http://cdn.yuwenclub.com/",
      "server_url":{
        "apiServer":"https://api.yuwenclub.com"
      },
      "musicTimeout":"5",
      "xianshengTimeout":"30",
      "h5_url":{
        "teacherUrl" : "https://app-t.yuwenclub.com/#/",
        "studentUrl" : "https://app.yuwenclub.com",
        "userAgreementUrl" : "https://m.yuwenclub.com/terms.html",
      },
    };

    /// 显示加载圈
    showLoading(context);

    /// 获取配置
    ResponseData responseData = await DaoManager.interfaceConfigFetch({});
    hideLoading(context);
    if (responseData != null && responseData.model != null) {
      if (responseData.model.code == 200) {
        AppLoginManager.instance.configModel = responseData.model.result;
      } else {
        AppLoginManager.instance.configModel = Result.fromJson(map);
      }
    } else {
      AppLoginManager.instance.configModel = Result.fromJson(map);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");

    /// 根据token有无判断是否可以自定登录
    if (token != null) {
      showLoading(context);
      ResponseData responseData = await DaoManager.userInfoFetch({},);
      /// 结果回来后隐藏加载圈
      hideLoading(context);
      if (responseData != null && responseData.model != null) {
        String message = responseData.model.message;
        AppLoginManager.instance.loginModel.userType = AppLoginManager.instance.loginModel.userInfo.role;
        if (responseData.model.code == 200) {
          SharedPreferences preference = await SharedPreferences.getInstance();
          preference.setString("token", AppLoginManager.instance.loginModel.token);
          if (responseData.model.userInfo.name == null || responseData.model.userInfo.name.length == 0) {
            Navigator.pushNamedAndRemoveUntil(context, "/complete_info", (Route<dynamic> route) => false);
          } else {
            AppLoginManager.instance.loginModel.userType == 1 ?
            Navigator.pushNamedAndRemoveUntil(context, "/student_home", (Route<dynamic> route) => false) :
            Navigator.pushNamedAndRemoveUntil(context, "/teacher_home", (Route<dynamic> route) => false);
          }
        } else if (responseData.model.code == 142) {
          /// 参数校验失败
          print("登录接口:参数校验失败");
        }  else if (responseData.model.code == 404) {
          /// 用户不存在
          if (message != null || message.length != 0) {
            ETTToast.show(message + ":${responseData.model.code}");
          } else {
            ETTToast.show("用户不存在:${responseData.model.code}");
          }
        } else if (responseData.model.code == 500) {
          if (message != null || message.length != 0) {
            ETTToast.show(message + ":${responseData.model.code}");
          } else {
            ETTToast.show("有些问题,请稍后重试!${responseData.model.code}");
          }
        }
      } else {
        ETTToast.show("有些问题,请稍后重试! -501");
      }

    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/select_identity", (Route<dynamic> route) => false);
    }
  }



}