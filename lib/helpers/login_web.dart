import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/reqs/req_sign.dart';
import '../model/request.dart';
import '../model/response.dart';
import '../model/sign/sign_in.dart';
import '../model/sign/sign_up.dart';
import '../model/sign/sms.dart';
import 'database.dart';
import 'send.dart';
import 'time.dart';
import 'url.dart';

Future<bool> isTokenSend(String auth) async {
  Req req = Req();
  req.reqType = 'is_ok';
  req.auth = auth;

  String json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(newInUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    return true;
  }

  return false;
}

Future<String?> refTokenSend(String auth) async {
  Req req = Req();
  req.reqType = 'ref_tok';
  req.auth = auth;

  String json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(newInUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status != true) {
    return null;
  }

  if (resp.message == null) {
    return null;
  }

  dynamic jsonobject = jsonDecode(resp.message!);

  TokenDetails tokenDetails = TokenDetails.fromJson(jsonobject);

  tokensIntert(tokenDetails);

  return tokenDetails.accessToken;
}

Future<bool> newSmsSend(String phoneNo) async {
  if (phoneNo.length != 10) {
    EasyLoading.showInfo(
        "LÜTFEN TELEFON NUMARASINI 10 HANE OLACAK ŞEKİLDE GİRİN",
        duration: const Duration(seconds: 5));
  }
  PhoneNo phone = PhoneNo(phone: phoneNo);
  String json = jsonEncode(phone.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "new_sms";

  json = jsonEncode(req.toJson());
  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    EasyLoading.showSuccess("SMS GÖNDERİLDİ",
        duration: const Duration(seconds: 3));
    return true;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode != 425) {
    EasyLoading.showInfo(
        "BİR HATA OLUŞTU SORUN DEVAM EDERSE LÜTFEN BİZE ULAŞIN",
        duration: const Duration(seconds: 5));
  }

  if (resp.message == null) {
    return false;
  }

  dynamic jsonobject = jsonDecode(resp.message!);

  RespNewSms respSms = RespNewSms.fromJson(jsonobject);

  if (respSms.timeOut == null) {
    EasyLoading.showInfo("YENİ KOD GÖNDERMEK İÇİN LÜTFEN BEKLEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  DateTime timeOut = DateTime.parse(TimeSubMicro(respSms.timeOut!));

  Duration diff = timeOut.difference(DateTime.now());

  if (diff.inSeconds > 0) {
    EasyLoading.showInfo(
        "YENİ KOD GÖNDERMEK İÇİN ${diff.inSeconds} SANİYE BEKLEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("YENİ KOD GÖNDERMEK İÇİN LÜTFEN BEKLEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<bool> askCodeSend(SmsCode phone) async {
  String json = jsonEncode(phone.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "ask_sms";

  json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    return true;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 401) {
    EasyLoading.showInfo("KOD HATALI", duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 425) {
    EasyLoading.showInfo("KODUN SÜRESİ GEÇTİ LÜTFEN YENİDEN KOD GÖNDERİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<bool> signUpSend(UserSingUp signUp) async {
  String json = jsonEncode(signUp.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "signup";

  json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    _passInsert(signUp.phone, signUp.pass);
    if (resp.message == null) {
      EasyLoading.showInfo("KAYIT BAŞARILI LÜTFEN GİRİŞ YAPIN",
          duration: const Duration(seconds: 5));
    }

    dynamic jsonobject = jsonDecode(resp.message!);

    TokenDetails tokenDetails = TokenDetails.fromJson(jsonobject);

    tokensIntert(tokenDetails);

    return tokenDetails.accessToken != null;
  }

  if (resp.httpCode == 416) {
    EasyLoading.showInfo("GİRİLEN VERİLER KABUL EDİLMEDİ LÜTFEN TEKRAR DENEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 401) {
    EasyLoading.showInfo("KOD HATALI", duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 425) {
    EasyLoading.showInfo("KODUN SÜRESİ GEÇTİ LÜTFEN YENİDEN KOD GÖNDERİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<bool> refSmsSend(String phoneNo) async {
  if (phoneNo.length != 10) {
    EasyLoading.showInfo(
        "LÜTFEN TELEFON NUMARASINI 10 HANE OLACAK ŞEKİLDE GİRİN",
        duration: const Duration(seconds: 5));
  }
  PhoneNo phone = PhoneNo(phone: phoneNo);
  String json = jsonEncode(phone.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "new_sms_ref";

  json = jsonEncode(req.toJson());
  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    EasyLoading.showSuccess("SMS GÖNDERİLDİ",
        duration: const Duration(seconds: 3));
    return true;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode != 425) {
    EasyLoading.showInfo(
        "BİR HATA OLUŞTU SORUN DEVAM EDERSE LÜTFEN BİZE ULAŞIN",
        duration: const Duration(seconds: 5));
  }

  if (resp.message == null) {
    return false;
  }

  dynamic jsonobject = jsonDecode(resp.message!);

  RespNewSms respSms = RespNewSms.fromJson(jsonobject);

  if (respSms.timeOut == null) {
    EasyLoading.showInfo("YENİ KOD GÖNDERMEK İÇİN LÜTFEN BEKLEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  DateTime timeOut = DateTime.parse(TimeSubMicro(respSms.timeOut!));

  Duration diff = timeOut.difference(DateTime.now());

  if (diff.inSeconds > 0) {
    EasyLoading.showInfo(
        "YENİ KOD GÖNDERMEK İÇİN ${diff.inSeconds} SANİYE BEKLEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("YENİ KOD GÖNDERMEK İÇİN LÜTFEN BEKLEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<bool> askRefCodeSend(SmsCode phone) async {
  String json = jsonEncode(phone.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "ask_sms_ref";

  json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    return true;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 401) {
    EasyLoading.showInfo("KOD HATALI", duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 425) {
    EasyLoading.showInfo("KODUN SÜRESİ GEÇTİ LÜTFEN YENİDEN KOD GÖNDERİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<bool> refPassSend(UserSingUp signUp) async {
  String json = jsonEncode(signUp.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "ref_pass";

  json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    _passInsert(signUp.phone, signUp.pass);
    if (resp.message == null) {
      EasyLoading.showInfo("KAYIT BAŞARILI LÜTFEN GİRİŞ YAPIN",
          duration: const Duration(seconds: 5));
    }

    dynamic jsonobject = jsonDecode(resp.message!);

    TokenDetails tokenDetails = TokenDetails.fromJson(jsonobject);

    tokensIntert(tokenDetails);

    return tokenDetails.accessToken != null;
  }

  if (resp.httpCode == 416) {
    EasyLoading.showInfo("GİRİLEN VERİLER KABUL EDİLMEDİ LÜTFEN TEKRAR DENEYİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 401) {
    EasyLoading.showInfo("KOD HATALI", duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 425) {
    EasyLoading.showInfo("KODUN SÜRESİ GEÇTİ LÜTFEN YENİDEN KOD GÖNDERİN",
        duration: const Duration(seconds: 5));
    return false;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return false;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));
  return false;
}

Future<String?> signInSend(UserSignIn signIn) async {
  String json = jsonEncode(signIn.toJson());

  List<int> list = json.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  ReqSign req = ReqSign();

  req.message = bytes;

  req.reqType = "login";

  json = jsonEncode(req.toJson());

  WebSocketChannel channel = IOWebSocketChannel.connect(signUrl);

  dynamic inJson = await sendData(json, channel);

  Resp resp = Resp.fromJson(inJson);

  if (resp.status == true) {
    _passInsert(signIn.phone, signIn.pass);
    if (resp.message == null) {
      EasyLoading.showInfo("KAYIT BAŞARILI LÜTFEN GİRİŞ YAPIN",
          duration: const Duration(seconds: 5));
      return null;
    }

    dynamic jsonobject = jsonDecode(resp.message!);

    TokenDetails tokenDetails = TokenDetails.fromJson(jsonobject);

    tokensIntert(tokenDetails);

    return tokenDetails.accessToken;
  }

  if (resp.httpCode == 416) {
    EasyLoading.showInfo("GİRİLEN VERİLER KABUL EDİLMEDİ LÜTFEN TEKRAR DENEYİN",
        duration: const Duration(seconds: 5));
    return null;
  }

  if (resp.httpCode == 401) {
    EasyLoading.showInfo("KOD HATALI", duration: const Duration(seconds: 5));
    return null;
  }

  if (resp.httpCode == 425) {
    EasyLoading.showInfo("KODUN SÜRESİ GEÇTİ LÜTFEN YENİDEN KOD GÖNDERİN",
        duration: const Duration(seconds: 5));
    return null;
  }

  if (resp.httpCode == 208) {
    EasyLoading.showInfo("NUMARA ZATEN KAYITLI",
        duration: const Duration(seconds: 5));
    return null;
  }

  EasyLoading.showInfo("BİR HATA OLUŞTU LÜTFEN DAHA SONRA TEKRAR DENEYİN",
      duration: const Duration(seconds: 5));
  return null;
}

void _passInsert(String? phone, String? pass) {
  UserSignIn signIn = UserSignIn(pass: pass, phone: phone);
  phoneAndPassIntert(signIn);
}
