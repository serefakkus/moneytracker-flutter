// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moneytracker/helpers/sorting.dart';
import 'package:moneytracker/model/get/his.dart';
import 'package:moneytracker/model/get/incom.dart';
import 'package:moneytracker/model/get/outgo.dart';
import 'package:moneytracker/model/request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/response.dart';
import '../model/sign/sign_in.dart';
import 'database.dart';
import 'send.dart';
import 'url.dart';

List<PayInfo?>? infoList;

Future<void> getHome(BuildContext context) async {
  TokenDetails token = await tokenGet();
  if (token.accessToken == null) {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      '/WelcomePage',
      (route) => route.settings.name == '/',
    );
    return;
  }

  await _homeSend(token.accessToken!, 0, context);

  return;
}

Future<void> _homeSend(String auth, int startDay, BuildContext context) async {
  Req req = Req();
  req.reqType = "his";
  req.auth = auth;

  String json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(getHisUrl);

  dynamic inJson = await sendData(json, channel);

  if (inJson == null) {
    return;
  }

  Resp resp = Resp.fromJson(inJson);
  if (resp.status == true) {
    dynamic jsonobject = jsonDecode(resp.message!);
    RespUserHis his = RespUserHis.fromJson(jsonobject);
    List<PayInfo>? payInfoList = incomInfoSorting(his);

    if (payInfoList == null) {
      return;
    }

    infoList = [];

    for (var i = 0; i < payInfoList.length; i++) {
      infoList!.add(null);
    }

    _getAllInfo(auth, startDay, payInfoList);

    return;
  }

  if (resp.httpCode == 401) {
    await EasyLoading.showError("LÜTFEN TEKRAR GİRİŞ YAPINIZ");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/WelcomePage',
      (route) => route.settings.name == '/',
    );

    return;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));

  return;
}

void _getAllInfo(String auth, int startDay, List<PayInfo> payInfoList) {
  int counter = 0;
  int limit = 11;

  int oldDay = 0;

  int start = 0;

  if (startDay != 0) {
    for (var i = 0; i < payInfoList.length; i++) {
      if (payInfoList[i].day == startDay) {
        start = i;
        limit = start + 11;
      }
    }
  }

  for (var i = start; i < payInfoList.length; i++) {
    PayInfo e = payInfoList[i];

    if (counter == limit && oldDay == e.day) {
      counter--;
    }

    if (counter == limit && oldDay != e.day) {
      break;
    }

    if (e.type == null) {
      continue;
    }

    if (e.type == true) {
      _infoSendIncom(e, auth, i);
    } else if (e.type == false) {
      _infoSendOutgo(e, auth, i);
    }

    counter++;

    oldDay = e.day!;
  }
}

Future<void> _infoSendIncom(PayInfo pay, String auth, int ind) async {
  IncomReq incomReq = IncomReq(incomingId: pay.id);

  String json = jsonEncode(incomReq.toJson());

  List<int> list = json.codeUnits;

  Uint8List bytes = Uint8List.fromList(list);

  String tip = "in";

  Req reqGet = Req(auth: auth, message: bytes, reqType: tip);

  json = jsonEncode(reqGet.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(getInUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  IncomingInfo incomingInfo = IncomingInfo();

  if (resp.status != true) {
    pay.incom = incomingInfo;
    infoList![ind] = pay;
    return;
  }

  dynamic jsonobject = jsonDecode(resp.message!);

  incomingInfo = IncomingInfo.fromJson(jsonobject);

  pay.incom = incomingInfo;

  infoList![ind] = pay;

  return;
}

Future<void> _infoSendOutgo(PayInfo pay, String auth, int ind) async {
  OutgoReq outgoReq = OutgoReq(outgoingId: pay.id);

  String json = jsonEncode(outgoReq.toJson());

  List<int> list = json.codeUnits;

  Uint8List bytes = Uint8List.fromList(list);

  String tip = "out";

  Req reqGet = Req(auth: auth, message: bytes, reqType: tip);

  json = jsonEncode(reqGet.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(getOutUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  OutgoingInfo outgoingInfo = OutgoingInfo();

  if (resp.status != true) {
    pay.outgo = outgoingInfo;
    infoList![ind] = pay;
    return;
  }

  dynamic jsonobject = jsonDecode(resp.message!);

  outgoingInfo = OutgoingInfo.fromJson(jsonobject);

  pay.outgo = outgoingInfo;

  pay.outgo = outgoingInfo;

  infoList![ind] = pay;

  return;
}
