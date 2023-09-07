import 'package:shared_preferences/shared_preferences.dart';

import '../model/sign/sign_in.dart';

void tokensIntert(TokenDetails tokenDetails) async {
  if (tokenDetails.accessToken != null && tokenDetails.refreshToken != null) {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('accesstoken', tokenDetails.accessToken!);
    preferences.setString('refreshtoken', tokenDetails.refreshToken!);
    preferences.setInt('atexp', tokenDetails.atExpires!);
    preferences.setInt('rtexp', tokenDetails.rtExpires!);
  }
}

void tokensDel() async {
  final preferences = await SharedPreferences.getInstance();

  preferences.remove('accesstoken');
  preferences.remove('refreshtoken');
  preferences.remove('atexp');
  preferences.remove('rtexp');
  preferences.remove('type');
}

Future<TokenDetails> tokenGet() async {
  final preferences = await SharedPreferences.getInstance();
  TokenDetails token = TokenDetails();
  token.accessToken = preferences.getString('accesstoken');
  token.refreshToken = preferences.getString('refreshtoken');
  token.atExpires = preferences.getInt('atexp');
  token.rtExpires = preferences.getInt('rtexp');
  return token;
}

void phoneAndPassIntert(UserSignIn sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('phone', sign.phone!);
  preferences.setString('pass', sign.pass!);
}

Future<UserSignIn> passGet() async {
  final preferences = await SharedPreferences.getInstance();
  UserSignIn sign = UserSignIn();

  sign.phone = preferences.getString('phone');
  sign.pass = preferences.getString('pass');

  return sign;
}
