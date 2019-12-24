import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dayuwen/common/redux/app_state.dart';
import 'package:flutter_dayuwen/pages/login/app_login_manager.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';


class StudentHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudentHomeState();
  }
}

class _StudentHomeState extends State<StudentHomePage> {


  FlutterWebviewPlugin webviewPlugin = FlutterWebviewPlugin();
  IjkMediaController audioController = IjkMediaController();
  String currentAbserveMethod;
  Timer countDownTimer;
  double totalDuration;
  double currentPosition;
  int count = 1;


  ///
  /// @name _startCountDownFunction
  /// @description 倒计时
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-25
  ///
  _startCountDownFunction(double current, double total) {
    countDownTimer?.cancel();
    countDownTimer = null;
    countDownTimer = Timer.periodic(new Duration(seconds: 1), (t){
      Random random = Random();
      List data = ["addObserverAVPlayerTimeWithCurrentTime"];

      String dataStr = jsonEncode(data);
      String json = jsonEncode({
        "method":"_hasJavascriptMethod",
        "callbackId":random.nextInt(100),
        "data":dataStr
      });

      print("json:$json");
      webviewPlugin.evalJavascript("window._handleMessageFromNative($json)");
    });
  }

  ///
  /// @name _cancelCountDownTimer
  /// @description 取消倒计时
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-11-26
  ///
  _cancelCountDownTimer() {
    countDownTimer.cancel();
    countDownTimer = null;
  }

  @override
  void initState() {

    /// 监听url地址变化
    webviewPlugin.onUrlChanged.listen((String url){
      print("当前Webview地址:$url");
    });

    /// 监听页面状态改变
    webviewPlugin.onStateChanged.listen((WebViewStateChanged stateChanged){
      print("页面状态改变:${stateChanged.type}");
    });

    /// 监听Webview滚动
    webviewPlugin.onScrollYChanged.listen((double offsetY) {
      print("Y滚动距离:$offsetY");
    });

    webviewPlugin.onScrollXChanged.listen((double offsetX) {
      print("X滚动距离:$offsetX");
    });

    /// js 调用 flutter方法
    webviewPlugin.onJavascriptCalled.listen((Map parameter){
      print("onJavascriptCalled:$parameter");
      if (parameter != null) {
        _handleJSCall(parameter);
      }
    });

    /// 监听播放状态
    audioController.videoInfoStream.listen((VideoInfo info){
      print("当前播放状态:$info");
      bool isPlaying = info.isPlaying;
      /// 本地音频播放结束
      if (isPlaying == false) {
        ///NSString * json=[JSBUtil objToJsonString:@{@"method":info.method,@"callbackId":info.id,
        ///                                           @"data":[JSBUtil objToJsonString: info.args]}];
        ///[self evaluateJavaScript:[NSString stringWithFormat:@"window._handleMessageFromNative(%@)",json]
        ///completionHandler:nil];
        Random random = Random();
        List data = [];
        
        String dataStr = jsonEncode(data);
        String json = jsonEncode({
          "method":currentAbserveMethod,
          "callbackId":random.nextInt(100),
          "data":dataStr
        });

        print("json:$json");
        webviewPlugin.evalJavascript("window._handleMessageFromNative($json)");

      }

    });

    /// 监听播放状态
    audioController.ijkStatusStream.listen((IjkStatus ijkStatus){

      /// 当前播放状态
      print("当前状态:$ijkStatus");
      VideoInfo videoInfo = audioController.videoInfo;

      if (ijkStatus == IjkStatus.prepared) {

      } else if (ijkStatus == IjkStatus.playing) {
        if (count == 1) {
          Random random = Random();
          List data = ["startPlayingNetworkMusic"];

          String dataStr = jsonEncode(data);
          String json = jsonEncode({
            "method":"_hasJavascriptMethod",
            "callbackId":random.nextInt(100),
            "data":dataStr
          });

          print("json:$json");
          webviewPlugin.evalJavascript("window._handleMessageFromNative($json)");
          _startCountDownFunction(videoInfo.currentPosition,videoInfo.duration);
          count = count + 1;
        }

      } else if (ijkStatus == IjkStatus.complete) {
        count = 1;
        _cancelCountDownTimer();
      }

    });


    super.initState();
  }

  ///
  /// @name _handleJSCall
  /// @description 处理js调用flutter
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-12-03
  ///
  _handleJSCall(Map parameter) {
    String method = parameter['method'];
    Map argument = jsonDecode(parameter['argument']);

    print("argument:$argument");

    /// 返回的参数
    /// {method: AV.playAVPlayMusicWithParmas, argument: {"data":{"type":"localmp3","resouceUrl":"readrule","abserveMethod":"addObserverAVPlayerFinished"}}}
    /// {method: AV.playAVPlayMusicWithParmas, argument: {"data":{"type":"netWork","resouceUrl":"http://cdn.yu-wen.com/course/audio/S1-S111-1.mp3","abserveMethod":"addObserverAVPlayerFinished","isRequirement":"1"}}}

    if (method != null && method == "AV.playAVPlayMusicWithParmas") {
      if (argument != null) {
        Map data = argument["data"];
        print("data:$data");
        if (data != null) {
          String type = data["type"];
          String resouceUrl = data["resouceUrl"].toString();
          currentAbserveMethod = data["abserveMethod"].toString();
          if (type != null && type == "localmp3") {
            if (resouceUrl != null) {
              String path = "lib/resources/rules/$resouceUrl.mp3";
              Map <String,String> para = {
                "path":path,
                "resourceType":"local"
              };
              startPlayer(para);
            }
          } else if (type != null && type == "netWork") {
            if (resouceUrl != null) {
              Map <String,String> para = {
                "path":resouceUrl,
                "resourceType":"network"
              };
              count = 1;
              startPlayer(para);
            }
          }

        }
      }
    }

  }

  ///
  /// @name startPlayer
  /// @description 播放应用内资源
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-12-05
  ///
  void startPlayer(Map parameter) async{
    String resourceType = parameter["resourceType"];
    String path = parameter["path"];
    if (resourceType == "local") {
      await audioController.setAssetDataSource(path,autoPlay: true);
    } else if (resourceType == "network") {
      await audioController.setNetworkDataSource(path,autoPlay: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: WebviewScaffold(
          cookies: [
            {'k': 'token', 'v': AppLoginManager.instance.loginModel.token},
            {'k': 'identity', 'v': "${AppLoginManager.instance.loginModel.userType}"},
            {'k': 'platform', 'v': "2"},
          ],
          userAgent: "|appVersion=1.0.2",
          url: AppLoginManager.instance.configModel.h5Url.studentUrl,

        ),
    );
  }

  @override
  void dispose() {
    /// 释放
    webviewPlugin.close();
    audioController.dispose();
    super.dispose();
  }
}
