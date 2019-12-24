
///
/// @Class: Config
/// @Description: 配置类
/// @author: lca
/// @Date: 2019-08-01
///
class Config {
  static const DEBUG = !bool.fromEnvironment("dart.vm.product");
}