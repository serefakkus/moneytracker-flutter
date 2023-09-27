import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/database.dart';
import '../../helpers/login_web.dart';
import '../../main.dart';
import '../../model/sign/sign_in.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();

bool _isPressPass = false;

bool _isWaiting = false;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    _isPressPass = false;
    _isWaiting = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    if (_isWaiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: _Giris(setS, goHomePage),
    );
  }

  setS() {
    setState(() {});
  }

  goHomePage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      (route) => route.settings.name == '/',
    );
  }
}

class _Giris extends StatefulWidget {
  const _Giris(this.setS, this.goHomePage, {Key? key}) : super(key: key);
  final void Function() setS;
  final void Function() goHomePage;

  @override
  State<_Giris> createState() => _GirisState();
}

class _GirisState extends State<_Giris> {
  @override
  void initState() {
    super.initState();
    _getpass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: loginBackGroundColor,
        child: ListView(
          primary: false,
          children: [
            const _LogoSign(),
            const _TelefonNumarasi(),
            const _PhoneInput(),
            const _Sifre(),
            const _SifreInput(),
            _GirisButon(widget.setS, widget.goHomePage),
            Container(
              margin: EdgeInsets.only(top: _height / 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _KayitButon(),
                  _GirissizButon(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getpass() async {
    UserSignIn sign = await passGet();

    if (sign.pass != null &&
        sign.pass != '' &&
        sign.phone != null &&
        sign.phone != '') {
      _phonecontroller.text = sign.phone!;
      _passcontroller.text = sign.pass!;

      setState(() {});
    }
  }
}

sendLogin(BuildContext context, Function setS, Function goHomePage) async {
  if (_phonecontroller.text.isEmpty) {
    EasyLoading.showInfo("TELEFON NUMARASI BOŞ OLAMAZ",
        duration: const Duration(seconds: 5));
    return;
  }

  String phoneStr = _phonecontroller.text;

  if (phoneStr[0] != "5") {
    EasyLoading.showInfo("TELEFON NUMARASINI '0' OLMADAN GİRİNİZ",
        duration: const Duration(seconds: 5));
    return;
  }

  if (phoneStr.length != 10) {
    EasyLoading.showInfo("TELEFON NUMARASI 10 HANE OLMALIDIR",
        duration: const Duration(seconds: 5));
    return;
  }

  int? phone = int.tryParse(phoneStr);

  if (phone == null) {
    EasyLoading.showInfo("TELEFON NUMARASI SAYILARDAN OLUŞMALIDIR",
        duration: const Duration(seconds: 5));
    return;
  }

  if (_passcontroller.text.isEmpty) {
    EasyLoading.showInfo("ŞİFRE BOŞ OLAMAZ",
        duration: const Duration(seconds: 5));
    return;
  }

  if (_passcontroller.text.length < 6) {
    EasyLoading.showInfo("ŞİFRE EN AZ 6 KARAKTERDEN OLUŞMALIDIR",
        duration: const Duration(seconds: 5));
    return;
  }

  if (_phonecontroller.text.isNotEmpty && _passcontroller.text.isNotEmpty) {
    _isWaiting = true;
    setS();
    UserSignIn sign = UserSignIn();
    sign.phone = _phonecontroller.text;
    sign.pass = _passcontroller.text;
    String? auth = await signInSend(sign);

    if (auth == null) {
      _isWaiting = false;
      setS();
      return;
    }

    _isWaiting = false;

    // ignore: use_build_context_synchronously
    goHomePage();
  }
}

class _LogoSign extends StatelessWidget {
  const _LogoSign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _width / 20,
          ),
          child: SizedBox(
            width: _width,
            height: _height / 3,
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: _BackButton(),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 50, left: _width / 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.white38,
          radius: (_width / 18),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: (_width / 10),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _TelefonNumarasi extends StatelessWidget {
  const _TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 30),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Text(
          'TELEFON NUMARASI',
          style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          filled: true,
          fillColor: Color(0XFFA6D7E7),
        ),
        controller: _phonecontroller,
        cursorColor: Colors.black,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class _Sifre extends StatelessWidget {
  const _Sifre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Text(
          'ŞİFRE',
          style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _SifreInput extends StatefulWidget {
  const _SifreInput({Key? key}) : super(key: key);

  @override
  State<_SifreInput> createState() => _SifreInputState();
}

class _SifreInputState extends State<_SifreInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 40), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _iconColor(_isPressPass),
            ),
            onPressed: () {
              _isPressPass = !_isPressPass;
              setState(() {});
            },
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          filled: true,
          fillColor: const Color(0XFFA6D7E7),
        ),
        cursorColor: Colors.black,
        controller: _passcontroller,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_isPressPass,
        obscuringCharacter: '*',
      ),
    );
  }
}

Color _iconColor(bool isPressed) {
  if (isPressed) {
    return Colors.green;
  }
  return Colors.blue;
}

class _GirisButon extends StatefulWidget {
  const _GirisButon(this.setS, this.goHomePage, {Key? key}) : super(key: key);
  final void Function() setS;
  final void Function() goHomePage;

  @override
  State<_GirisButon> createState() => _GirisButonState();
}

class _GirisButonState extends State<_GirisButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 10), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text('GİRİŞ YAP', style: TextStyle(fontSize: _width / 20)),
        onPressed: () {
          sendLogin(context, widget.setS, widget.goHomePage);
        },
      ),
    );
  }
}

class _KayitButon extends StatelessWidget {
  const _KayitButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        Navigator.pushNamed(context, '/SignUpPage'),
      },
      child: Text(
        "KAYIT OL",
        style: GoogleFonts.farro(
          fontSize: _width / 25,
          fontWeight: FontWeight.normal,
          color: Colors.green,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _GirissizButon extends StatelessWidget {
  const _GirissizButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          {Navigator.pushNamed(context, '/LoginCodePage', arguments: 'seref')},
      child: Text(
        "ŞİFREMİ UNUTTUM",
        style: GoogleFonts.farro(
          fontSize: _width / 25,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
