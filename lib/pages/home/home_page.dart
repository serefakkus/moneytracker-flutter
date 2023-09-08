// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../helpers/home_web.dart';
import '../../main.dart';
import '../../model/get/incom.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _isWaiting = true;
bool _isWaitingData = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _getHome(context, setS);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Scaffold(
      backgroundColor: homeBackGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Header(),
          _BodyHome(),
          const _BottomBarHome(),
        ],
      ),
    );
  }

  setS() {
    if (mounted) {
      setState(() {});
    }
  }
}

_getHome(BuildContext context, Function setS) async {
  if (_isWaitingData) {
    return;
  }
  _isWaitingData = true;
  await getHome(context);
  _isWaiting = false;
  _isWaitingData = false;
  setS();
}

//---------------------------------header------------------------

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
            children: [
              _TextColumn(),
              _GrafButton(),
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
        left: _width / 8,
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

class _GrafButton extends StatelessWidget {
  const _GrafButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 200,
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
            FontAwesomeIcons.chartLine,
            size: _width / 12,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

//---------------------------------header end------------------

//---------------------------------body------------------------

class _BodyHome extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BodyHome();

  @override
  State<_BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<_BodyHome> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        //height: (_height * 52) / 70,
        height: (_height * 52) / 80,
        child: _InfoCardList());
  }
}

class _InfoCardList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _InfoCardList();

  @override
  State<_InfoCardList> createState() => _InfoCardListState();
}

class _InfoCardListState extends State<_InfoCardList> {
  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (infoList == null) {
      return const Center(
        child: Text(
          'Veriler getirilirken bir hata oluştu lütfen daha sonra tekrar deneyiniz',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (infoList!.isEmpty) {
      return const Center(
        child: Text(
          'Burada görüntülenmesi için ilk paylaşımınızı yapınız :)',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: infoList!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: _InfoCard(index),
          onTap: () {
            Navigator.pushNamed(context, '/PayInfoDetailsPage',
                arguments: infoList![index]!);
          },
        );
      },
    );
  }
}

class _InfoCard extends StatefulWidget {
  _InfoCard(this.index, {Key? key}) : super(key: key);
  int index;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  @override
  Widget build(BuildContext context) {
    PayInfo? payInfo = infoList![widget.index];
    if (payInfo == null) {
      _checkInfo(widget.index, setS);
      return SizedBox(
        width: _width,
        height: _height / 10,
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(_width / 20)),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SizedBox(
      width: _width,
      height: _height / 10,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_width / 20)),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: _getPayColor(payInfo.type),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_width / 20),
                    topLeft: Radius.circular(_width / 20),
                  )),
              child: SizedBox(
                height: _height / 23,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FromText(payInfo),
                    _CategoryText(payInfo),
                    _Emoji(payInfo),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _height / 23,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AmountText(payInfo),
                  _DateText(payInfo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setS() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _FromText extends StatelessWidget {
  _FromText(this.pay, {Key? key}) : super(key: key);
  PayInfo pay;

  @override
  Widget build(BuildContext context) {
    String text = "";

    if (pay.type == true) {
      text = pay.incom!.from!.name.toString();
    } else if (pay.type == false) {
      text = pay.outgo!.to!.name.toString();
    }

    text = text.toUpperCase();

    return SizedBox(
      height: _height / 23,
      width: _width / 4,
      child: Container(
        margin: EdgeInsets.only(left: _width / 20, top: _width / 50),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CategoryText extends StatelessWidget {
  _CategoryText(this.pay, {Key? key}) : super(key: key);
  PayInfo pay;

  @override
  Widget build(BuildContext context) {
    String text = "";

    if (pay.type == true) {
      text = pay.incom!.category.toString();
    } else if (pay.type == false) {
      text = pay.outgo!.category.toString();
    }

    text = text.toUpperCase();

    return SizedBox(
      height: _height / 23,
      width: _width / 4,
      child: Container(
        margin: EdgeInsets.only(right: _width / 20, top: _width / 80),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _Emoji extends StatelessWidget {
  _Emoji(this.pay, {Key? key}) : super(key: key);
  PayInfo pay;

  @override
  Widget build(BuildContext context) {
    String text = "";

    if (pay.type == true) {
      text = pay.incom!.emoji.toString();
    } else if (pay.type == false) {
      text = pay.outgo!.emoji.toString();
    }

    text = text.toUpperCase();

    return SizedBox(
      height: _height / 23,
      width: _width / 4,
      child: Container(
        margin: EdgeInsets.only(right: _width / 20, top: _width / 50),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}

class _AmountText extends StatelessWidget {
  _AmountText(this.pay, {Key? key}) : super(key: key);
  PayInfo pay;

  @override
  Widget build(BuildContext context) {
    String text = "";

    if (pay.type == true) {
      text = pay.incom!.amount!.toStringAsFixed(2);
    } else if (pay.type == false) {
      text = pay.outgo!.amount!.toStringAsFixed(2);
    }

    text = text.toUpperCase();

    text = "₺$text";

    return SizedBox(
      height: _height / 23,
      width: _width / 3,
      child: Container(
        margin: EdgeInsets.only(left: _width / 20, top: _width / 50),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class _DateText extends StatelessWidget {
  _DateText(this.pay, {Key? key}) : super(key: key);
  PayInfo pay;

  @override
  Widget build(BuildContext context) {
    String text = "";

    if (pay.type == true) {
      text = pay.incom!.date.toString();
    } else if (pay.type == false) {
      text = pay.outgo!.date.toString();
    }

    text = text.toUpperCase();

    return SizedBox(
      height: _height / 23,
      width: _width / 3,
      child: Container(
        margin: EdgeInsets.only(right: _width / 20, top: _width / 50),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}

Future<void> _checkInfo(int ind, Function setS) async {
  for (var i = 0; i < 10;) {
    PayInfo? payInfo = infoList![ind];
    if (payInfo != null) {
      setS();
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

Color _getPayColor(bool? type) {
  if (type == true) {
    return const Color(0xFF71C9FB);
  }

  if (type == false) {
    return const Color(0xffE174B6);
  }

  return Colors.white;
}
//-----------------------------------body end---------------------------

//----------------------------------bottom bar--------------------------

class _BottomBarHome extends StatelessWidget {
  const _BottomBarHome();

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
              height: _height / 12,
              child: Container(
                color: Colors.grey.shade300,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FilterButtonBottom(),
                    _ShorterButtonBottom(),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: _PlusIconBottom(),
        ),
      ],
    );
  }
}

class _PlusIconBottom extends StatelessWidget {
  const _PlusIconBottom();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_width / 7)),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        radius: _width / 7,
        child: IconButton(
          isSelected: false,
          iconSize: _width / 5,
          icon: const FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _FilterButtonBottom extends StatefulWidget {
  const _FilterButtonBottom();

  @override
  State<_FilterButtonBottom> createState() => _FilterButtonBottomState();
}

class _FilterButtonBottomState extends State<_FilterButtonBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 50,
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
            FontAwesomeIcons.solidCalendarDays,
            size: _width / 12,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _ShorterButtonBottom extends StatefulWidget {
  const _ShorterButtonBottom();

  @override
  State<_ShorterButtonBottom> createState() => _ShorterButtonBottomState();
}

class _ShorterButtonBottomState extends State<_ShorterButtonBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: _width / 50,
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
            FontAwesomeIcons.arrowDownAZ,
            size: _width / 12,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

//----------------------------------bottom bar end----------------------
