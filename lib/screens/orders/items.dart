// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:sweet/providers/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../../constants.dart';

class OrderDetails extends StatefulWidget {
  List data;
  OrderDetails(this.data);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List ordersList;
  int ordersCount;
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

    ordersCount = widget.data.length;

    ordersList = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: shapeForAppBars(),
          iconTheme: IconThemeData(color: brandColor),
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("orderDetails"),
            style: TextStyle(
                fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: ListView(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  final item = ordersList[index];
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100.w,
                      child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    height: 13.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(item['img_full_path']),
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
                                          height: 3.sp,
                                        ),
                                        Text(
                                          "${item["price"].toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                          style: TextStyle(
                                              fontFamily: usedFont,
                                              fontSize: 12.sp,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 3.sp,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context).translate("itemsCount")} ${item['qut']}',
                                          style: TextStyle(
                                              fontFamily: usedFont,
                                              fontSize: 12.sp,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 3.sp,
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
                                                      fontSize: width / 22,
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
                                                      fontSize: width / 22,
                                                    ),
                                                  )
                                                : Text("  "),

                                          ],
                                        ),*/
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("totalPrice"),
                                              style: TextStyle(
                                                  fontFamily: usedFont,
                                                  fontSize: 12.sp,
                                                  color: Colors.black87),
                                            ),
                                            Text(
                                              "${(item["price"] * item["qut"]).toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                              style: TextStyle(
                                                  fontFamily: usedFont,
                                                  fontSize: 12.sp,
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
                height: 20,
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
