///
/// @name InterfaceConfigModel
/// @description 接口配置model
/// @author lca
/// @date 2019-11-26
///
class InterfaceConfigModel {
  int code;
  Result result;

  InterfaceConfigModel({this.code, this.result});

  InterfaceConfigModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String imgPrefixUrl;
  ServerUrl serverUrl;
  String musicTimeout;
  String xianshengTimeout;
  H5Url h5Url;

  Result(
      {this.imgPrefixUrl,
        this.serverUrl,
        this.musicTimeout,
        this.xianshengTimeout,
        this.h5Url});

  Result.fromJson(Map<String, dynamic> json) {
    imgPrefixUrl = json['imgPrefixUrl'];
    serverUrl = json['server_url'] != null
        ? new ServerUrl.fromJson(json['server_url'])
        : null;
    musicTimeout = json['musicTimeout'];
    xianshengTimeout = json['xianshengTimeout'];
    h5Url = json['h5_url'] != null ? new H5Url.fromJson(json['h5_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgPrefixUrl'] = this.imgPrefixUrl;
    if (this.serverUrl != null) {
      data['server_url'] = this.serverUrl.toJson();
    }
    data['musicTimeout'] = this.musicTimeout;
    data['xianshengTimeout'] = this.xianshengTimeout;
    if (this.h5Url != null) {
      data['h5_url'] = this.h5Url.toJson();
    }
    return data;
  }
}

class ServerUrl {
  String apiServer;

  ServerUrl({this.apiServer});

  ServerUrl.fromJson(Map<String, dynamic> json) {
    apiServer = json['apiServer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiServer'] = this.apiServer;
    return data;
  }
}

class H5Url {
  String teacherUrl;
  String studentUrl;
  String userAgreementUrl;

  H5Url({this.teacherUrl, this.studentUrl, this.userAgreementUrl});

  H5Url.fromJson(Map<String, dynamic> json) {
    teacherUrl = json['teacherUrl'];
    studentUrl = json['studentUrl'];
    userAgreementUrl = json['userAgreementUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacherUrl'] = this.teacherUrl;
    data['studentUrl'] = this.studentUrl;
    data['userAgreementUrl'] = this.userAgreementUrl;
    return data;
  }
}