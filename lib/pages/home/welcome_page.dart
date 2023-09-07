import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Scaffold(
      body: Container(
        color: loginBackGroundColor,
        child: ListView(
          primary: false,
          children: const [
            _Logo(),
            _GirisButon(),
            _KayitButon(),
            _GirissizButon(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Container(
      margin: EdgeInsets.only(
        top: _width / 5,
      ),
      child: SizedBox(
        width: _width,
        height: _height / 2,
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}

class _GirisButon extends StatefulWidget {
  const _GirisButon({Key? key}) : super(key: key);

  @override
  State<_GirisButon> createState() => _GirisButonState();
}

class _GirisButonState extends State<_GirisButon> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
      ),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 20,
            fixedSize: Size(_width * 0.8, _height / 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('GİRİŞ YAP'),
        onPressed: () {
          Navigator.pushNamed(context, '/LogInPage');
        },
      ),
    );
  }
}

class _KayitButon extends StatefulWidget {
  const _KayitButon({Key? key}) : super(key: key);

  @override
  State<_KayitButon> createState() => _KayitButonState();
}

class _KayitButonState extends State<_KayitButon> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            elevation: 20,
            fixedSize: Size(_width * 0.8, _height / 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('KAYIT OL'),
        onPressed: () {
          Navigator.pushNamed(context, '/SignUpPage');
        },
      ),
    );
  }
}

class _GirissizButon extends StatefulWidget {
  const _GirissizButon({Key? key}) : super(key: key);

  @override
  State<_GirissizButon> createState() => _GirissizButonState();
}

class _GirissizButonState extends State<_GirissizButon> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: TextButton(
        onPressed: () => {Navigator.pushNamed(context, '/LoginCodePage')},
        child: Text(
          "ŞİFREMİ UNUTTUM",
          style: GoogleFonts.farro(
            fontSize: _width / 25,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
