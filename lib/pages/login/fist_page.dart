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
  const _Islogin({Key? key}) : super(key: key);

  @override
  State<_Islogin> createState() => _IsloginState();
}

class _IsloginState extends State<_Islogin> {
  @override
  Widget build(BuildContext context) {
    _isUserLogin(context);
    return const Center(child: CircularProgressIndicator());
  }
}

void _gettoken(BuildContext context) async {
  TokenDetails token = await tokenGet();
  if (token.accessToken == null || token.accessToken == '') {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/WelcomePage',
      (route) => route.settings.name == '/',
    );
    return;
  }

  var date = DateTime.fromMillisecondsSinceEpoch(token.atExpires! * 1000);
  var date2 = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);

  if (date.isAfter(DateTime.now())) {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      (route) => route.settings.name == '/',
    );
    return;
  }

  if (date2.isAfter(DateTime.now())) {
    await refToken(context);
    return;
  }

  Navigator.pushNamedAndRemoveUntil(
    context,
    '/WelcomePage',
    (route) => route.settings.name == '/',
  );
}

void _isUserLogin(BuildContext cnt) {
  _gettoken(cnt);
}
