// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../route_generator.dart';
import '../../helpers/database.dart';
import '../../helpers/token.dart';
import '../../model/sign/sign_in.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      builder: EasyLoading.init(),
      onGenerateRoute: RouteGenerator.routeGenerator,
      home: const _Islogin(),
    );
  }
}

class _Islogin extends StatefulWidget {
  const _Islogin();

  @override
  State<_Islogin> createState() => _IsloginState();
}

class _IsloginState extends State<_Islogin> {
  @override
  Widget build(BuildContext context) {
    _isUserLogin(context, goHome, goWelcome);
    return const Center(child: CircularProgressIndicator());
  }

  goHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      (route) => route.settings.name == '/',
    );
  }

  goWelcome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/WelcomePage',
      (route) => route.settings.name == '/',
    );
  }
}

void _gettoken(
    BuildContext context, Function goHome, Function goWelcome) async {
  TokenDetails token = await tokenGet();
  if (token.accessToken == null || token.accessToken == '') {
    goWelcome();
    return;
  }

  var date = DateTime.fromMillisecondsSinceEpoch(token.atExpires! * 1000);
  var date2 = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);

  if (date.isAfter(DateTime.now())) {
    goHome();
    return;
  }

  if (date2.isAfter(DateTime.now())) {
    String? accessToken = await refToken(context);
    if (accessToken == null) {
      goWelcome();
      return;
    }

    goHome();
    return;
  }

  goWelcome();
}

void _isUserLogin(BuildContext cnt, Function goHome, Function goWelcome) {
  _gettoken(cnt, goHome, goWelcome);
}
