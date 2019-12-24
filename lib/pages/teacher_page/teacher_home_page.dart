import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dayuwen/common/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeacherHomeState();
  }
}

class _TeacherHomeState extends State<TeacherHomePage> {
  WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      return Scaffold(
        body: WebView(
          initialUrl: "https://m.yuwenclub.com/terms.html",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onPageFinished: (url){
            print("加载完成:$url");
          },
          navigationDelegate: (NavigationRequest request) {
            //对于需要拦截的操作 做判断
            if(request.url.startsWith("myapp://")) {
              print("即将打开 ${request.url}");
              //做拦截处理
              //pushto....
              return NavigationDecision.prevent;
            }

            //不需要拦截的操作
            return NavigationDecision.navigate;
          },
          javascriptChannels: <JavascriptChannel>[
            /// js 调用Flutter 只有postMessage或者拦截url
            JavascriptChannel(
                name: "message",
                onMessageReceived: (JavascriptMessage message) {
                  print("参数： ${message.message}");
                }
            ),
          ].toSet(),

        ),
      );
    });
  }
}