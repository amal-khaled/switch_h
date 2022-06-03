// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:sweet/providers/app_localizations.dart';
import 'package:toast/toast.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import '../../constants.dart';
import '../../main.dart';

class Visa extends StatefulWidget {
  double price;
  String govern;
  String city;
  String address;
  String phone;
  double total;
  double balance;
  var net;

  String name;
  Visa(this.total, this.price, this.phone, this.govern, this.city, this.address,
      this.name, this.balance, this.net);
  @override
  State<StatefulWidget> createState() {
    return VisaState();
  }
}

class VisaState extends State<Visa> {
  String cardNumber = '';
  String expiryDate = '';
  String expiryMonth = '';
  List date = [];
  String expiryYear = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool _load = false;
  String _response = '';
  String _loading = "Loading...";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void executeDirectPayment() {
    int paymentMethod = 2;
    var request = new MFExecutePaymentRequest(paymentMethod, widget.net);
    var mfCardInfo = new MFCardInfo(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        securityCode: cvvCode.toString(),
        cardHolderName: cardHolderName.toString(),
        bypass3DS: true,
        saveToken: true);

    MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());
                    set_orders(invoiceId, "visa");
                  })
                }
              else
                {
                  setState(() {
                    _response = result.error.message;
                    Toast.show(_response);
                    print(result.error.toJson());

                    _load = false;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  set_orders(invoiceId, type) async {
    setState(() {
      _load = true;
    });
    final tok = Boxes.getUserDataBox().get("userToken");
    if (tok != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          http.Response response =
              await http.post(Uri.parse(APIUrl + "add_orders"), headers: {
            "Accept": "application/json"
          }, body: {
            "phone": widget.phone,
            "type": type.toString(),
            "inovic_id": invoiceId.toString(),
            "username": widget.name,
            "name": widget.govern,
            "city": widget.city,
            "address": widget.address,
            "token": tok,
            "user_id": Boxes.getUserDataBox().get("userJsonData") == null
                ? "0"
                : jsonDecode(Boxes.getUserDataBox()
                        .get("userJsonData")
                        .toString())["id"]
                    .toString(),
            "price":
                double.parse(Boxes.getUserDataBox().get("userDeliveryPrice"))
                    .toString(),
            "total": double.parse(Boxes.getUserDataBox().get("totalInCart"))
                .toString(),
            "balance": (widget.balance).toString(),
          });

          if (response.statusCode == 200) {
            // print((widget.balance - remind).toString());

            var res = json.decode(response.body);
            if (res["state"] == "1") {
              Boxes.getLocalCartItemsObjectBox().clear();
              Boxes.getLocalCartItemsBox().clear();
              Boxes.getUserDataBox().put("totalInCart", "0.0");
              //success msg
              Toast.show("successful payment");

              Future.delayed(const Duration(seconds: 0), () {
                if (this.mounted) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  });
                }
              });
            } else {
              // "مشكلة بالشبكة اثناء حفظ الطلب في حسابك تواصل مع احفظ رقم الفاتورة وتواصل مع خدمة  العملاء لحل المشكلة كود الفاتورة  ${invoiceId}",
              Toast.show(
                  "مشكلة بالشبكة اثناء حفظ الطلب في حسابك تواصل مع احفظ رقم الفاتورة وتواصل مع خدمة  العملاء لحل المشكلة كود الفاتورة$invoiceId");
            }
          }
        } else {
          Toast.show(AppLocalizations.of(context).translate("noInternet"));
        }
      } on SocketException {
        Toast.show(AppLocalizations.of(context).translate("noInternet"));
      }
    } else {
      Toast.show(AppLocalizations.of(context).translate("reOpenTheApp"));
    }
    if (this.mounted) {
      setState(() {
        _load = false;
      });
    }
  }

  @override
  void initState() {
    // MFSDK.init(baseUrl, mAPIKey);
    MFSDK.init(mAPIKey, MFCountry.KUWAIT, MFEnvironment.LIVE);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Visa Card View',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: brandColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Visa and Master Card",
            style: TextStyle(color: Colors.black),
          ),
          titleSpacing: 0.0,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    formKey: formKey,
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),
              !_load
                  ? InkWell(
                      onTap: () {
                        date = expiryDate.split("/");
                        expiryMonth = date[0].toString();
                        expiryYear = date[1].toString();
                        cardNumber = cardNumber.replaceAll(' ', '');
                        print(cardNumber);
                        print(expiryYear);
                        print("expiryYear");

                        if (cardNumber == "" ||
                            cvvCode == "" ||
                            expiryYear == "" ||
                            cardHolderName == "") {
                          print(cardNumber);
                          print(cvvCode);
                          print(expiryDate);
                          print(expiryYear);
                          print(expiryMonth);
                          print(date);
                          print(cardHolderName);
                          print("cardHolderName");
                          Toast.show(AppLocalizations.of(context)
                              .translate("completeTheData"));
                        } else {
                          setState(() {
                            _load = true;

                            executeDirectPayment();
                          });
                        }
                      },
                      child: Container(
                          width: width,
                          padding: EdgeInsets.all(15.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: brandColor,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Text(
                            "دفع ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: usedFont,
                              fontSize: width / 24,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
