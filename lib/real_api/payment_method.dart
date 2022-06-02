// To parse this JSON data, do
//
//     final paymentMethod = paymentMethodFromJson(jsonString);

import 'dart:convert';

PaymentMethod paymentMethodFromJson(String str) => PaymentMethod.fromJson(json.decode(str));

String paymentMethodToJson(PaymentMethod data) => json.encode(data.toJson());

class PaymentMethod {
  PaymentMethod({
    this.paymentMethods,
  });

  List<PaymentMethodElement> paymentMethods;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    paymentMethods: List<PaymentMethodElement>.from(json["PaymentMethods"].map((x) => PaymentMethodElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "PaymentMethods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
  };
}

class PaymentMethodElement {
  PaymentMethodElement({
    this.paymentMethodId,
    this.paymentMethodAr,
    this.paymentMethodEn,
    this.paymentMethodCode,
    this.isDirectPayment,
    this.serviceCharge,
    this.totalAmount,
    this.currencyIso,
    this.imageUrl,
  });

  int paymentMethodId;
  String paymentMethodAr;
  String paymentMethodEn;
  String paymentMethodCode;
  bool isDirectPayment;
  double serviceCharge;
  double totalAmount;
  String currencyIso;
  String imageUrl;

  factory PaymentMethodElement.fromJson(Map<String, dynamic> json) => PaymentMethodElement(
    paymentMethodId: json["PaymentMethodId"],
    paymentMethodAr: json["PaymentMethodAr"],
    paymentMethodEn: json["PaymentMethodEn"],
    paymentMethodCode: json["PaymentMethodCode"],
    isDirectPayment: json["IsDirectPayment"],
    serviceCharge: json["ServiceCharge"].toDouble(),
    totalAmount: json["TotalAmount"].toDouble(),
    currencyIso: json["CurrencyIso"],
    imageUrl: json["ImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "PaymentMethodId": paymentMethodId,
    "PaymentMethodAr": paymentMethodAr,
    "PaymentMethodEn": paymentMethodEn,
    "PaymentMethodCode": paymentMethodCode,
    "IsDirectPayment": isDirectPayment,
    "ServiceCharge": serviceCharge,
    "TotalAmount": totalAmount,
    "CurrencyIso": currencyIso,
    "ImageUrl": imageUrl,
  };
}
