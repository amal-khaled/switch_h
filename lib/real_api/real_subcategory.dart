// To parse this JSON data, do
//
//     final subcategory = subcategoryFromJson(jsonString);

import 'dart:convert';

SubcategoryLive subcategoryFromJson(String str) => SubcategoryLive.fromJson(json.decode(str));

String subcategoryToJson(SubcategoryLive data) => json.encode(data.toJson());

class SubcategoryLive {
  SubcategoryLive({
    this.subcategoryID,
    this.categoryID,
    this.subcategoryName,
    this.subcategoryNameEn,
    this.activity,
    this.num,
    this.subcategoryImg,
    this.subcategoryImgFullPath,
  });

  int subcategoryID;
  int categoryID;
  String subcategoryName;
  String subcategoryNameEn;
  int activity;
  dynamic num;
  String subcategoryImg;
  String subcategoryImgFullPath;

  factory SubcategoryLive.fromJson(Map<String, dynamic> json) => SubcategoryLive(
    subcategoryID: json["id"],
    categoryID: json["category_id"],
    subcategoryName: json["name"],
    subcategoryNameEn: json["name_en"],
    activity: json["activity"],
    num: json["num"],
    subcategoryImg: json["img"],
    subcategoryImgFullPath: json["img_full_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": subcategoryID,
    "category_id": categoryID,
    "name": subcategoryName,
    "name_en": subcategoryNameEn,
    "activity": activity,
    "num": num,
    "img": subcategoryImg,
    "img_full_path": subcategoryImgFullPath,
  };
}
