// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/screens/orders/fatora.dart';
import 'package:sweet/screens/orders/items.dart';
import 'package:sweet/screens/splash/splashScreen.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';

// My Own Import

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List ordersList = [];
  int ordersCount = 0;
  var total = 0.00;
  bool _load = true;
  bool progres = false;
  Map map = {};
  bool set_num = false;

  checkFatora(type, status) {
    if (type == null) {
      if (status != 3) {
        return false;
      }
    } else {
      return true;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  getOrders() async {
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var tok = localStorage.getString('token');
    final tok = Boxes.getUserDataBox().get("userToken");

    //var d = localStorage.getString('user');

    if (tok != null) {
      /*d = localStorage.getString('user');

      if (d != null) {
        user_id = jsonDecode(d)["id"];
      } else {
         user_id = 0;
      }*/
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          http.Response response =
              await http.post(Uri.parse(APIUrl + "my_orders"), headers: {
            "Accept": "application/json"
          }, body: {
            "token": tok,
            "user_id": Boxes.getUserDataBox().get("userJsonData") == null
                ? "0"
                : jsonDecode(Boxes.getUserDataBox()
                        .get("userJsonData")
                        .toString())["id"]
                    .toString(),
          });

          if (response.statusCode == 200) {
            var res = json.decode(response.body);
            if (res["state"] == "1") {
              if (this.mounted) {
                setState(() {
                  ordersList = res["data"];
                  ordersCount = ordersList.length;

                  _load = false;
                });
              }
              print(ordersList.length);

              //  print(tok);

            } else {
              Fluttertoast.showToast(
                msg: '${res["msg"]}',
                backgroundColor: Theme.of(context).textTheme.headline6.color,
                textColor: Theme.of(context).appBarTheme.backgroundColor,
              );
            }
          }
        } else {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("noInternet"),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        }
      } on SocketException {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("noInternet"),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("tryAgain"),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
    }
  }

  /////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    progres = false;

    getOrders();
  }

  @override
  Widget build(BuildContext context) {
        ToastContext().init(context);

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          shape: shapeForAppBars(),
          iconTheme: IconThemeData(color: brandColor),
          title: Text(AppLocalizations.of(context).translate("myOrders"),
              style: TextStyle(
                color: brandColor,
                fontSize: 25,
              )),
          backgroundColor: Colors.white,
        ),
        body: !_load
            ? (ordersCount == 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/empty_bag.png',
                          height: 170.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          AppLocalizations.of(context).translate("noOrders"),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: brandColor),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 15.0,
                                  left: 15.0),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("orderNow"),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: usedFont,
                                  fontSize: 16.0,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ListView(
                      children: [
                        Container(
                          child: progres
                              ? LinearProgressIndicator(
                                  backgroundColor: Colors.deepPurple,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.purpleAccent),
                                  minHeight: 20,
                                )
                              : null,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: ordersList.length,
                          itemBuilder: (context, index) {
                            final item = ordersList[index];
                            print(item["type"]);
                            return Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 99.w,
                                child: Card(
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              item["status"] == 1
                                                  ? Container(
                                                      width: 90.w,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              40, 10, 40, 10),
                                                      color: Colors.black,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                "deliveryInProgress"),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                usedFont,
                                                            fontSize: 13.sp,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : item["status"] == 2
                                                      ? Container(
                                                          width: 90.w,
                                                          padding: EdgeInsets
                                                              .fromLTRB(40, 10,
                                                                  40, 10),
                                                          color:
                                                              Colors.pinkAccent,
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    "orderHasBeenSent"),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    usedFont,
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : item["status"] == 3
                                                          ? Container(
                                                              width: 90.w,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          40,
                                                                          10),
                                                              color:
                                                                  Colors.green,
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        "hasBeenReceived"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        usedFont,
                                                                    fontSize:
                                                                        13.sp,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : item["status"] == 4
                                                              ? Container(
                                                                  width: 90.w,
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          40,
                                                                          10),
                                                                  color: Colors
                                                                      .blue,
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            "hasBeenClosed"),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            usedFont,
                                                                        fontSize: 13
                                                                            .sp,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          40,
                                                                          10),
                                                                  color: Colors
                                                                      .grey,
                                                                  child: Text(
                                                                    '   ',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            usedFont,
                                                                        fontSize: 13
                                                                            .sp,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("orderDate"),
                                                    style: TextStyle(
                                                        fontFamily: usedFont,
                                                        fontSize: 12.sp,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      //'${item["date"]}  ',
                                                      '${item["created_at"]}  ',
                                                      style: TextStyle(
                                                          fontFamily: usedFont,
                                                          fontSize: 12.sp,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("orderCode"),
                                                    style: TextStyle(
                                                        fontFamily: usedFont,
                                                        fontSize: 12.sp,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      'E_${item["id"]} ',
                                                      style: TextStyle(
                                                          fontFamily: usedFont,
                                                          fontSize: 12.sp,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            "orderPrice"),
                                                    style: TextStyle(
                                                        fontFamily: usedFont,
                                                        fontSize: 12.sp,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      "${item['price']} ${AppLocalizations.of(context).translate("kd")}",
                                                      style: TextStyle(
                                                          fontFamily: usedFont,
                                                          fontSize: 12.sp,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            "paymentStatus"),
                                                    style: TextStyle(
                                                        fontFamily: usedFont,
                                                        fontSize: 12.sp,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: item["type"] == null
                                                      ? Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    "payUponReceiving"),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    usedFont,
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        )
                                                      : item["type"] ==
                                                              "balance"
                                                          ? Center(
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        "payFromBalance"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        usedFont,
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                            )
                                                          : item["type"] ==
                                                                  "visa"
                                                              ? Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            "payed"),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            usedFont,
                                                                        fontSize: 12
                                                                            .sp,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                                )
                                                              : item["type"] ==
                                                                      "knet"
                                                                  ? Center(
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(context)
                                                                            .translate("payed"),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                usedFont,
                                                                            fontSize:
                                                                                12.sp,
                                                                            color: Colors.black87),
                                                                      ),
                                                                    )
                                                                  : Text(" "),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                                right: 8.0,
                                                left: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 7,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderDetails(item[
                                                                      "items"])));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: brandColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: !_load
                                                          ? Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      "orderDetails"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      usedFont,
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .black87),
                                                            )
                                                          : CircularProgressIndicator(
                                                              backgroundColor:
                                                                  brandColor,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: Text(" ")),
                                                item["status"] != 4
                                                    ? Expanded(
                                                        flex: 5,
                                                        child: InkWell(
                                                          onTap: () {
                                                            print(
                                                                item["items"]);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => Fatora(
                                                                        item[
                                                                            "items"],
                                                                        item)));
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: brandColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child: !_load
                                                                ? Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            "invoice"),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            usedFont,
                                                                        fontSize: 12
                                                                            .sp,
                                                                        color: Colors
                                                                            .black87),
                                                                  )
                                                                : CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                  ),
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(child: Text(" "))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 20,
                          child: progres
                              ? LinearProgressIndicator(
                                  backgroundColor: brandColor,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.purpleAccent),
                                  minHeight: 20,
                                )
                              : null,
                        ),
                      ],
                    ),
                  )
            : Center(
                child: Container(
                    child: CircularProgressIndicator(), width: 32, height: 32),
              ));
  }
}
