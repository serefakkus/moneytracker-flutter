import 'incom.dart';

class OutgoingInfo {
  String? regularId;
  String? category;
  String? emoji;
  String? not;
  double? amount;
  String? time;
  String? date;
  FromUser? to;

  OutgoingInfo({
    this.regularId,
    this.category,
    this.emoji,
    this.not,
    this.amount,
    this.time,
    this.date,
    this.to,
  });

  OutgoingInfo.fromJson(Map<String, dynamic> json) {
    regularId = json["RegularId"];
    category = json["Category"];
    emoji = json["Emoji"];
    not = json["Not"];
    amount = json["Amount"];
    time = json["Time"];
    date = json["Date"];
    if (json["To"] != null) {
      to = FromUser.fromJson(json["To"]);
    }
  }
}

class OutgoReq {
  String? userId;
  String? outgoingId;

  OutgoReq({
    this.userId,
    this.outgoingId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["UserId"] = userId;
    data["OutgoingId"] = outgoingId;
    return data;
  }
}
