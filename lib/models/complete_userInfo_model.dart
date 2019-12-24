///
/// @name CompleteUserInfoModel
/// @description 完善用户信息
/// @author lca
/// @date 2019-11-27
///
class CompleteUserInfoModel {
  int code;
  Result result;

  CompleteUserInfoModel({this.code, this.result});

  CompleteUserInfoModel.fromJson(Map<String, dynamic> json) {
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
  String phone;
  String areaCode;
  String name;
  String grade;
  String genre;
  bool isAuth;
  int role;
  int score;
  String createdAt;
  String updatedAt;
  String objectId;

  Result(
      {this.phone,
        this.areaCode,
        this.name,
        this.grade,
        this.genre,
        this.isAuth,
        this.role,
        this.score,
        this.createdAt,
        this.updatedAt,
        this.objectId});

  Result.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    areaCode = json['areaCode'];
    name = json['name'];
    grade = json['grade'];
    genre = json['genre'];
    isAuth = json['isAuth'];
    role = json['role'];
    score = json['score'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    objectId = json['objectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['areaCode'] = this.areaCode;
    data['name'] = this.name;
    data['grade'] = this.grade;
    data['genre'] = this.genre;
    data['isAuth'] = this.isAuth;
    data['role'] = this.role;
    data['score'] = this.score;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['objectId'] = this.objectId;
    return data;
  }
}