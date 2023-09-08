import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:moneytracker/helpers/database.dart';

import 'pages/login/fist_page.dart';

Color loginBackGroundColor = Colors.white;
Color homeBackGroundColor = Colors.white;

void main() {
  runApp(const FirstPage());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //tokensDel();
}
