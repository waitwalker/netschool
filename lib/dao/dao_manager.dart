import 'dart:convert';
import 'package:flutter_dayuwen/common/const/const.dart';
import 'package:flutter_dayuwen/common/network/network_manager.dart';
import 'package:flutter_dayuwen/models/code_model.dart';
import 'package:flutter_dayuwen/models/complete_userInfo_model.dart';
import 'package:flutter_dayuwen/models/interface_config_mode.dart';
import 'package:flutter_dayuwen/models/login_model.dart';
import 'package:flutter_dayuwen/pages/login/app_login_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// @name DaoManager
/// @description Dao 管理类
/// @author lca
/// @date 2019-10-09
///
class DaoManager {

  ///
  /// @Method: loginFetch
  /// @Parameter:
  /// @ReturnType:
  /// @Description: 获取登录接口数据
  /// @author: lca
  /// @Date: 2019-09-02
  ///
  static Future <ResponseData> loginFetch(Map<String,dynamic> parameters) async {
    var response = await NetworkManager.post(Const.loginInterface, parameters);
    if (response.result) {
      Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
      print("response.data:${response.data}");

      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var loginModel = LoginModel.fromJson(resultMap);
        response.model = loginModel;
        AppLoginManager.instance.loginModel = loginModel;
      } else {
        var loginModel = LoginModel.fromJson(response.data);
        response.model = loginModel;
        AppLoginManager.instance.loginModel = loginModel;
      }

      return response;
    } else {
      throw Exception("登录接口请求失败");
    }
  }

  ///
  /// @Method: interfaceConfigFetch
  /// @Parameter:
  /// @ReturnType:
  /// @Description: 获取配置
  /// @author: lca
  /// @Date: 2019-11-26
  ///
  static Future <ResponseData> interfaceConfigFetch(Map<String,dynamic> parameters) async {
    var response = await NetworkManager.get(Const.interfaceConfig, parameters);
    if (response.result) {
      Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
      print("response.data:${response.data}");
      if (response.data is String) {
        String jsonString = response.data;

        var resultMap = json.decode(jsonString);
        var model = InterfaceConfigModel.fromJson(resultMap);
        response.model = model;
      } else {
        var model = InterfaceConfigModel.fromJson(response.data);
        response.model = model;
      }
      return response;
    } else {
      throw Exception("获取接口配置请求失败");
    }
  }

  ///
  /// @name codeFetch
  /// @description 获取验证码
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-27
  ///
  static Future <ResponseData> codeFetch(Map<String,dynamic> parameters) async {
    var response = await NetworkManager.post(Const.codeInterface, parameters);
    if (response.result) {
      Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
      print("response.data:${response.data}");
      if (response.data is String) {
        String jsonString = response.data;

        var resultMap = json.decode(jsonString);
        var model = CodeModel.fromJson(resultMap);
        response.model = model;
      } else {
        var model = CodeModel.fromJson(response.data);
        response.model = model;
      }
      return response;
    } else {
      throw Exception("获取接口配置请求失败");
    }
  }

  ///
  /// @name codeFetch
  /// @description 获取验证码
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-27
  ///
  static Future <ResponseData> completeFetch(Map<String,dynamic> parameters) async {
    var response = await NetworkManager.post(Const.completeUserInfoInterface, parameters);
    if (response.result) {
      Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
      print("response.data:${response.data}");
      if (response.data is String) {
        String jsonString = response.data;

        var resultMap = json.decode(jsonString);
        var model = CompleteUserInfoModel.fromJson(resultMap);
        response.model = model;
      } else {
        var model = CompleteUserInfoModel.fromJson(response.data);
        response.model = model;
      }
      AppLoginManager.instance.loginModel.userInfo.name = response.model.result.name;
      AppLoginManager.instance.loginModel.userInfo.grade = response.model.result.grade;
      AppLoginManager.instance.loginModel.userInfo.updatedAt = response.model.result.updatedAt;
      return response;
    } else {
      throw Exception("获取接口配置请求失败");
    }
  }

  ///
  /// @Method: userInfoFetch
  /// @Parameter:
  /// @ReturnType:
  /// @Description: 获取用户信息
  /// @author: lca
  /// @Date: 2019-11-28
  ///
  static Future <ResponseData> userInfoFetch(Map<String,dynamic> parameters) async {
    var response = await NetworkManager.get(Const.userInfoInterface, parameters);
    if (response.result) {
      Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
      print("response.data:${response.data}");

      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var loginModel = LoginModel.fromJson(resultMap);
        response.model = loginModel;
        AppLoginManager.instance.loginModel = loginModel;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        AppLoginManager.instance.loginModel.token = preferences.get("token");
      } else {
        var loginModel = LoginModel.fromJson(response.data);
        response.model = loginModel;
        AppLoginManager.instance.loginModel = loginModel;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        AppLoginManager.instance.loginModel.token = preferences.get("token");
      }
      return response;
    } else {
      throw Exception("登录接口请求失败");
    }
  }




}

