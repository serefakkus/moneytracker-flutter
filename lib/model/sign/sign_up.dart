import 'sign_in.dart';

class UserSingUp {
  UserSingUp({
    this.phone,
    this.code,
    this.pass,
    this.ip,
  });

  String? phone;
  String? pass;
  String? code;
  Ip? ip;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Phone"] = phone;
    data["Pass"] = pass;
    data["Code"] = code;
    if (ip != null) {
      data["Ip"] = ip!.toJson();
    }
    return data;
  }
}

class SmsCode {
  SmsCode({
    this.phone,
    this.code,
  });

  String? phone;
  String? code;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Phone"] = phone;
    data["Code"] = code;
    return data;
  }
}
