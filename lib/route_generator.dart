import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moneytracker/pages/home/home_page.dart';
import 'package:moneytracker/pages/home/welcome_page.dart';
import 'package:moneytracker/pages/login/sign_in_page.dart';
import 'package:moneytracker/pages/login/sign_up_page.dart';
import 'package:moneytracker/pages/login/login_code_page.dart';
import 'package:moneytracker/pages/login/login_new_pass_page.dart';
import 'package:moneytracker/pages/login/new_pass_page.dart';

import 'pages/login/fist_page.dart';

class RouteGenerator {
  static Route<dynamic>? _rotaOlustur(Widget hedef, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
          settings: settings, builder: (context) => hedef);
    } else {
      return MaterialPageRoute(settings: settings, builder: (context) => hedef);
    }
  }

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/FirstPage':
        return _rotaOlustur(const FirstPage(), settings);

      case '/WelcomePage':
        return _rotaOlustur(const WelcomePage(), settings);

      case '/HomePage':
        return _rotaOlustur(const HomePage(), settings);

      case '/LogInPage':
        return _rotaOlustur(const SignInPage(), settings);

      case '/SignUpPage':
        return _rotaOlustur(const SignUpPage(), settings);

      case '/NewPassPage':
        return _rotaOlustur(const NewPassPage(), settings);

      case '/LoginCodePage':
        return _rotaOlustur(const LoginCodePage(), settings);

      case '/LoginNewPassPage':
        return _rotaOlustur(const LoginNewPassPage(), settings);

      default:
        return (MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('BİR HATA OLDU', style: TextStyle(color: Colors.red)),
            ),
          ),
        ));
    }
  }
}
