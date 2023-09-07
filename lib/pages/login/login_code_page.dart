import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/login_web.dart';
import '../../main.dart';
import '../../model/sign/sign_up.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _codecontroller = TextEditingController();

bool _isSendenCode = false;
bool _isWaiting = false;

class LoginCodePage extends StatelessWidget {
  const LoginCodePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return const Scaffold(
      body: _LoginCode(),
    );
  }
}

class _LoginCode extends StatefulWidget {
  const _LoginCode({Key? key}) : super(key: key);

  @override
  State<_LoginCode> createState() => _LoginCodeState();
}

class _LoginCodeState extends State<_LoginCode> {
  @override
  void initState() {
    _isWaiting = false;
    _isSendenCode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!_isSendenCode) {
      return Container(
        color: loginBackGroundColor,
        child: ListView(
          children: [
            Column(
              children: [
                const _LogoSign(),
                const _TelefonNumarasi(),
                Row(
                  children: [
                    const Flexible(child: _PhoneInput()),
                    _CodeSendButton(setS)
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      color: loginBackGroundColor,
      child: ListView(
        children: [
          Column(
            children: [
              const _LogoSign(),
              const _TelefonNumarasi(),
              Row(
                children: [
                  const Flexible(child: _PhoneInput()),
                  _CodeSendButton(setS)
                ],
              ),
              const _Code(),
              const _CodeInput(),
              _SignUpButton(setS),
            ],
          ),
        ],
      ),
    );
  }

  setS() {
    setState(() {});
  }
}

_sendCodeGiris(BuildContext context, Function setS) async {
  if (_phonecontroller.text.isEmpty) {
    EasyLoading.showError("Lütfen 10 haneli telefon numarasını giriniz",
        duration: const Duration(seconds: 5));
    return;
  }

  if (_phonecontroller.text.length != 10) {
    EasyLoading.showError(
        "Lütfen telefon numarasını 10 hane olacak şekilde giriniz",
        duration: const Duration(seconds: 5));
    return;
  }

  String phoneStr = _phonecontroller.text;
  if (phoneStr[0] != "5") {
    EasyLoading.showError("Lütfen geçerli bir numara giriniz",
        duration: const Duration(seconds: 5));
    return;
  }

  int? phoneInt = int.tryParse(phoneStr);

  if (phoneInt == null) {
    EasyLoading.showError("Telefon numarası rakamlardan oluşmalı",
        duration: const Duration(seconds: 5));
    return;
  }

  _isWaiting = true;
  setS();

  bool isOk = await refSmsSend(phoneStr);
  _isWaiting = false;
  if (isOk) {
    _isSendenCode = true;
  }
  setS();
}

sendCodePass(BuildContext context, Function setS) async {
  if (_phonecontroller.text.isNotEmpty || _codecontroller.text.isNotEmpty) {
    if (_phonecontroller.text.length != 10) {
      EasyLoading.showToast('Telefon numarası 10 hane olmalıdır!',
          duration: const Duration(seconds: 4));
      return;
    }
    var sayi = int.tryParse(_phonecontroller.text);
    if (sayi == null) {
      EasyLoading.showToast('Telefon numarası rakamlardan oluşmalıdır!',
          duration: const Duration(seconds: 4));
      return;
    }
    var codesayi = int.tryParse(_codecontroller.text);
    if (codesayi == null) {
      EasyLoading.showToast('Kod rakamlardan oluşmalıdır!',
          duration: const Duration(seconds: 4));
      return;
    }
    SmsCode smsCode =
        SmsCode(phone: _phonecontroller.text, code: _codecontroller.text);
    _isWaiting = true;
    setS();
    bool isOk = await askRefCodeSend(smsCode);
    _isWaiting = false;
    if (isOk) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/LoginNewPassPage', arguments: smsCode);
      return;
    }
    setS();
  } else {
    EasyLoading.showToast('Tüm alanları doldurunuz!');
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
      margin: EdgeInsets.only(
        top: (_height / 30),
      ),
      child: Text(
        'TELEFON NUMARASI',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
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
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _phonecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'KOD',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _CodeInput extends StatelessWidget {
  const _CodeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _codecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class _CodeSendButton extends StatefulWidget {
  const _CodeSendButton(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<_CodeSendButton> createState() => _CodeSendButtonState();
}

class _CodeSendButtonState extends State<_CodeSendButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 30), right: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 10,
          fixedSize: Size((_width / 4), (_height / 15)),
        ),
        child: const Text(
          'KOD\n GÖNDER',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          if (!_isSendenCode) {
            setState(() {
              _sendCodeGiris(context, widget.setS);
            });
            Future.delayed(const Duration(seconds: 60), () {
              _isSendenCode = false;
              setState(() {});
            });
            return;
          }

          EasyLoading.showError(
              "Yeni kod göndermek için lütfen 1 dakikanın dolmasını bekleyin",
              duration: const Duration(seconds: 5));
        },
      ),
    );
  }
}

class _SignUpButton extends StatefulWidget {
  const _SignUpButton(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<_SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<_SignUpButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 10, left: _width / 25),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ONAYLA',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            sendCodePass(context, widget.setS);
          });
        },
      ),
    );
  }
}
