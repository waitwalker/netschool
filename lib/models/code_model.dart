
///
/// @name CodeModel
/// @description 验证码model添加
/// @author lca
/// @date 2019-11-28
///
class CodeModel {
  int code;
  String result = "";
  String message = "";

  CodeModel({this.code, this.result,this.message});

  CodeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result = json['result'] == null ? "" : json['result'];
    message = json['message'] == null ? "" : json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}