import 'package:flutter/foundation.dart';

class ReqSign {
  ReqSign({
    this.reqId,
    this.reqType,
    this.message,
  });

  String? reqId;
  String? reqType;
  Uint8List? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ReqId"] = reqId;
    data["ReqType"] = reqType;
    data["Message"] = message;
    return data;
  }
}
