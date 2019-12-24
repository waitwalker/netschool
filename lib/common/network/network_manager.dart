import 'dart:collection';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_dayuwen/common/config/config.dart';
import 'package:flutter_dayuwen/common/const/const.dart';
import 'package:flutter_dayuwen/pages/login/app_login_manager.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// @Class: NetworkManager
/// @Description: 网络请求管理类
/// @author: lca
/// @Date: 2019-08-01
///
class NetworkManager {

  static String _baseUrl;
  static const Accept_ContentType_JSON = "application/json";
  static const Accept_ContentType_Form = "application/x-www-form-urlencoded";
  static Map optionParameters = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  static setBaseUrl(String baseUrl){
    _baseUrl = baseUrl;
  }

  ///
  /// @Method: get
  /// @Parameter: url parameters
  /// @ReturnType: Future<ResponseData>
  /// @Description: get 方法
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static get(interface,parameters) async{
    return await fetch(interface, parameters, {"Accept": 'application/vnd.github.VERSION.full+json'}, Options(method: 'GET'));
  }

  ///
  /// @Method: post
  /// @Parameter: url parameters
  /// @ReturnType: Future<ResponseData>
  /// @Description: put 方法
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static post(interface,parameters,{FormData data}) async{
    return await fetch(interface, parameters, {"Accept": 'application/vnd.github.VERSION.full+json'}, Options(method: 'POST'),data: data);
  }

  ///
  /// @Method: delete
  /// @Parameter: url parameters
  /// @ReturnType: Future<ResponseData>
  /// @Description: delete 方法
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static delete(url,parameters) async{
    return await fetch(_baseUrl+url, parameters, null, Options(method: 'DELETE'));
  }

  ///
  /// @Method: put
  /// @Parameter: url parameters
  /// @ReturnType: Future<ResponseData>
  /// @Description: put 方法
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static put(url,parameters) async{
    return await fetch(_baseUrl+url, parameters, null, Options(method: "PUT", contentType: ContentType.text));
  }

  
  ///
  /// @Method: fetch
  /// @Parameter:
  /// @ReturnType:
  /// @Description:
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static fetch(interface, parameters, Map<String, String> header, Options option, {noTip = false, FormData data}) async {

    /// 没有网络
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return ResponseData(StatusCode.errorHandleFunction(StatusCode.Network_Error, "", noTip), false, StatusCode.Network_Error);
    }

    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }


    /// 授权码
    if (optionParameters["authorizationCode"] == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        optionParameters["authorizationCode"] = authorizationCode;
      }
    }

    headers["Authorization"] = optionParameters["authorizationCode"];
    headers["client"] = Platform.isIOS ? "iOS" : "android";


    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String phoneSysVersion;
    String appVersion;
    String platform;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneSysVersion = iosInfo.systemVersion;
      appVersion = packageInfo.version;
      platform = "2";
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneSysVersion = androidInfo.bootloader;
      appVersion = packageInfo.version;
      platform = "1";
    }

    headers["phoneSysVersion"] = phoneSysVersion;
    headers["appVersion"] = appVersion;
    headers["platform"] = platform;
    headers["x-token"] = token;
    headers["X-Parse-Application-Id"] = "4jXtTizndgVDum5Hjey3";
    headers["X-Parse-REST-API-Key"] = "X-Parse-REST-API-Key";
    headers["X-Parse-JavaScript-Key"] = "F1lbi2cKvzgIswP4BWNJ";


    /// 设置请求options
    if (option != null) {
      option.headers = headers;
    } else{
      /// 默认
      option = Options(method: "get");
      option.headers = headers;
    }

    /// 超时时间
    option.connectTimeout = 15000;

    Map<String,dynamic> tmpParameters = parameters;
    tmpParameters["time"] = NetworkAssistant.currentTimeMilliseconds().toString();
    String sign = NetworkAssistant.getSign(tmpParameters, interface);
    tmpParameters["sign"] = sign;
    String url = NetworkAssistant.getUrl(interface);


    Dio dio = Dio();

    /// 添加拦截器
    if (Config.DEBUG) {
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options){
            print("\n================== $interface 请求数据 ==========================");
            print("url = ${options.uri.toString()}");
            print("headers = ${options.headers}");
            print("parameterss = ${options.data}");
          },
          onResponse: (Response response){
            print("\n================== $interface 响应数据 ==========================");
            print("code = ${response.statusCode}");
            print("data = ${response.data}");
            print("\n");
          },
          onError: (DioError e){
            print("\n================== $interface 错误响应数据 ======================");
            print("type = ${e.type}");
            print("message = ${e.message}");
            print("stackTrace = ${e.stackTrace}");
            print("\n");
          }
      ));
    }

    /// 处理响应数据
    Response response;
    try {
      if (data == null) {
        response = await dio.request(url, data: tmpParameters, options: option);
        print("响应数据:$response");
      } else {
        response = await dio.request(url, data: data, options: option);
      }
    } on DioError catch (e) {

      /// 请求错误处理
      Response errorResponse;

      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: StatusCode.Network_Error_Unknown);
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = StatusCode.Network_Timeout;
      }

      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常 url: ' + url);
      }

      return ResponseData(StatusCode.errorHandleFunction(errorResponse.statusCode, e.message, noTip), false, errorResponse.statusCode);
    }

    /// 数据转换处理
    try {
      if (option.contentType != null && option.contentType.primaryType == "text") {
        return ResponseData(response.data, true, StatusCode.Success);
      } else {
        var responseJson = response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          optionParameters["authorizationCode"] = 'token ' + responseJson["token"];
          //await SpUtils.save(Config.TOKEN_KEY, optionParameters["authorizationCode"]);
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseData(response.data, true, StatusCode.Success, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return ResponseData(response.data, false, response.statusCode, headers: response.headers);
    }
    return ResponseData(StatusCode.errorHandleFunction(response.statusCode, "", noTip), false, response.statusCode);
  }

  ///清除授权
  static clearAuthorization() {
//    optionparameterss["authorizationCode"] = null;
//    SpUtils.remove(Config.TOKEN_KEY);
  }

  ///
  /// @Method: getAuthorization
  /// @Parameter:
  /// @ReturnType:
  /// @Description: 获取token
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static getAuthorization() async {
//    String token = await SpUtils.get(Config.TOKEN_KEY);
//    if (token == null) {
//      String basic = await SpUtils.get(Config.USER_BASIC_CODE);
//      if (basic == null) {
//        //提示输入账号密码
//      } else {
//        //通过 basic 去获取token，获取到设置，返回token
//        return "Basic $basic";
//      }
//    } else {
//      optionparameterss["authorizationCode"] = token;
//      return token;
//    }
  }

}

 ///
 /// @Class: ResponseData
 /// @Description: 响应结果类
 /// @author: lca
 /// @Date: 2019-08-01
 ///
class ResponseData {
  var data;
  bool result;
  int code;
  var headers;
  var model;
  ResponseData(this.data, this.result, this.code, {this.headers,this.model});
}

///
/// @Class: StatusCode
/// @Description: 响应状态码处理类
/// @author: lca
/// @Date: 2019-08-01
///
class StatusCode {

  /// 网络错误
  static const Network_Error = -601;

  /// 网络超时
  static const Network_Timeout = -602;

  /// 未知错误
  static const Network_Error_Unknown = -603;

  ///网络返回数据格式化一次
  static const Network_JSON_Exception = -3;

  /// 请求成功
  static const Success = 200;

  static final EventBus eventBus = new EventBus();

  static errorHandleFunction(code, message, noTip) {
    if(noTip) {
      return message;
    }
    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}

class HttpErrorEvent {
  final int code;
  final String message;
  HttpErrorEvent(this.code, this.message);
}


///
/// @name NetworkAssistant
/// @description 网络请求辅助类,生成签名,拼接参数等
/// @author lca
/// @date 2019-09-20
///
class NetworkAssistant {

  ///
  /// @name currentTimeMilliseconds
  /// @description 获取当前时间戳 毫秒级
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-09-20
  ///
  static int currentTimeMilliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///
  /// @name getSign
  /// @description 获取签名
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-09-20
  ///
  static String getSign(Map parameter, String interface) {
    List<String> allKeys = [];
    parameter.forEach((key,value){
      allKeys.add(key);
    });

    allKeys.sort((obj1,obj2){
      return obj1.compareTo(obj2);
    });
    
    List<String> pairs = [];
    
    allKeys.forEach((key){
      pairs.add("$key=${parameter[key]}");
    });

    String pairsString = pairs.join("&");
    String sign = interface + "&" + pairsString + "*ETT#HONER#2014*";
    String md5 = generateMd5(sign);
    Base64Codec base64 = Base64Codec();
    String signString = base64.encoder.convert(md5.codeUnits);
    signString = signString.replaceAll("=", "");
    print("sign:$signString");
    return signString;
  }

  ///
  /// @name generateMd5
  /// @description MD5 哈希
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-09-20
  ///
  static String generateMd5(String string) {
    var content = Utf8Encoder().convert(string);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  ///
  /// @name getUrl
  /// @description 获取请求url
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-09-20
  ///
  static String getUrl(String interface) {

    if (Config.DEBUG) {

      switch (interface) {
        case Const.interfaceConfig:
          return "https://api.yuwenclub.com/basic/appConfig";
          break;
        default:
          return AppLoginManager.instance.configModel.serverUrl.apiServer + interface;
          break;
      }
    } else {
      switch (interface) {
        case Const.loginInterface:
          return "http://i.im.etiantian.net/study-im-service-2.0/user/login.do";
          break;
        default:
          return "";
          break;
      }
    }

  }
}
