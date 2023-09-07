import 'package:moneytracker/model/get/incom.dart';

import '../model/get/his.dart';

List<PayInfo>? incomInfoSorting(RespUserHis his) {
  List<dynamic>? list = _getAllYears(his);

  if (list == null) {
    return null;
  }

  List<PayInfo> payInfoList = list[0];
  Set<int> yearSet = list[1];

  List<int> yearList = [];

  for (var e in yearSet) {
    yearList.add(e);
  }

  yearList.sort();

  List<PayInfo> payInfoListSorted = [];

  for (var e in yearList) {
    for (var i = 0; i < payInfoList.length; i++) {
      if (payInfoList[i].day == e) {
        payInfoListSorted.add(payInfoList[i]);
        payInfoList.removeAt(i);
        continue;
      }
    }
  }

  return payInfoListSorted;
}

List<dynamic>? _getAllYears(RespUserHis history) {
  Set<int> yearSet = {};
  List<PayInfo> payInfoList = [];

  bool isOk = false;

  List<dynamic>? list = _getIncomingYears(history);
  if (list != null) {
    isOk = true;
    payInfoList.addAll(list[0]);
    yearSet.addAll(list[1]);
  }

  list = _getOutgoingYears(history);
  if (list != null) {
    isOk = true;
    payInfoList.addAll(list[0]);
    yearSet.addAll(list[1]);
  }

  if (!isOk) {
    return null;
  }

  list = [];
  list.add(payInfoList);
  list.add(yearSet);

  return list;
}

List<dynamic>? _getOutgoingYears(RespUserHis history) {
  if (history.outgoingYears == null) {
    return null;
  }

  Set<int> yearSet = {};
  List<PayInfo> payInfoList = [];

  for (var years in history.outgoingYears!) {
    List<dynamic>? list = _getYear(years, false);
    if (list == null) {
      return null;
    }

    payInfoList.addAll(list[0]);
    yearSet.addAll(list[1]);
  }

  List<dynamic> outGoList = [];

  outGoList.add(payInfoList);
  outGoList.add(yearSet);

  return outGoList;
}

List<dynamic>? _getIncomingYears(RespUserHis history) {
  if (history.incomingYears == null) {
    return null;
  }

  Set<int> yearSet = {};
  List<PayInfo> payInfoList = [];

  for (var years in history.incomingYears!) {
    List<dynamic>? list = _getYear(years, true);
    if (list == null) {
      return null;
    }

    payInfoList.addAll(list[0]);
    yearSet.addAll(list[1]);
  }

  List<dynamic> incomList = [];

  incomList.add(payInfoList);
  incomList.add(yearSet);

  return incomList;
}

List<dynamic>? _getYear(HistoryYears years, bool type) {
  if (years.year == null) {
    return null;
  }

  if (years.months == null) {
    return null;
  }

  List<PayInfo> payInfoList = [];
  Set<int> yearSet = {};

  bool isOk = false;

  for (var m in years.months!) {
    List<dynamic>? list = _getMonth(m, years.year!, type);
    if (list != null) {
      isOk = true;

      payInfoList.addAll(list[0]);

      yearSet.addAll(list[1]);
    }
  }

  if (!isOk) {
    return null;
  }

  List<dynamic> list = [];

  list.add(payInfoList);
  list.add(yearSet);
  return list;
}

List<dynamic>? _getMonth(HistoryMonths months, String yearStr, bool type) {
  if (months.days == null) {
    return null;
  }

  if (months.month == null) {
    return null;
  }

  List<PayInfo> payInfoList = [];
  List<int> dayIntList = [];

  bool isOk = false;

  for (var d in months.days!) {
    List<dynamic>? list = _getDay(d, months.month!, yearStr, type);
    if (list != null) {
      isOk = true;
      for (var p in list[0]) {
        payInfoList.add(p);
      }

      dayIntList.add(list[1]);
    }
  }

  if (!isOk) {
    return null;
  }

  List<dynamic> list = [];

  list.add(payInfoList);
  list.add(dayIntList);
  return list;
}

List<dynamic>? _getDay(
    HistoryDays days, String monthStr, String yearStr, bool type) {
  if (days.day == null) {
    return null;
  }

  if (days.idS == null) {
    return null;
  }

  String dayStr = days.day!;
  int? dayInt = int.tryParse(yearStr + monthStr + dayStr);
  if (dayInt == null) {
    return null;
  }

  List<PayInfo> payInfo = [];

  for (var e in days.idS!) {
    PayInfo pay = PayInfo(day: dayInt, id: e, type: type);
    payInfo.add(pay);
  }

  if (payInfo.isEmpty) {
    return null;
  }

  List<dynamic> list = [];

  list.add(payInfo);
  list.add(dayInt);

  return list;
}
