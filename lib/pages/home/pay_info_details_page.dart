import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneytracker/main.dart';
import 'package:moneytracker/model/get/incom.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

PayInfo _payInfo = PayInfo();

class PayInfoDetailsPage extends StatefulWidget {
  const PayInfoDetailsPage({Key? key}) : super(key: key);

  @override
  State<PayInfoDetailsPage> createState() => _PayInfoDetailsPageState();
}

class _PayInfoDetailsPageState extends State<PayInfoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    _payInfo = ModalRoute.of(context)!.settings.arguments as PayInfo;

    return Scaffold(
      backgroundColor: homeBackGroundColor,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Header(),
          _Body(),
          _BottomBar(),
        ],
      ),
    );
  }
}

//-----------------------------------headers--------------------------

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: SizedBox(
        width: _width,
        height: _height / 7,
        child: Container(
          color: Colors.grey.shade300,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BackButton(),
              _TextColumn(),
              _EditButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextColumn extends StatelessWidget {
  const _TextColumn();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
        bottom: _height / 100,
      ),
      child: SizedBox(
        width: _width / 1.4,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _MoneyTrackerText(),
            _SloganText(),
          ],
        ),
      ),
    );
  }
}

class _MoneyTrackerText extends StatelessWidget {
  const _MoneyTrackerText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Money-tracker",
      style: TextStyle(
        fontSize: _height / 21,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SloganText extends StatelessWidget {
  const _SloganText();

  @override
  Widget build(BuildContext context) {
    return Text(
      '"PARANI KONTROL ALTINDA TUT ,HESABINI BİL"',
      style: TextStyle(
        fontSize: _height / 80,
        color: Colors.green.shade800,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 50,
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.pen,
            size: _width / 20,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 18,
      ),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: (_width / 10),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

//----------------------------------------header end----------------------

//--------------------------------------body------------------------------

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height * 0.7437,
      child: ListView(
        children: [
          const _TypeText(),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _CategoryText(),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _FromText(),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _NotText(),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _AmountText(),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _DateText(),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 20),
            child: const _AddedDateText(),
          ),
        ],
      ),
    );
  }
}

class _TypeText extends StatelessWidget {
  const _TypeText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = "GELİR";
      color = const Color(0xFF71C9FB);
    } else if (_payInfo.type == false) {
      text = "GİDER";
      color = const Color(0xffE174B6);
    }

    text = text.toUpperCase();

    return Column(
      children: [
        SizedBox(
          width: _width * 0.5,
          height: _height / 15,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(_width / 30)),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _width / 20,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class _CategoryText extends StatelessWidget {
  const _CategoryText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.category.toString();
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.category.toString();
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          "KATEGORİ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 10,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                ),
              )),
        ),
      ],
    );
  }
}

class _FromText extends StatelessWidget {
  const _FromText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    String baslik = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.from!.name.toString();
      baslik = "KİMDEN";
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.to!.name.toString();
      baslik = "KİME";
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          baslik,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 10,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                ),
              )),
        ),
      ],
    );
  }
}

class _NotText extends StatelessWidget {
  const _NotText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.not.toString();
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.not.toString();
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          "NOT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 7,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ],
    );
  }
}

class _AmountText extends StatelessWidget {
  const _AmountText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.amount.toString();
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.amount.toString();
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          "MİKTAR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 10,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                ),
              )),
        ),
      ],
    );
  }
}

class _DateText extends StatelessWidget {
  const _DateText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.date.toString();
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.date.toString();
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          "TARİH",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 10,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                ),
              )),
        ),
      ],
    );
  }
}

class _AddedDateText extends StatelessWidget {
  const _AddedDateText();

  @override
  Widget build(BuildContext context) {
    String text = "";
    Color color = Colors.white;

    if (_payInfo.type == true) {
      text = _payInfo.incom!.time.toString();
    } else if (_payInfo.type == false) {
      text = _payInfo.outgo!.time.toString();
    }

    text = text.toUpperCase();

    return Column(
      children: [
        Text(
          "EKLENME TARİHİ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width / 20,
          ),
        ),
        SizedBox(
          width: _width * 0.8,
          height: _height / 10,
          child: Card(
              color: color,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_width / 20),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: _width / 20),
                ),
              )),
        ),
      ],
    );
  }
}

//----------------------------------bottom bar--------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            elevation: 10,
            child: SizedBox(
              width: _width,
              height: _height / 30,
              child: Container(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: _HomeIconBottom(),
        ),
      ],
    );
  }
}

class _HomeIconBottom extends StatelessWidget {
  const _HomeIconBottom();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_width / 7)),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        radius: _width / 10,
        child: IconButton(
          isSelected: false,
          iconSize: _width / 7,
          icon: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/HomePage",
              (route) => route.settings.name == '/',
            );
          },
        ),
      ),
    );
  }
}

//------------------------------bottom bar end----------------------------