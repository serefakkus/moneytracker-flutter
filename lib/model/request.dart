import 'dart:typed_data';

class Req {
  String? reqId;
  String? reqType;
  String? auth;
  Uint8List? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ReqId"] = reqId;
    data["ReqType"] = reqType;
    data["Auth"] = auth;
    data["Message"] = message;
    return data;
  }

  Req({
    this.reqId,
    this.reqType,
    this.auth,
    this.message,
  });
}
