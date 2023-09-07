import 'package:moneytracker/model/get/outgo.dart';

class IncomingInfo {
  String? regularId;
  String? category;
  String? emoji;
  String? not;
  double? amount;
  String? time;
  String? date;
  FromUser? from;

  IncomingInfo({
    this.regularId,
    this.category,
    this.emoji,
    this.not,
    this.amount,
    this.time,
    this.date,
    this.from,
  });

  IncomingInfo.fromJson(Map<String, dynamic> json) {
    regularId = json["RegularId"];
    category = json["Category"];
    emoji = json["Emoji"];
    not = json["Not"];
    amount = json["Amount"];
    time = json["Time"];
    date = json["Date"];
    if (json["From"] != null) {
      from = FromUser.fromJson(json["From"]);
    }
  }
}

class FromUser {
  String? name;
  String? userId;

  FromUser({
    this.name,
    this.userId,
  });

  FromUser.fromJson(Map<String, dynamic> json) {
    name = json["Name"];
    userId = json["UserId"];
  }
}

class PayInfo {
  String? id;
  bool? type; //if true incom else outgo
  int? day;
  IncomingInfo? incom;
  OutgoingInfo? outgo;

  PayInfo({
    this.id,
    this.type,
    this.day,
    this.incom,
    this.outgo,
  });
}

class IncomReq {
  String? userId;
  String? incomingId;

  IncomReq({
    this.userId,
    this.incomingId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["UserId"] = userId;
    data["IncomingId"] = incomingId;
    return data;
  }
}
