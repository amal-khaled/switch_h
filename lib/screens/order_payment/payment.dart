// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:sizer/sizer.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/main.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/real_api/payment_method.dart';
import 'package:sweet/screens/order_payment/visa.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';

class PaymentPage extends StatefulWidget {
  double price;
  String govern;
  String city;
  String address;
  String phone;
  double total;
  double balance;
  String country;
  String deliveryDate;
  String deliveryTime;
  String name;
  PaymentMethodElement cashOnDeliveryData = PaymentMethodElement(
      paymentMethodId: 0,
      paymentMethodAr: "الدفع عند الاستلام",
      paymentMethodEn: "Cash On Delivery",
      paymentMethodCode: "",
      isDirectPayment: false,
      serviceCharge: 0.0,
      totalAmount: 0.0,
      currencyIso: "KWD",
      imageUrl: "assets/icons/cod.jpg");
  PaymentPage(
      this.total,
      this.price,
      this.phone,
      this.govern,
      this.city,
      this.address,
      this.deliveryDate,
      this.deliveryTime,
      this.name,
      this.balance,
      this.country);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedPaymentMethodID;
  bool _load = false;
  bool load_intial = true;
  double net = 0.0;
  double remained = 0.0;
  String _response = '';
  String _loading = "Loading...";
  List<PaymentMethodElement> myPaymentMethods = [];
  void executeRegularPayment() {
    int paymentMethod = 1;
    var request = new MFExecutePaymentRequest(paymentMethod, net);

    MFSDK.executePayment(
      context,
      request,
      MFAPILanguage.EN,
      onPaymentResponse:
          (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
        if (result.isSuccess())
          {
            setState(() {
              _response = result.response.toJson().toString();
              print(_response);
              print("_response");
              setOrders(invoiceId, "knet");
            })
          }
        else
          {
            setState(() {
              //error payment
              _response = result.error.message;
              //print(_response);
              Toast.show(AppLocalizations.of(context).translate("tryAgain"),
                  textStyle: context);
              _load = false;
            })
          }
      },
    );

    setState(() {
      _response = _loading;
    });
  }

  void executeDirectPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Visa(
              widget.total,
              widget.price,
              widget.phone,
              widget.govern,
              widget.city,
              widget.address,
              widget.name,
              (widget.balance - remained),
              net)),
    );
  }

  void initiatePayment() {
    var request = new MFInitiatePaymentRequest(net, MFCurrencyISO.KUWAIT_KWD);
    MFSDK.initiatePayment(
        request,
        MFAPILanguage.EN,
        (MFResult<MFInitiatePaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    load_intial = false;

                    result.response
                        .toJson()["PaymentMethods"]
                        .forEach((element) {
                      myPaymentMethods
                          .add(PaymentMethodElement.fromJson(element));
                    });
                    myPaymentMethods.add(widget.cashOnDeliveryData);
                    print(myPaymentMethods);
                    print("myPaymentMethodsss");
                    print([result.response.toJson()["PaymentMethods"]]);
                    print("myPaymentMethodss");
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.message);

                    load_intial = false;
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  getNet() {
    double net2 = (widget.total + widget.price) - widget.balance;
    if (net2 == 0) {
      setState(() {
        net = 0.0;
        remained = 0.0;
      });
    }
    if (net2 > 0) {
      setState(() {
        net = net2;
        remained = 0.0;
      });
    }
    if (net2 < 0) {
      setState(() {
        net = 0.0;
        remained = (net2).abs();
      });
    }
  }

  setOrders(invoiceId, type) async {
    setState(() {
      _load = true;
    });
    final tok = Boxes.getUserDataBox().get("userToken");
    final box = Boxes.getLocalCartItemsBox();
    int boxQTY = box.values.length;
    print(tok);
    if (tok != null) {
      try {
        var productsOptions = [];
        for (int i = 0; i < boxQTY; i++) {
          productsOptions.add(
            {
              "attr": [
                {
                  "id": box.keyAt(i).toString(),
                },
                {
                  "qut": box.getAt(i).toString(),
                },
                {
                  "color": "",
                },
                {
                  "size": "",
                },
                {
                  "type": 2.toString(),
                },
              ],
            },
          );
        }
        final result = await InternetAddress.lookup('google.com');
        print(productsOptions);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Map<String, dynamic> body = {
            "phone": widget.phone,
            "type": type.toString(),
            "inovic_id": invoiceId.toString(),
            "username": widget.name,
            "name": widget.govern,
            "city": widget.city,
            "address": widget.address,
            "deliveryDate": widget.deliveryDate,
            "deliveryTime": widget.deliveryTime,
            "token": tok.toString(),
            "country": widget.country,
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
            "balance": (widget.balance - remained).toString(),
            "products": jsonEncode(productsOptions),
          };
          final String apiUrl = APIUrl + "add_orders";
          final String apiUrlTest = APIUrl + "add_orders";
          http.Response response = await http.post(Uri.parse(apiUrlTest),
              headers: {"Accept": "application/json", "is_new": "1"},
              body: body);

          print(productsOptions);
          print(body);
          print(apiUrl);
          if (response.statusCode == 200) {
            print("---------------------------------------------------");

            var res = json.decode(response.body);
            print(res);
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
            } else if (res["state"] == "4") {
              showDialogBox(AppLocalizations.of(context).translate("sorry"),
                  '${res['msg']}', context);
              var errordata = response.body;
              print(errordata);
              //error or product not avilable
            }
          }
        } else {
          //error msg no internet
        }
      } on SocketException {
        //error msg no internet
      }
    } else {
      //error msg
    }
    if (this.mounted) {
      setState(() {
        _load = false;
      });
    }
  }

  // Future addToRemoteCart() async {
  //   final tok = Boxes.getUserDataBox().get("userToken");
  //   final box = Boxes.getLocalCartItemsBox();
  //   int boxQTY = box.values.length;
  // for (int i = 0; i < boxQTY; i++) {
  //   http.Response response =
  //       await http.post(Uri.parse("${APIUrl}add_carts"), headers: {
  //     "Accept": "application/json"
  //   }, body: {
  //     "token": tok,
  //     "item_id": box.keyAt(i).toString(),
  //     "qut": box.getAt(i).toString(),
  //     "type": 2.toString(),
  //   });
  //     //Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
  //     var data = jsonDecode(response.body);
  //     print(data);
  //     if (response != null) {
  //     } else {
  //       Toast.show(
  //           AppLocalizations.of(context).translate("someThingWrong"), context);
  //     }
  //   }
  // }

  checkOrders(execute(), type) async {
    if (type == "" || type == "balance") {
      setOrders(0, type);
    } else {
      if (type == "visa") {
        setState(() {
          _load = false;
        });
      }
      execute();
    }
  }

  @override
  void initState() {
    MFSDK.setUpAppBar(
        title: "sweet H",
        titleColor: Colors.white, // Color(0xFFFFFFFF)
        backgroundColor: brandColor, // Color(0xFF000000)
        isShowAppBar: true); // Fo

    super.initState();

    if (mAPIKey.isEmpty) {
      setState(() {
        _response =
            "Missing API Key.. You can get it from here: https://myfatoorah.readme.io/docs/demo-information";
      });
      return;
    }

    // MFSDK.init(urlTest, mApiKeyTest);
    MFSDK.init(mAPIKey, MFCountry.KUWAIT, MFEnvironment.LIVE);
    initiatePayment();

    getNet();
    selectedPaymentMethodID = 0;
    _load = false;
  }

  setPaymentMethod(int val) {
    if (this.mounted) {
      setState(() {
        selectedPaymentMethodID = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: brandColor,
      appBar: AppBar(
        centerTitle: true,
        // shape: shapeForAppBars(),
        elevation: 0,

        iconTheme: IconThemeData(
          color: brandColor,
        ),
        title: Text(
          AppLocalizations.of(context).translate("payment"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 16.sp, color: brandColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: brandColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("ExpectedDeliveryTime"),
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 12.sp,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        height: 12.h,
                        width: 100.w,
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("totalPrice"),
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "${widget.total.toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(
                                color: brandColor,
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate("deliveryCost"),
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black)),
                                  Text(
                                    "${widget.price} ${AppLocalizations.of(context).translate("kd")}",
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(
                                color: brandColor,
                                height: 10,
                              ),
                            ],
                          ),
                        )),
                      ),
                      widget.balance != 0.0
                          ? Container(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              width: 100.w,
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate("yourBalance"),
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.white)),
                                  Text(
                                      "${widget.balance} ${AppLocalizations.of(context).translate("kd")}",
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.white)),
                                ],
                              ),
                            )
                          : Container(),
                      Divider(
                        color: Colors.white,
                        height: 20,
                      ),
                      Container(
                        height: 6.h,
                        width: 100.w,
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                            color: brandColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  AppLocalizations.of(context)
                                      .translate("totalTotalPrice"),
                                  style: TextStyle(
                                      fontFamily: usedFont,
                                      fontSize: 12.sp,
                                      color: Colors.white)),
                              Text(
                                  "${net.toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                  style: TextStyle(
                                      fontFamily: usedFont,
                                      fontSize: 12.sp,
                                      color: Colors.white)),
                            ],
                          ),
                        )),
                      ),
                      widget.balance != 0.0
                          ? Container(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              width: 100.w,
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate("remainedBalance"),
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87)),
                                  Text(
                                      "$remained ${AppLocalizations.of(context).translate("kd")}",
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87)),
                                ],
                              ),
                            )
                          : Divider(
                              height: 1.0,
                            ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      AppLocalizations.of(context)
                          .translate("ChoosePaymentMethod"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 13.sp,
                          color: Colors.white)),
                ),
                load_intial
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: myPaymentMethods.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            title: Container(
                              height: 8.h,
                              width: 90.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.0),
                                  color: brandColor,
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
                                ),
                                child: RadioListTile(
                                  value:
                                      myPaymentMethods[index].paymentMethodId,
                                  groupValue: selectedPaymentMethodID,
                                  title: Text(
                                    getApiString(
                                        context,
                                        myPaymentMethods[index].paymentMethodAr,
                                        myPaymentMethods[index]
                                            .paymentMethodEn),
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.white),
                                  ),
                                  onChanged: (val) {
                                    setPaymentMethod(val);
                                    print(val);
                                  },
                                  activeColor: Colors.white,
                                  contentPadding: EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  secondary: Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      //border: Border.all(color: Colors.white, width: 1.0),
                                    ),
                                    height: 8.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image(
                                        image: myPaymentMethods[index]
                                                    .paymentMethodId ==
                                                0
                                            ? AssetImage(
                                                "${myPaymentMethods[index].imageUrl}",
                                              )
                                            : NetworkImage(
                                                "${myPaymentMethods[index].imageUrl}",
                                              ),
                                        width: 18.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                !_load
                    ? InkWell(
                        onTap: () async {
                          if (this.mounted) {
                            setState(() {
                              _load = true;
                            });
                          }
                          // await addToRemoteCart();
                          if (selectedPaymentMethodID == 1) {
                            checkOrders(executeRegularPayment, "knet");
                          }
                          if (selectedPaymentMethodID == 2) {
                            checkOrders(executeDirectPayment, "visa");
                          }
                          if (selectedPaymentMethodID == 0) {
                            if (net > 0) {
                              checkOrders(executeRegularPayment, "");
                            } else {
                              checkOrders(executeRegularPayment, "balance");
                            }
                          }
                        },
                        child: Container(
                            height: 7.h,
                            width: 50.w,
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              AppLocalizations.of(context).translate("confirm"),
                              style: TextStyle(
                                  fontFamily: usedFont,
                                  fontSize: 17.sp,
                                  color: brandColor),
                            )),
                      )
                    : CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
