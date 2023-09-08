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

bool _isSendedCode = false;
bool _isWaiting = false;

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Kayit(),
    );
  }
}

class _Kayit extends StatefulWidget {
  const _Kayit({Key? key}) : super(key: key);

  @override
  State<_Kayit> createState() => _KayitState();
}

class _KayitState extends State<_Kayit> {
  @override
  void initState() {
    _isWaiting = false;
    _isSendedCode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (!_isSendedCode) {
      return Container(
        color: loginBackGroundColor,
        child: ListView(
          primary: false,
          children: [
            const _LogoSign(),
            const _TelefonNumarasi(),
            Row(
              children: [const _PhoneInput(), _CodeSendButton(setS)],
            ),
            const _GirisButon(),
          ],
        ),
      );
    }
    return Container(
      color: loginBackGroundColor,
      child: ListView(
        primary: false,
        children: [
          Column(
            children: [
              const _LogoSign(),
              const _TelefonNumarasi(),
              Row(
                children: [const _PhoneInput(), _CodeSendButton(setS)],
              ),
              const _Code(),
              const _CodeInput(),
              _SignUpButton(setS),
              const _GirisButon(),
            ],
          ),
        ],
      ),
    );
  }

  void setS() {
    setState(() {});
  }
}

_sendCode(Function setS) async {
  if (_phonecontroller.text.isNotEmpty) {
    if (_phonecontroller.text.length != 10) {
      EasyLoading.showToast('Telefon numarası 10 hane olmalıdır!',
          duration: const Duration(seconds: 4));
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
      EasyLoading.showToast('Telefon numarası rakamlardan oluşmalıdır!',
          duration: const Duration(seconds: 4));
      return;
    }
    _isWaiting = true;
    setS();

    bool isOk = await newSmsSend(_phonecontroller.text);
    if (isOk) {
      _isSendedCode = true;
    }

    _isWaiting = false;
    setS();
  } else {
    EasyLoading.showToast('Telefon numarası giriniz!');
  }
}

_sendSignUp(BuildContext context, Function setS) async {
  /*
    _codeandphone[0] = _phonecontroller.text;
    _codeandphone[1] = _codecontroller.text;
    Navigator.pushNamed(context, '/NewPassPage', arguments: _codeandphone);
    return;
  }
  */

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
    bool isOk = await askCodeSend(smsCode);
    _isWaiting = false;
    if (isOk) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/NewPassPage', arguments: smsCode);
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
      margin: EdgeInsets.only(top: _height / 50, left: _width / 10),
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
        top: (_height / 30),
        left: (_width / 15),
      ),
      child: SizedBox(
        height: (_height / 15),
        width: (_width / 1.65),
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
            color: Colors.white),
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
          top: (_height / 25), right: (_width / 15), left: (_width / 15)),
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
      margin: EdgeInsets.only(top: (_height / 30), left: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size(
              (_width / 4),
              (_height / 15),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: const Text(
          'KOD\n GÖNDER',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          if (!_isSendedCode) {
            setState(() {
              _sendCode(widget.setS);
            });
            Future.delayed(const Duration(seconds: 60), () {
              _isSendedCode = false;
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
      margin: EdgeInsets.only(
        top: (_height / 6),
        right: (_width / 10),
        left: (_width / 10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text(
          'KAYIT OL',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: _width / 20),
        ),
        onPressed: () {
          _sendSignUp(context, widget.setS);
        },
      ),
    );
  }
}

class _GirisButon extends StatelessWidget {
  const _GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 80), top: (_height / 20)),
      child: TextButton(
        onPressed: () => {
          Navigator.pushNamed(context, '/GirisPage'),
        },
        child: Text(
          "GİRİŞ YAP",
          style: GoogleFonts.farro(
            fontSize: _width / 25,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
