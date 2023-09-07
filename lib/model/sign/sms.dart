class PhoneNo {
  PhoneNo({
    this.phone,
  });

  String? phone;

  PhoneNo.fromJson(Map<String, dynamic> json) {
    phone = json["Phone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Phone"] = phone;
    return data;
  }
}

class RespNewSms {
  RespNewSms({
    this.empty,
    this.timeOut,
  });

  bool? empty;
  String? timeOut;

  RespNewSms.fromJson(Map<String, dynamic> json) {
    empty = json["Empty"];
    timeOut = json["TimeOut"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Empty"] = empty;
    data["TimeOut"] = timeOut;
    return data;
  }
}
