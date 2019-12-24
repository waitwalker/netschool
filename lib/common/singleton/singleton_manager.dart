

import 'package:flutter_dayuwen/models/login_model.dart';

///
/// @Class: 单例管理类
/// @Description: 
/// @author: lca
/// @Date: 2019-08-30
///
class SingletonManager {


  /// 登录model
  LoginModel loginModel;





  /// 类调用实例
  static SingletonManager get sharedInstance => _getInstance();

  /// 构造方法
  factory SingletonManager() => _getInstance();
  static SingletonManager _sharedInstance;

  SingletonManager._internal() {
    print("初始化相关");
  }
  static SingletonManager _getInstance() {
    if (_sharedInstance == null) {
      _sharedInstance = SingletonManager._internal();
    }
    return _sharedInstance;
  }
}
