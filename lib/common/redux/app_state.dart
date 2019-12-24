import 'package:flutter/material.dart';
import 'package:flutter_dayuwen/common/redux/runtime_data_reducer.dart';
import 'package:flutter_dayuwen/common/redux/theme_data_reducer.dart';
import 'package:flutter_dayuwen/common/runtime_data/runtime_data.dart';
import 'package:flutter_dayuwen/common/theme/mtt_theme.dart';

import 'local_reducer.dart';

/**
  *
  * @ClassName:      AppState类
  * @Description:    类作用描述
  * @Author:         作者名：liuchuanan
  * @CreateDate:     2019-07-05 09:46
  * @UpdateUser:     更新者：
  * @UpdateDate:     2019-07-05 09:46
  * @UpdateRemark:   更新说明：
  * @Version:        1.0
 */
class AppState {
  MTTTheme theme;
  Locale locale;
  Locale platformLocale;
  RuntimeData runtimeData;
  AppState({this.theme,this.locale,this.runtimeData});
}

/**
 * @method  创建Reducer
 * @description 描述一下方法的作用
 * @date: 2019-07-05 09:47
 * @author: liuca
 * @param
 * @return
 */
AppState appReducer(AppState state, action) {
  return AppState(
    theme: ThemeDataReducer(state.theme, action),
    locale: LocaleReducer(state.locale, action),
    runtimeData: RuntimeDataReducer(state.runtimeData, action),
  );
}

