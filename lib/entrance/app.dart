import 'package:NetSchool/common/locale/localizations_delegate.dart';
import 'package:NetSchool/common/redux/app_state.dart';
import 'package:NetSchool/common/runtime_data/runtime_data.dart';
import 'package:NetSchool/common/theme/theme_manager.dart';
import 'package:NetSchool/entrance/bottom_tabbar_page.dart';
import 'package:NetSchool/pages/launch/launch_animation_page.dart';
import 'package:NetSchool/pages/placeholder/placeholder_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

///
/// @name App
/// @description app入口页面
/// @author liuca
/// @date 2019-12-24
///
class App extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      theme: ThemeManager.defaultTheme(),
      locale: Locale("zh","CH"),
      runtimeData: RuntimeData(homeScrollOffset: 0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context,store){
          return MaterialApp(
            debugShowCheckedModeBanner: false, ///去掉debug标签
            debugShowMaterialGrid: false,
            /// 设置国际化语言
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              MTTLocalizationsDelegate.delegate,
              ChineseCupertinoLocalizations.delegate, // 自定义的delegate
              DefaultCupertinoLocalizations.delegate, // 目前只包含英文
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale,Locale('zh', 'Hans'),],
            theme: store.state.theme.themeData,
            darkTheme: ThemeData.dark(),
            home: MTTLocalizations(child: LaunchAnimationPage(),),
            routes: <String,WidgetBuilder>{
              "launch_animation":(BuildContext context) => LaunchAnimationPage(),
              "bottom_tabbar":(BuildContext context)=> BottomTabBarController(),
            },
            onUnknownRoute: (RouteSettings setting) {
              String name = setting.name;
              print("onUnknownRoute:$name");
              return MaterialPageRoute(builder: (context){
                return PlaceholderPage();
              });
            },

          );
        },
      ),
    );
  }
}

class MTTLocalizations extends StatefulWidget {
  final Widget child;

  MTTLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<MTTLocalizations> createState() {
    return _LocalizationsState();
  }
}

class _LocalizationsState extends State<MTTLocalizations> {

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}