class ReqCategory {
  String? categoryId;
  String? fromId;

  ReqCategory({
    this.categoryId,
    this.fromId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["CategoryId"] = categoryId;
    data["FromId"] = fromId;
    return data;
  }
}
