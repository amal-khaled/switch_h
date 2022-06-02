// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));

String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  Setting({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.wats,
    this.aboutApp,
    this.contactPhone,
    this.contactEmail,
    this.fbLink,
    this.twLink,
    this.instaLink,
    this.ytLink,
    this.android,
    this.ios,
    this.name,
    this.logo,
    this.status,
    this.address,
    this.nameEn,
    this.aboutAppEn,
    this.addressEn,
    this.dolar,
    this.egypt,
    this.color,
    this.appKey,
    this.link,
    this.text,
    this.color2,
    this.strategy,
    this.strategyEn,
    this.isBrand,
    this.currency,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String wats;
  String aboutApp;
  String contactPhone;
  String contactEmail;
  String fbLink;
  String twLink;
  String instaLink;
  String ytLink;
  String android;
  String ios;
  String name;
  String logo;
  int status;
  String address;
  String nameEn;
  String aboutAppEn;
  String addressEn;
  double dolar;
  dynamic egypt;
  String color;
  String appKey;
  String link;
  String text;
  String color2;
  String strategy;
  String strategyEn;
  int isBrand;
  String currency;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    wats: json["wats"],
    aboutApp: json["about_app"],
    contactPhone: json["contact_phone"],
    contactEmail: json["contact_email"],
    fbLink: json["fb_link"],
    twLink: json["tw_link"],
    instaLink: json["insta_link"],
    ytLink: json["yt_link"],
    android: json["android"],
    ios: json["ios"],
    name: json["name"],
    logo: json["logo"],
    status: json["status"],
    address: json["address"],
    nameEn: json["name_en"],
    aboutAppEn: json["about_app_en"],
    addressEn: json["address_en"],
    dolar: json["dolar"].toDouble(),
    egypt: json["egypt"],
    color: json["color"],
    appKey: json["app_key"],
    link: json["link"],
    text: json["text"],
    color2: json["color2"],
    strategy: json["strategy"],
    strategyEn: json["strategy_en"],
    isBrand: json["is_brand"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "wats": wats,
    "about_app": aboutApp,
    "contact_phone": contactPhone,
    "contact_email": contactEmail,
    "fb_link": fbLink,
    "tw_link": twLink,
    "insta_link": instaLink,
    "yt_link": ytLink,
    "android": android,
    "ios": ios,
    "name": name,
    "logo": logo,
    "status": status,
    "address": address,
    "name_en": nameEn,
    "about_app_en": aboutAppEn,
    "address_en": addressEn,
    "dolar": dolar,
    "egypt": egypt,
    "color": color,
    "app_key": appKey,
    "link": link,
    "text": text,
    "color2": color2,
    "strategy": strategy,
    "strategy_en": strategyEn,
    "is_brand": isBrand,
    "currency": currency,
  };
}
