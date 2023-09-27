// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moneytracker/model/get/cate.dart';
import 'package:moneytracker/model/reqs/req_cate.dart';
import 'package:moneytracker/model/request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/response.dart';
import '../model/sign/sign_in.dart';
import 'database.dart';
import 'send.dart';
import 'url.dart';

UserCategory userCategory = UserCategory();
UserRegularCategory userRegularCategory = UserRegularCategory();

Future<void> getCategory(BuildContext context) async {
  TokenDetails token = await tokenGet();
  if (token.accessToken == null) {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      '/WelcomePage',
      (route) => route.settings.name == '/',
    );
    return;
  }

  await _categorySend(token.accessToken!, 0, context);

  return;
}

Future<void> _categorySend(
    String auth, int startDay, BuildContext context) async {
  ReqCategory reqCategory = ReqCategory();
  reqCategory.categoryId = userCategory.id;
  reqCategory.fromId = userCategory.fromId;

  String catJson = jsonEncode(reqCategory.toJson());

  List<int> list = catJson.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  Req req = Req();
  req.reqType = "cat";
  req.auth = auth;
  req.message = bytes;

  String json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(getHisUrl);

  dynamic inJson = await sendData(json, channel);

  if (inJson == null) {
    return;
  }

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    dynamic jsonobject = jsonDecode(resp.message!);
    userCategory = UserCategory.fromJson(jsonobject);
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
