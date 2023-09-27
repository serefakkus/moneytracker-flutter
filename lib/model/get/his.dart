class RespUserHis {
  List<HistoryYears>? incomingYears;
  List<HistoryYears>? outgoingYears;
  List<RegularHis>? inRegular;
  List<RegularHis>? outRegular;
  bool? isEmpty;
  String? categoryId;
  String? fromId;

  RespUserHis({
    this.incomingYears,
    this.outgoingYears,
    this.inRegular,
    this.outRegular,
    this.isEmpty,
    this.categoryId,
    this.fromId,
  });

  RespUserHis.fromJson(Map<String, dynamic> json) {
    isEmpty = json["IsEmpty"];
    categoryId = json["CategoryId"];
    fromId = json["FromID"];

    if (json['IncomingYears'] != null) {
      incomingYears = <HistoryYears>[];
      json['IncomingYears'].forEach((v) {
        incomingYears!.add(HistoryYears.fromJson(v));
      });
    }

    if (json['OutgoingYears'] != null) {
      outgoingYears = <HistoryYears>[];
      json['OutgoingYears'].forEach((v) {
        outgoingYears!.add(HistoryYears.fromJson(v));
      });
    }

    if (json['InRegular'] != null) {
      inRegular = <RegularHis>[];
      json['InRegular'].forEach((v) {
        inRegular!.add(RegularHis.fromJson(v));
      });
    }

    if (json['OutRegular'] != null) {
      outRegular = <RegularHis>[];
      json['OutRegular'].forEach((v) {
        outRegular!.add(RegularHis.fromJson(v));
      });
    }
  }
}

class HistoryYears {
  String? year;
  List<HistoryMonths>? months;

  HistoryYears({
    this.year,
    this.months,
  });

  HistoryYears.fromJson(Map<String, dynamic> json) {
    year = json['Year'];
    if (json['Months'] != null) {
      months = <HistoryMonths>[];
      json['Months'].forEach((v) {
        months!.add(HistoryMonths.fromJson(v));
      });
    }
  }
}

class HistoryMonths {
  String? month;
  List<HistoryDays>? days;

  HistoryMonths({
    this.month,
    this.days,
  });

  HistoryMonths.fromJson(Map<String, dynamic> json) {
    month = json['Month'];
    if (json['Days'] != null) {
      days = <HistoryDays>[];
      json['Days'].forEach((v) {
        days!.add(HistoryDays.fromJson(v));
      });
    }
  }
}

class HistoryDays {
  String? day;
  List<String>? idS;

  HistoryDays({
    this.day,
    this.idS,
  });

  HistoryDays.fromJson(Map<String, dynamic> json) {
    day = json['Day'];
    if (json['Ids'] != null) {
      idS = (json["Ids"] as List<dynamic>).cast<String>();
    }
  }
}

class RegularHis {
  String? mongoId;
  String? category;

  RegularHis({
    this.mongoId,
    this.category,
  });

  RegularHis.fromJson(Map<String, dynamic> json) {
    mongoId = json['MongoId'];
    category = json['Category'];
  }
}
