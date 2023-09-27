class UserCategory {
  String? id;
  String? fromId;
  String? userId;
  List<CategoryInfo>? outCategory;
  List<CategoryInfo>? inCategory;
  List<FromHis>? inComFrom;
  List<FromHis>? outGoFrom;
  List<FromHis>? regInFrom;
  List<FromHis>? regOutFrom;

  UserCategory({
    this.id,
    this.fromId,
    this.userId,
    this.outCategory,
    this.inCategory,
    this.inComFrom,
    this.outGoFrom,
    this.regInFrom,
    this.regOutFrom,
  });

  UserCategory.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    userId = json["UserId"];

    if (json['OutCategory'] != null) {
      outCategory = <CategoryInfo>[];
      json['OutCategory'].forEach((v) {
        outCategory!.add(CategoryInfo.fromJson(v));
      });
    }

    if (json['InCategory'] != null) {
      inCategory = <CategoryInfo>[];
      json['InCategory'].forEach((v) {
        inCategory!.add(CategoryInfo.fromJson(v));
      });
    }

    if (json['InComingFrom'] != null) {
      inComFrom = <FromHis>[];
      json['InComingFrom'].forEach((v) {
        inComFrom!.add(FromHis.fromJson(v));
      });
    }

    if (json['OutGoingFrom'] != null) {
      outGoFrom = <FromHis>[];
      json['OutGoingFrom'].forEach((v) {
        outGoFrom!.add(FromHis.fromJson(v));
      });
    }

    if (json['RegInFrom'] != null) {
      regInFrom = <FromHis>[];
      json['RegInFrom'].forEach((v) {
        regInFrom!.add(FromHis.fromJson(v));
      });
    }

    if (json['RegOutFrom'] != null) {
      regOutFrom = <FromHis>[];
      json['RegOutFrom'].forEach((v) {
        regOutFrom!.add(FromHis.fromJson(v));
      });
    }
  }
}

class CategoryInfo {
  String? name;
  List<String>? iDs;

  CategoryInfo({
    this.name,
    this.iDs,
  });

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    name = json["Name"];

    if (json['IDs'] != null) {
      iDs = <String>[];
      json['IDs'].forEach((v) {
        iDs!.add(v);
      });
    }
  }
}

class UserRegularCategory {
  List<CategoryInfo>? outCategory;
  List<CategoryInfo>? inCategory;

  UserRegularCategory({
    this.outCategory,
    this.inCategory,
  });
}

class FromHis {
  String? userId;
  String? name;
  List<String>? payIds;

  FromHis({
    this.userId,
    this.name,
    this.payIds,
  });

  FromHis.fromJson(Map<String, dynamic> json) {
    userId = json["UserId"];
    name = json["Name"];

    if (json['PayIds'] != null) {
      payIds = <String>[];
      json['PayIds'].forEach((v) {
        payIds!.add(v);
      });
    }
  }
}
