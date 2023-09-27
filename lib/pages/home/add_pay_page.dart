import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moneytracker/helpers/category_web.dart';
import 'package:moneytracker/main.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _isWaitingData = true;

List<String> _inCategoryNames = [];
List<String> _outCategoryNames = [];

bool _isFirst = true;

TextEditingController _categoryController = TextEditingController();

class AddPayPage extends StatefulWidget {
  const AddPayPage({super.key});

  @override
  State<AddPayPage> createState() => _AddPayPageState();
}

class _AddPayPageState extends State<AddPayPage> {
  @override
  void initState() {
    _isFirst = true;
    _isWaitingData = true;
    _selectedCategory = null;
    _selectedFrom = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirst) {
      _isFirst = false;
      _getCategory(context);
    }
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    return Scaffold(
      backgroundColor: homeBackGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Header(),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.center,
                child: _BodyAdd(),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: _BottomBar(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _getCategory(BuildContext context) async {
    await getCategory(context);
    _isWaitingData = false;
    _inCategoryNames = [];
    _outCategoryNames = [];

    if (userCategory.inCategory != null) {
      for (var e in userCategory.inCategory!) {
        if (e.name != null) {
          _inCategoryNames.add(e.name!);
        }
      }
    }

    if (userCategory.outCategory != null) {
      for (var e in userCategory.outCategory!) {
        if (e.name != null) {
          _outCategoryNames.add(e.name!);
        }
      }
    }

    setState(() {});
  }
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
        height: _height * 0.14,
        child: Container(
          color: Colors.grey.shade300,
          child: const Row(
            children: [
              _BackButton(),
              _TextColumn(),
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
        left: _width / 80,
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

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 18, left: _width / 50),
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

//---------------------------------header end------------------

//---------------------------------body------------------

class _BodyAdd extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BodyAdd();

  @override
  State<_BodyAdd> createState() => _BodyAddState();
}

class _BodyAddState extends State<_BodyAdd> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      //height: (_height * 52) / 70,
      height: _height * 0.85,
      child: ListView(
        children: [
          _TypeSelect(setS),
          _RegularSelect(setS),
          _CategorySelect(setS),
          _NewCategoryText(_selectedCategory),
          _FromSelecter(setS),
          _NewFromText(_selectedFrom),
          const _AddButton(),
        ],
      ),
    );
  }

  setS() {
    setState(() {});
  }
}

//-------------------------------type---------------------------

bool _selectedType = true;

class _TypeSelect extends StatefulWidget {
  const _TypeSelect(this.setS);
  final void Function() setS;

  @override
  State<_TypeSelect> createState() => __TypeSelectState();
}

class __TypeSelectState extends State<_TypeSelect> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_width / 20)),
        ),
        child: Row(
          children: [
            _SelectGelir(widget.setS),
            _SelectGider(widget.setS),
          ],
        ),
      ),
    );
  }
}

class _SelectGelir extends StatefulWidget {
  const _SelectGelir(this.setS);
  final void Function() setS;

  @override
  State<_SelectGelir> createState() => _SelectGelirState();
}

class _SelectGelirState extends State<_SelectGelir> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: selColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_width / 20),
          ),
        ),
        child: SizedBox(
          width: _width * 0.45,
          height: _height / 20,
          child: const Center(
              child: Text(
            "GELİR",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
      onTap: () {
        if (_selectedType) {
          return;
        }
        _selectedCategory = "KATEGORİ SEÇ";
        _selectedFrom = "KİŞİ SEÇ";
        _selectedType = true;
        widget.setS();
      },
    );
  }

  Color selColor() {
    if (_selectedType) {
      return Colors.blue;
    }

    return Colors.white;
  }
}

class _SelectGider extends StatefulWidget {
  const _SelectGider(this.setS);
  final void Function() setS;

  @override
  State<_SelectGider> createState() => _SelectGiderState();
}

class _SelectGiderState extends State<_SelectGider> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: selColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_width / 20),
          ),
        ),
        child: SizedBox(
          width: _width * 0.45,
          height: _height / 20,
          child: const Center(
              child: Text(
            "GİDER",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
      onTap: () {
        if (!_selectedType) {
          return;
        }
        _selectedCategory = "KATEGORİ SEÇ";
        _selectedFrom = "KİŞİ SEÇ";
        _selectedType = false;
        widget.setS();
      },
    );
  }

  Color selColor() {
    if (!_selectedType) {
      return Colors.green;
    }
    return Colors.white;
  }
}
//-------------------------------type end-----------------------------

//-----------------------------------regular selecter-----------------------

bool _selectedRegular = true;

class _RegularSelect extends StatefulWidget {
  const _RegularSelect(this.setS);
  final void Function() setS;

  @override
  State<_RegularSelect> createState() => _RegularSelectState();
}

class _RegularSelectState extends State<_RegularSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: SizedBox(
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(_width / 20)),
          ),
          child: Row(
            children: [
              _SelectRegular(widget.setS),
              _SelectIrregular(widget.setS),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectRegular extends StatefulWidget {
  const _SelectRegular(this.setS);
  final void Function() setS;

  @override
  State<_SelectRegular> createState() => _SelectRegularState();
}

class _SelectRegularState extends State<_SelectRegular> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: selColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_width / 20),
          ),
        ),
        child: SizedBox(
          width: _width * 0.45,
          height: _height / 20,
          child: const Center(
              child: Text(
            "DÜZENLİ",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
      onTap: () {
        if (_selectedRegular) {
          return;
        }
        _selectedCategory = "KATEGORİ SEÇ";
        _selectedFrom = "KİŞİ SEÇ";
        _selectedRegular = true;
        widget.setS();
      },
    );
  }

  Color selColor() {
    if (_selectedRegular) {
      return Colors.blue;
    }

    return Colors.white;
  }
}

class _SelectIrregular extends StatefulWidget {
  const _SelectIrregular(this.setS);
  final void Function() setS;

  @override
  State<_SelectIrregular> createState() => _SelectIrregularState();
}

class _SelectIrregularState extends State<_SelectIrregular> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: selColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_width / 20),
          ),
        ),
        child: SizedBox(
          width: _width * 0.45,
          height: _height / 20,
          child: const Center(
              child: Text(
            "TEK SEFERLİK",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
      onTap: () {
        if (!_selectedRegular) {
          return;
        }
        _selectedCategory = "KATEGORİ SEÇ";
        _selectedFrom = "KİŞİ SEÇ";
        _selectedRegular = false;
        widget.setS();
      },
    );
  }

  Color selColor() {
    if (!_selectedRegular) {
      return Colors.green;
    }
    return Colors.white;
  }
}

//-----------------------------------regular selecter end---------------------

//---------------------------------category selecter-------------------------

String? _selectedCategory;
String _selectedCategoryHint = "KATEGORİ SEÇ";
int _selectedCategoryInd = 0;

class _CategorySelect extends StatefulWidget {
  const _CategorySelect(this.setS, {Key? key}) : super(key: key);
  final Function setS;

  @override
  State<_CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<_CategorySelect> {
  @override
  void initState() {
    _selectedCategoryHint = "KATEGORİ SEÇ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory != null) {
      _selectedCategoryHint = _selectedCategory!;
    }

    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: GestureDetector(
        child: SizedBox(
          height: _height * 0.07,
          child: Card(
            color: Colors.grey.shade300,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_width / 20),
              ),
            ),
            child: Center(
              child: Text(
                _selectedCategoryHint,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _height / 50,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          if (_isWaitingData) {
            EasyLoading.showToast("Lütfen bekleyin");
            return;
          }
          _categorySelectOnTop(widget.setS, context);
        },
      ),
    );
  }
}

void _categorySelectOnTop(Function setS, BuildContext context) {
  List<String> catName = [];

  if (_selectedType && !_selectedRegular) {
    if (userCategory.inCategory != null) {
      for (var e in userCategory.inCategory!) {
        if (e.name != null) {
          catName.add(e.name!);
        }
      }
    }
  }

  if (!_selectedType && !_selectedRegular) {
    if (userCategory.outCategory != null) {
      for (var e in userCategory.outCategory!) {
        if (e.name != null) {
          catName.add(e.name!);
        }
      }
    }
  }

  if (_selectedType && _selectedRegular) {
    if (userRegularCategory.inCategory != null) {
      for (var e in userRegularCategory.inCategory!) {
        if (e.name != null) {
          catName.add(e.name!);
        }
      }
    }
  }

  if (!_selectedType && _selectedRegular) {
    if (userRegularCategory.outCategory != null) {
      for (var e in userRegularCategory.outCategory!) {
        if (e.name != null) {
          catName.add(e.name!);
        }
      }
    }
  }

  catName.add("YENI KATEGORİ");

  _selectedCategory = catName[_selectedCategoryInd];

  showDialog(
    CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: _kItemExtent,
      scrollController: FixedExtentScrollController(
        initialItem: _selectedCategoryInd,
      ),
      onSelectedItemChanged: (int selectedItem) {
        _selectedCategory = catName[selectedItem];
        _selectedCategoryInd = selectedItem;
        setS();
      },
      children: List<Widget>.generate(catName.length, (int index) {
        return Center(child: Text(catName[index]));
      }),
    ),
    context,
  );

  setS();
}

const double _kItemExtent = 32.0;

void showDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}

//-------------------------------category selecter--------------------------

//-----------------------------new category--------------------------------

class _NewCategoryText extends StatefulWidget {
  const _NewCategoryText(this.selectedCategory);
  final String? selectedCategory;

  @override
  State<_NewCategoryText> createState() => __NewCategoryTextState();
}

class __NewCategoryTextState extends State<_NewCategoryText> {
  @override
  Widget build(BuildContext context) {
    if (_selectedCategory != "YENI KATEGORİ") {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
        left: _width / 15,
        right: _width / 15,
      ),
      child: SizedBox(
        height: _height * 0.07,
        child: Padding(
          padding: const EdgeInsets.only(),
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            controller: _categoryController,
            cursorColor: Colors.blue,
            textInputAction: TextInputAction.go,
          ),
        ),
      ),
    );
  }
}

//--------------------------------new category end-------------------------

//--------------------------------from selecter-----------------------------

String? _selectedFrom;
String _selectedFromHint = "KİŞİ SEÇ";
int _selectedFromInd = 0;

class _FromSelecter extends StatefulWidget {
  const _FromSelecter(this.setS);
  final Function setS;

  @override
  State<_FromSelecter> createState() => _FromSelecterState();
}

class _FromSelecterState extends State<_FromSelecter> {
  @override
  void initState() {
    _selectedFromHint = "KİŞİ SEÇ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedFrom != null) {
      _selectedFromHint = _selectedFrom!;
    }
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: GestureDetector(
        child: SizedBox(
          height: _height * 0.07,
          child: Card(
            color: Colors.grey.shade300,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_width / 20),
              ),
            ),
            child: Center(
              child: Text(
                _selectedFromHint,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _height / 50,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          if (_isWaitingData) {
            EasyLoading.showToast("Lütfen bekleyin");
            return;
          }
          _fromSelectOnTop(widget.setS, context);
        },
      ),
    );
  }
}

void _fromSelectOnTop(Function setS, BuildContext context) {
  List<String> fromName = [];

  if (_selectedType && !_selectedRegular) {
    if (userCategory.inComFrom != null) {
      for (var e in userCategory.inComFrom!) {
        if (e.name != null) {
          fromName.add(e.name!);
        }
      }
    }
  }

  if (!_selectedType && !_selectedRegular) {
    if (userCategory.outGoFrom != null) {
      for (var e in userCategory.outGoFrom!) {
        if (e.name != null) {
          fromName.add(e.name!);
        }
      }
    }
  }

  if (_selectedType && _selectedRegular) {
    if (userCategory.regInFrom != null) {
      for (var e in userCategory.regInFrom!) {
        if (e.name != null) {
          fromName.add(e.name!);
        }
      }
    }
  }

  if (!_selectedType && _selectedRegular) {
    if (userCategory.regOutFrom != null) {
      for (var e in userCategory.regOutFrom!) {
        if (e.name != null) {
          fromName.add(e.name!);
        }
      }
    }
  }

  fromName.add("YENI KİŞİ");

  _selectedFrom = fromName[_selectedFromInd];

  showDialog(
    CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: _kItemExtent,
      scrollController: FixedExtentScrollController(
        initialItem: _selectedCategoryInd,
      ),
      onSelectedItemChanged: (int selectedItem) {
        _selectedCategory = fromName[selectedItem];
        _selectedFromInd = selectedItem;
        setS();
      },
      children: List<Widget>.generate(fromName.length, (int index) {
        return Center(child: Text(fromName[index]));
      }),
    ),
    context,
  );

  setS();
}

//------------------------------from selecter end--------------------------

//------------------------------from text----------------------------------

class _NewFromText extends StatefulWidget {
  const _NewFromText(this.selectedFrom);
  final String? selectedFrom;

  @override
  State<_NewFromText> createState() => _NewFromTextState();
}

class _NewFromTextState extends State<_NewFromText> {
  @override
  Widget build(BuildContext context) {
    if (_selectedFrom != "YENI KİŞİ") {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
        left: _width / 15,
        right: _width / 15,
      ),
      child: SizedBox(
        height: _height * 0.07,
        child: Padding(
          padding: const EdgeInsets.only(),
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            controller: _categoryController,
            cursorColor: Colors.blue,
            textInputAction: TextInputAction.go,
          ),
        ),
      ),
    );
  }
}

//-----------------------------from text end------------------------------

//-----------------------------add button------------------------------

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: _height * 0.1,
          left: _width * 0.2,
          right: _width * 0.2,
          bottom: _height * 0.1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          elevation: 10,
          fixedSize: Size((_width * 0.5), (_height / 15)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text('EKLE', style: TextStyle(fontSize: _width / 25)),
        onPressed: () {
          print("add button pressed");
        },
      ),
    );
  }
}

//----------------------------add button end--------------------------

//----------------------------------body end--------------------------

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
              height: _height / 20,
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
        radius: _width / 7,
        child: IconButton(
          isSelected: false,
          iconSize: _width / 5,
          icon: const Icon(
            Icons.home_rounded,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

//----------------------------------bottom bar end----------------------
