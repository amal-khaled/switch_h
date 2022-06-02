// To parse this JSON data, do
//
//     final offers = offersFromJson(jsonString);

import 'dart:convert';

OffersLive offersFromJson(String str) => OffersLive.fromJson(json.decode(str));

String offersToJson(OffersLive data) => json.encode(data.toJson());

class OffersLive {
  OffersLive({
    this.offerID,
    this.createdAt,
    this.updatedAt,
    this.activity,
    this.offerNumber,
    this.offerImageURL,
    this.offerText,
    this.offerImageFullPath,
  });

  int offerID;
  DateTime createdAt;
  DateTime updatedAt;
  int activity;
  dynamic offerNumber;
  String offerImageURL;
  String offerText;
  String offerImageFullPath;

  factory OffersLive.fromJson(Map<String, dynamic> json) => OffersLive(
    offerID: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    activity: json["activity"],
    offerNumber: json["num"],
    offerImageURL: json["img"],
    offerText: json["text"],
    offerImageFullPath: json["img_full_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": offerID,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "activity": activity,
    "num": num,
    "img": offerImageURL,
    "text": offerText,
    "img_full_path": offerImageFullPath,
  };
}
