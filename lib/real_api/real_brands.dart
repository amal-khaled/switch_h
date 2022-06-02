// To parse this JSON data, do
//
//     final brandsLive = brandsLiveFromJson(jsonString);

import 'dart:convert';

BrandsLive brandsLiveFromJson(String str) => BrandsLive.fromJson(json.decode(str));

String brandsLiveToJson(BrandsLive data) => json.encode(data.toJson());

class BrandsLive {
  BrandsLive({
    this.brandID,
    this.createdAt,
    this.updatedAt,
    this.activity,
    this.brandImageURL,
    this.num,
    this.brandTitle,
    this.brandEnglishTitle,
    this.brandFullImageURL,
  });

  int brandID;
  DateTime createdAt;
  DateTime updatedAt;
  int activity;
  String brandImageURL;
  dynamic num;
  String brandTitle;
  String brandEnglishTitle;
  String brandFullImageURL;

  factory BrandsLive.fromJson(Map<String, dynamic> json) => BrandsLive(
    brandID: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    activity: json["activity"],
    brandImageURL: json["img"],
    num: json["num"],
    brandTitle: json["text"],
    brandEnglishTitle: json["text_en"],
    brandFullImageURL: json["img_full_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": brandID,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "activity": activity,
    "img": brandImageURL,
    "num": num,
    "text": brandTitle,
    "text_en": brandEnglishTitle,
    "img_full_path": brandFullImageURL,
  };
}
