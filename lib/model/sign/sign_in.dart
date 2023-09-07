class TokenDetails {
  TokenDetails({
    this.accessToken,
    this.refreshToken,
    this.accessUuid,
    this.refreshUuid,
    this.atExpires,
    this.rtExpires,
  });

  String? accessToken;
  String? refreshToken;
  String? accessUuid;
  String? refreshUuid;
  int? atExpires;
  int? rtExpires;

  TokenDetails.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    refreshToken = json['RefreshToken'];
    accessUuid = json['AccessUuid'];
    refreshUuid = json['RefreshUuid'];
    atExpires = json['AtExpires'];
    rtExpires = json['RtExpires'];
  }
}

class Ip {
  Ip({
    this.ip,
    this.time,
  });

  String? ip;
  String? time;

  Ip.fromJson(Map<String, dynamic> json) {
    ip = json["Ip"];
    time = json["Time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Ip"] = ip;
    data["Time"] = time;
    return data;
  }
}

class UserSignIn {
  UserSignIn({
    this.phone,
    this.pass,
    this.ip,
  });

  String? phone;
  String? pass;
  Ip? ip;

  UserSignIn.fromJson(Map<String, dynamic> json) {
    phone = json["Phone"];
    pass = json["Pass"];
    if (json["Ip"] != null) {
      ip = Ip.fromJson(json["Ip"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Phone"] = phone;
    data["Pass"] = pass;
    if (ip != null) {
      data["Ip"] = ip!.toJson();
    }
    return data;
  }
}
