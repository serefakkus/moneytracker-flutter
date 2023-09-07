import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../helpers/home_web.dart';
import '../../main.dart';
import '../../model/get/incom.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

List<PayInfo>? _payInfoList = [];

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
      backgroundColor: loginBackGroundColor,
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
  _payInfoList = await getHome(context);
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
        child: _PayCardList());
  }
}

class _PayCardList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PayCardList();

  @override
  State<_PayCardList> createState() => __PayCardListState();
}

class __PayCardListState extends State<_PayCardList> {
  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_payInfoList == null) {
      return const Center(
        child: Text(
          'Veriler getirilirken bir hata oluştu lütfen daha sonra tekrar deneyiniz',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_payInfoList == null) {
      return const Center(
        child: Text(
          'Burada görüntülenmesi için ilk paylaşımınızı yapınız :)',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: _payInfoList!.length,
      itemBuilder: (context, index) {
        PayInfo payInfo = _payInfoList![index];

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
                    height: _height / 20,
                    child: Row(),
                  ),
                ),
                SizedBox(
                  height: _height / 30,
                  child: Row(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Color _getPayColor(bool? type) {
  if (type == true) {
    return Colors.blue;
  }

  if (type == false) {
    return Colors.pinkAccent;
  }

  return Colors.white;
}
//-----------------------------------body end---------------------------

//----------------------------------bottom bar--------------------------

class _BottomBarHome extends StatefulWidget {
  const _BottomBarHome();

  @override
  State<_BottomBarHome> createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<_BottomBarHome> {
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

class _PlusIconBottom extends StatefulWidget {
  const _PlusIconBottom();

  @override
  State<_PlusIconBottom> createState() => __PlusIconBottomState();
}

class __PlusIconBottomState extends State<_PlusIconBottom> {
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
          onPressed: () {
            print('plus ');
          },
        ),
      ),
    );
  }
}

class _FilterButtonBottom extends StatelessWidget {
  const _FilterButtonBottom();

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

class _ShorterButtonBottom extends StatelessWidget {
  const _ShorterButtonBottom();

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
