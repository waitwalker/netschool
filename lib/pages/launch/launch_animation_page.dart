import 'dart:async';
import 'dart:convert';
import 'package:NetSchool/common/locale/locale_mamager.dart';
import 'package:NetSchool/common/redux/app_state.dart';
import 'package:NetSchool/common/theme/theme_manager.dart';
import 'package:NetSchool/pages/login/app_login_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

///
/// @Class: LaunchAnimationPage
/// @Description: 启动动画页
/// @author: lca
/// @Date: 2019-08-06
///
class LaunchAnimationPage extends StatefulWidget {
  @override
  _LaunchAnimationState createState() => _LaunchAnimationState();
}

class _LaunchAnimationState extends State<LaunchAnimationPage>
    with SingleTickerProviderStateMixin {
  int themeIndex = 0;
  int localeIndex = 0;

  AnimationController animationController;
  LottieComposition _composition;
  Animation<double> animation;

  startTime() async {
    var _duration = Duration(milliseconds: 1500);
    return Timer(_duration, navigationPage);
  }

  /// 读取本地缓存数据
  readLocalCacheData() async {
    Store<AppState> store = StoreProvider.of(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    /// 获取主题
    themeIndex = sharedPreferences.getInt("theme");
    if (themeIndex == null) {
      themeIndex = 0;
    }
    ThemeManager.pushTheme(store, themeIndex);

    /// 获取语言
    localeIndex = sharedPreferences.getInt("locale");

    if (localeIndex == null) {
      localeIndex = 0;
    }
    LocaleManager.changeLocale(store, localeIndex);
  }

  void navigationPage() async {
    await AppLoginManager.instance.autoLogin(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readLocalCacheData();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    loadAsset("resources/json/app.json");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return _buildPage(context, store);
    });
  }

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  Widget _buildPage(BuildContext context, Store<AppState> store) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    if (w / h < 9 / 16.0) {
      h = (16 / 9) * w;
    }
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: w,
              height: h,
              // color: Colors.red,
              child: Lottie(
                composition: _composition,
                size: Size(w, h),
                controller: animationController,
              ),
            ),
            Positioned(
              bottom: 58,
              child: Image.asset(
                  'static/images/img_Start_zhongxia_logo.png.png',
                  width: 183,
                  height: 43),
            )
          ],
        ));
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String,dynamic>>((String data)=>json.decode(data))
      .then((Map<String,dynamic> map) => LottieComposition.fromMap(map));
}
