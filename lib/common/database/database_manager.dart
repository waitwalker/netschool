import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 登录相关字段
final String kLoginTableName = "Login_Table"; ///登录表名称
final String kId = "_id"; /// id
final String kJid = "jid"; /// jid
final String kLoginType = "login_type"; ///登录类型
final String kAccount = "login_account"; ///登录账号
final String kPassword = "login_password"; ///登录密码
final String kLastLoginTime = "last_login_time"; ///上次登录时间
final String kCurrentLoginTime = "current_login_time"; ///本次登录时间
/// 其他字段待加








///
/// @name DataBaseManager
/// @description 本地持久化管理类
/// @author lca
/// @date 2019-10-28
///
class DataBaseManager {

  ///
  /// @name instance
  /// @description 单例模式
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  factory DataBaseManager() => _getInstance();
  static DataBaseManager get instance => DataBaseManager._getInstance();
  static DataBaseManager _instance;
  DataBaseManager._internal() {
    // 初始化
  }
  static DataBaseManager _getInstance() {
    if (_instance == null) {
      _instance = new DataBaseManager._internal();
    }
    return _instance;
  }

  static Database _database;

  ///
  /// @name database
  /// @description 数据库实例
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  ///
  /// @name initDatabase
  /// @description 初始化数据库
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,"flutter_aixue.db");
    var _db = await openDatabase(path,version: 1, onCreate: (Database db, int version) async {

      /// 创建登录表
      await db.execute('''
          CREATE TABLE $kLoginTableName (
            $kId INTEGER PRIMARY KEY, 
            $kJid TEXT, 
            $kLoginType INTEGER,
            $kAccount TEXT, 
            $kPassword TEXT,
            $kLastLoginTime TEXT, 
            $kCurrentLoginTime TEXT)
          ''');
    });
    return _db;
  }

  ///
  /// @name insertLoginModel
  /// @description 插入登录模型
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<int> insertLoginModel(LoginDatabaseModel model) async {
    Database db = await DataBaseManager.instance.database;
    var result = await db.insert(kLoginTableName, model.toMap());
    return result;
  }

  ///
  /// @name queryAllLoginModel
  /// @description 查询所有的登陆数据
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<List<LoginDatabaseModel>> queryAllLoginModel() async {
    Database db = await DataBaseManager.instance.database;
    List<Map> maps = await db.query(kLoginTableName,columns: [
      kId,
      kJid,
      kLoginType,
      kAccount,
      kPassword,
      kLastLoginTime,
      kCurrentLoginTime
    ]);

    if (maps == null || maps.length == 0) return null;

    List<LoginDatabaseModel> models = [];
    for(int i = 0; i < maps.length; i++) {
      models.add(LoginDatabaseModel.fromMap(maps[i]));
    }
    return models;
  }

  ///
  /// @name queryByJid
  /// @description 根据JID查找登录模型
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<LoginDatabaseModel> queryLoginModelByJid(String jid) async {
    Database db = await DataBaseManager.instance.database;
    List<Map> maps = await db.query(kLoginTableName,
        columns: [
          kId,
          kJid,
          kLoginType,
          kAccount,
          kPassword,
          kLastLoginTime,
          kCurrentLoginTime],
        where: '$kJid = ?', whereArgs: [jid]
      );
    if (maps.length > 0) return LoginDatabaseModel.fromMap(maps.first);
    return null;
  }

  ///
  /// @name deleteAllLoginModel
  /// @description 删除所有的登陆模型数据
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<int> deleteAllLoginModel() async {
    Database db = await DataBaseManager.instance.database;
    var result = db.delete(kLoginTableName,where: '$kId > 0');
    return result;
  }

  ///
  /// @name deleteLoginModelByJid
  /// @description 根据jid删除登录model
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<int> deleteLoginModelByJid(String jid) async {
    Database db = await DataBaseManager.instance.database;
    var result = await db.delete(kLoginTableName,where: '$kJid = ?',whereArgs: [jid]);
    return result;
  }

  ///
  /// @name updateLoginModel
  /// @description 更新登录model
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  Future<int> updateLoginModel(LoginDatabaseModel model) async {
    Database db = await DataBaseManager.instance.database;
    var result = await db.update(
      kLoginTableName,
      model.toMap(),
      where: '$kJid = ?',
      whereArgs: [model.jid],
    );
    return result;
  }

  ///
  /// @name closeDatabase
  /// @description 关闭数据库
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-10-28
  ///
  closeDatabase() async {
    Database db = await DataBaseManager.instance.database;
    await db.close();
  }
}

///
/// @name 登录数据库模型
/// @description 
/// @author lca
/// @date 2019-10-28
///
class LoginDatabaseModel {
  int id; /// id
  String jid; /// jid
  int loginType; /// 登录类型
  String account; /// 账号
  String password; /// 密码
  String lastLoginTime; /// 上次登录时间
  String currentLoginTime; /// 本次次登录时间

  /// 构造
  LoginDatabaseModel({
    this.jid,
    this.loginType,
    this.account,
    this.password,
    this.lastLoginTime,
    this.currentLoginTime
  });

  /// 转字典
  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      kJid:jid,
      kLoginType:loginType,
      kAccount:account,
      kPassword:password,
      kLastLoginTime:lastLoginTime,
      kCurrentLoginTime:currentLoginTime
    };
    if (kId != null) {
      map[kId] = id;
    }
    return map;
  }

  /// 转模型
  LoginDatabaseModel.fromMap(Map<String,dynamic> map) {
    id = map[kId];
    jid = map[kJid];
    loginType = map[kLoginType];
    account = map[kAccount];
    password = map[kPassword];
    lastLoginTime = map[kLastLoginTime];
    currentLoginTime = map[kCurrentLoginTime];
  }
}
