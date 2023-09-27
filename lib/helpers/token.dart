import 'package:flutter/material.dart';

import '../model/sign/sign_in.dart';
import 'database.dart';
import 'login_web.dart';

Future<String?> refToken(BuildContext context) async {
  TokenDetails token = await tokenGet();

  DateTime date = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);

  if (token.refreshToken == null || token.refreshToken == "") {
    return null;
  }

  if (date.isAfter(DateTime.now())) {
    String? newToken = await refTokenSend(token.refreshToken!);
    if (newToken == null) {
      return null;
    }

    bool ok = await isTokenSend(newToken);

    if (!ok) {
      return null;
    }

    return newToken;
  }

  return null;
}
