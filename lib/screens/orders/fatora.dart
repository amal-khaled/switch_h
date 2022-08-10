// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:sweet/providers/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../../constants.dart';

class Fatora extends StatefulWidget {
  List data;
  var item;
  Fatora(this.data, this.item);
  @override
  _FatoraState createState() => _FatoraState();
}

class _FatoraState extends State<Fatora> {
  List cartItemList;
  int cartItem;
  var total = 0.00;
  bool progres = false;
  Map map = {};
  bool set_num = false;

  //////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////add to cart

  /////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    cartItem = widget.data.length;

    cartItemList = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          shape: shapeForAppBars(),
          iconTheme: IconThemeData(color: brandColor),
          title: Text(
            AppLocalizations.of(context).translate("invoice"),
            style: TextStyle(
                fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: ListView(
            children: [
              Container(
                width: 99.w,
                child: Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("userName"),
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.black87),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.h,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      '${widget.item["username"]}  ',
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(1, 2, 6, 2),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("userGovern"),
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
                                      '${widget.item["govern"]}  ',
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(1, 2, 6, 2),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("userAddress"),
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
                                      '${widget.item["address"]}  ',
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87),
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
                                        .translate("date"),
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
                                      '${widget.item["date"]}  ',
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87),
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
                                        .translate("code"),
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
                                      'E_${widget.item["id"]} ',
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 12.sp,
                                          color: Colors.black87),
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
                                        .translate("price"),
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
                                    "${widget.item["price"].toStringAsFixed(2)}${AppLocalizations.of(context).translate("kd")}",
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 12.sp,
                                        color: Colors.black87),
                                  )),
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
                                        .translate("paymentStatus"),
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
                                  child: widget.item["type"] == "cach"
                                      ? widget.item["status"] == 3
                                          ? Center(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        "payUponReceiving"),
                                                style: TextStyle(
                                                    fontFamily: usedFont,
                                                    fontSize: 12.sp,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate("notPaid"),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .color,
                                                    fontSize: 4.w,
                                                    fontFamily: usedFont,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                      : widget.item["type"] == "balance"
                                          ? Center(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        "payFromBalance"),
                                                style: TextStyle(
                                                    fontFamily: usedFont,
                                                    fontSize: 12.sp,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          : widget.item["type"] == "visa"
                                              ? Center(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("paid"),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .color,
                                                        fontSize: 4.w,
                                                        fontFamily: usedFont,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              : widget.item["type"] == "knet"
                                                  ? Center(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate("paid"),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                usedFont,
                                                            fontSize: 12.sp,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    )
                                                  : Text(" "),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: cartItemList.length,
                itemBuilder: (context, index) {
                  final item = cartItemList[index];
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 99.w,
                      child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                      height: 13.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              item['img_full_path']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            '${item['name']}',
                                            style: TextStyle(
                                                fontFamily: usedFont,
                                                fontSize: 12.sp,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            "${item["price"].toStringAsFixed(2)}${AppLocalizations.of(context).translate("kd")}",
                                            style: TextStyle(
                                                fontFamily: usedFont,
                                                fontSize: 12.sp,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context).translate("itemsCount")}${item['qut']}',
                                            style: TextStyle(
                                                fontFamily: usedFont,
                                                fontSize: 12.sp,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          /*Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              item["color"] != null
                                                  ? Text(
                                                      '${item["color"]}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .color,
                                                        fontSize: width / 26,
                                                        fontFamily: "Cairo",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : Text("  "),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              item["size"] != null
                                                  ? Text(
                                                      '${item["size"]}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .color,
                                                        fontSize: 12.0,
                                                      ),
                                                    )
                                                  : Text("  "),
                                            ],
                                          )*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                height: 10,
                child: progres
                    ? LinearProgressIndicator(
                        backgroundColor: brandColor,
                        valueColor: AlwaysStoppedAnimation(Colors.purpleAccent),
                        minHeight: 20,
                      )
                    : null,
              ),
            ],
          ),
        ));
  }
}
