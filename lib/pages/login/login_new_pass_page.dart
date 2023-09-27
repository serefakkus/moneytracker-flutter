import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/login_web.dart';
import '../../main.dart';
import '../../model/sign/sign_up.dart';

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _isWaiting = false;

class LoginNewPassPage extends StatefulWidget {
  const LoginNewPassPage({Key? key}) : super(key: key);

  @override
  State<LoginNewPassPage> createState() => _LoginNewPassPageState();
}

class _LoginNewPassPageState extends State<LoginNewPassPage> {
  @override
  void initState() {
    _isWaiting = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    SmsCode smsCode = ModalRoute.of(context)!.settings.arguments as SmsCode;

    if (_isWaiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      color: loginBackGroundColor,
      child: ListView(
        children: [
          const _LogoSign(),
          const Center(child: _Pass()),
          const _PassInput(),
          const Center(child: _NewPass()),
          const _NewPassInput(),
          _SendPassButton(smsCode, setS, goHomePage),
        ],
      ),
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

_sendPass(BuildContext context, SmsCode smsCode, Function setS,
    Function goHomePage) async {
  if (_passcontroller.text.length < 6) {
    EasyLoading.showToast("ŞİFRE EN AZ 6 HANELİ OLMALIDIR!");
    return;
  }

  if (_passcontroller.text == _newpasscontroller.text) {
    UserSingUp singUp = UserSingUp(
      pass: _passcontroller.text,
      phone: smsCode.phone,
      code: smsCode.code,
    );
    _isWaiting = true;
    setS();
    bool isOk = await refPassSend(singUp);
    _isWaiting = false;
    if (isOk) {
      goHomePage();
      return;
    }
    setS();
  } else {
    EasyLoading.showToast('GİRDİĞİNİZ ŞİFRELER\n UYUŞMUYOR');
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

class _Pass extends StatelessWidget {
  const _Pass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 12),
      child: Text(
        'YENİ ŞİFRE',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _PassInput extends StatefulWidget {
  const _PassInput({Key? key}) : super(key: key);

  @override
  State<_PassInput> createState() => _PassInputState();
}

class _PassInputState extends State<_PassInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
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
          controller: _passcontroller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_isPressPass,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}

bool _isPressPass = false;
bool _isPressPass2 = false;

Color _iconColor(bool isPressed) {
  if (isPressed) {
    return Colors.green;
  }
  return Colors.blue;
}

class _NewPass extends StatelessWidget {
  const _NewPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'TEKRAR YENİ ŞİFRE',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _NewPassInput extends StatefulWidget {
  const _NewPassInput({Key? key}) : super(key: key);

  @override
  State<_NewPassInput> createState() => _NewPassInputState();
}

class _NewPassInputState extends State<_NewPassInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 25), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _iconColor(_isPressPass2),
              ),
              onPressed: () {
                _isPressPass2 = !_isPressPass2;
                setState(() {});
              },
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: const Color(0XFFA6D7E7),
          ),
          controller: _newpasscontroller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_isPressPass,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _SendPassButton extends StatefulWidget {
  _SendPassButton(this.smsCode, this.setS, this.goHomePage, {Key? key})
      : super(key: key);
  SmsCode smsCode = SmsCode();
  Function setS;
  Function goHomePage;

  @override
  State<_SendPassButton> createState() => _SendPassButtonState();
}

class _SendPassButtonState extends State<_SendPassButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: _height / 8, right: _width / 10, left: _width / 10),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size(_width / 1.2, _height / 12.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ŞİFRE OLUŞTUR',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          _sendPass(context, widget.smsCode, widget.setS, widget.goHomePage);
        },
      ),
    );
  }
}
