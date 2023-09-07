class Resp {
  Resp({
    this.status,
    this.reqId,
    this.httpCode,
    this.message,
  });

  bool? status;
  String? reqId;
  int? httpCode;
  String? message;

  Resp.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    reqId = json["ReqId"];
    httpCode = json["HttpCode"];
    if (json["Message"] != null) {
      message = json["Message"];
    }
  }
}
