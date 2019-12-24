import 'package:flutter/material.dart';
import 'package:flutter_dayuwen/common/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// @name UserAgreementPage
/// @description 用户协议
/// @author lca
/// @date 2019-11-22
///
class UserAgreementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAgreementState();
  }
}

class _UserAgreementState extends State<UserAgreementPage> {
  WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      return Scaffold(
        appBar: AppBar(
          title: Text("用户协议"),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
        ),
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