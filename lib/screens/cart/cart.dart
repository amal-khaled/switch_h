// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/local_data/hive_methods.dart';
import 'package:sweet/screens/details/product_details_screen.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sweet/screens/settings/add_user_delivery_details.dart';
import 'package:sizer/sizer.dart';
import 'package:toast/toast.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      bottomNavigationBar: Material(
        child: Container(
          height: 12.h,
          width: 100.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: Boxes.getUserDataBox().listenable(),
                builder: (context, Box<String> userData, _) {
                  final value = userData.get("totalInCart") ?? "0.0";
                  return Center(
                    child: Text(
                      "${AppLocalizations.of(context).translate("totalPrice")}${double.parse(value).toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 13.sp,
                          color: Colors.black87),
                    ),
                  );
                },
              ),
              Container(
                width: 95.w,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.shopping_basket_rounded),
                          label: Text(
                              AppLocalizations.of(context)
                                  .translate("moreShopping"),
                              style: TextStyle(
                                  fontFamily: usedFont,
                                  fontSize: 12.sp,
                                  color: brandColor)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(width: 2.0, color: brandColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: ElevatedButton.icon(
                          label: Text(
                            AppLocalizations.of(context).translate("order"),
                            style: TextStyle(
                                fontFamily: usedFont,
                                fontSize: 12.sp,
                                color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (double.parse(Boxes.getUserDataBox()
                                    .get("totalInCart")) >=
                                5) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddUserDeliveryDetails(true)));
                            } else {
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate("lessThanFiveKD"),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: brandColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        title: Text(AppLocalizations.of(context).translate("cart"),
            style: TextStyle(
                fontFamily: usedFont, fontSize: 17.sp, color: brandColor)),
        backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getLocalCartItemsBox().listenable(),
        builder: (context, Box<int> localCartItemsListIDs, _) {
          final productsIDs = localCartItemsListIDs.keys.toList();
          final productsCounts = localCartItemsListIDs.values.toList();
          return (productsIDs == null || productsIDs.length == 0)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 10.h,
                        color: Colors.grey,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("noProductsAdded"),
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 12.sp,
                            color: Colors.grey),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: productsIDs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: Boxes.getLocalCartItemsObjectBox()
                                    .get(productsIDs[index]),
                              ),
                            ));
                      },
                      child: Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: 100.w,
                            height: 20.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 35.w,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              Boxes.getLocalCartItemsObjectBox()
                                                  .get(productsIDs[index])
                                                  .productImageURL),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      margin: EdgeInsets.all(2.0),
                                    ),
                                    Boxes.getLocalCartItemsObjectBox()
                                                .get(productsIDs[index])
                                                .productOriginalPrice ==
                                            Boxes.getLocalCartItemsObjectBox()
                                                .get(productsIDs[index])
                                                .productPrice
                                        ? Container(
                                            height: 0,
                                          )
                                        : Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            child: Container(
                                              padding: EdgeInsets.all(2.0),
                                              margin: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                color: brandColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight: Radius.circular(
                                                    10.0,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                  '-${Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).discountPercentage.toString()}%',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                            getApiString(
                                                context,
                                                Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productTitle.length >
                                                        14
                                                    ? Boxes.getLocalCartItemsObjectBox()
                                                        .get(productsIDs[index])
                                                        .productTitle
                                                        .replaceRange(
                                                            14,
                                                            Boxes.getLocalCartItemsObjectBox()
                                                                .get(
                                                                    productsIDs[
                                                                        index])
                                                                .productTitle
                                                                .length,
                                                            '...')
                                                    : Boxes.getLocalCartItemsObjectBox()
                                                        .get(productsIDs[index])
                                                        .productTitle,
                                                Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productEnglishTitle.length >
                                                        14
                                                    ? Boxes.getLocalCartItemsObjectBox()
                                                        .get(productsIDs[index])
                                                        .productEnglishTitle
                                                        .replaceRange(
                                                            14,
                                                            Boxes.getLocalCartItemsObjectBox()
                                                                .get(
                                                                    productsIDs[
                                                                        index])
                                                                .productEnglishTitle
                                                                .length,
                                                            '...')
                                                    : Boxes.getLocalCartItemsObjectBox()
                                                        .get(productsIDs[index])
                                                        .productEnglishTitle),
                                            style: TextStyle(
                                                fontFamily: usedFont,
                                                fontSize: 12.sp,
                                                color: Colors.black87)),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                                "${Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productPrice.toString()}${AppLocalizations.of(context).translate("kd")} (${double.parse((Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productPrice * Boxes.getLocalCartItemsBox().get(productsIDs[index])).toString()).toStringAsFixed(2)})",
                                                style: TextStyle(
                                                    fontFamily: usedFont,
                                                    fontSize: 12.sp,
                                                    color: Colors.black87)),
                                          ),
/*                                Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                            "${productsData[index].productCurrency}",
                                            style: TextStyle(
                                                color: Color(0xFF6e6e71),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400)),
                                      ),*/
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate("itemsCount"),
                                              style: TextStyle(
                                                  fontFamily: usedFont,
                                                  fontSize: 12.sp,
                                                  color: Colors.black87)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20 / 2),
                                            child: Text(
                                                // if our item is less  then 10 then  it shows 01 02 like that
                                                //model.productIDToProduct[model.localCartItemsList[index].cartProductID]
                                                productsCounts[index]
                                                    .toString()
                                                    .padLeft(2, ""),
                                                style: TextStyle(
                                                    fontFamily: usedFont,
                                                    fontSize: 12.sp,
                                                    color: Colors.black87)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: brandColor,
                                          size: 30.sp,
                                        ),
                                        onPressed: () async {
                                          checkProductQuantity(
                                                  productId: Boxes
                                                          .getLocalCartItemsObjectBox()
                                                      .get(productsIDs[index])
                                                      .productID)
                                              .then((value) async {
                                            if (value == true) {
                                              await HiveMethods
                                                  .addProductToLocalCartItemObject(
                                                      context,
                                                      Boxes.getLocalCartItemsObjectBox()
                                                          .get(productsIDs[
                                                              index]),
                                                      1);
                                              // if (quantity >=
                                              //     Boxes.getLocalCartItemsObjectBox()
                                              //         .get(productsIDs[index])
                                              //         .productQuantity) {
                                              //   showDialogBox(
                                              //       AppLocalizations.of(context)
                                              //           .translate("sorry"),
                                              //       '${AppLocalizations.of(context).translate("only")} $quantity ${AppLocalizations.of(context).translate("availableNow")}',
                                              //       context);
                                              // } else {
                                              //   await HiveMethods
                                              //       .addProductToLocalCartItemObject(
                                              //           context,
                                              //           Boxes.getLocalCartItemsObjectBox()
                                              //               .get(productsIDs[
                                              //                   index]),
                                              //           1);
                                              // }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Card(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: brandColor,
                                          size: 30.sp,
                                        ),
                                        onPressed: () async {
                                          if (Boxes.getLocalCartItemsBox()
                                                  .get(productsIDs[index]) ==
                                              1) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              "areYouSure")),
                                                  content: new Text(
                                                      "${AppLocalizations.of(context).translate("deleteThis")} ${getApiString(context, Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productTitle, Boxes.getLocalCartItemsObjectBox().get(productsIDs[index]).productEnglishTitle)}"),
                                                  actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    new FlatButton(
                                                      child: new Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate("ok")),
                                                      onPressed: () {
                                                        //todo
                                                        Boxes.getLocalCartItemsObjectBox()
                                                            .delete(productsIDs[
                                                                index]);
                                                        localCartItemsListIDs
                                                            .deleteAt(index);
                                                        HiveMethods
                                                            .setTotalPrice(
                                                                context);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            await HiveMethods
                                                .addProductToLocalCartItemObject(
                                                    context,
                                                    Boxes.getLocalCartItemsObjectBox()
                                                        .get(
                                                            productsIDs[index]),
                                                    -1);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                );
        },
      ),
    );
  }

  bool isAvailable = false;
  int quantity = 0;
  Future<bool> checkProductQuantity({int productId}) async {
    final String apiUrlTest =
        "https://rayan.openshoop.com/api/v1/check-product";
    try {
      Map<String, dynamic> body = {
        "product_id": productId.toString(),
        "color": "",
        "size": "",
        "type": "2"
      };
      Map<String, String> headers = {
        "Content-lang": Boxes.getUserDataBox().get("userLang"),
      };
      var response =
          await http.post(Uri.parse(apiUrlTest), body: body, headers: headers);
      var data = jsonDecode(response.body);
      print(data);
      print(productId);
      if (data['state'] == "4") {
        setState(() {
          isAvailable = false;
          quantity = 0;
        });
        showDialogBox(AppLocalizations.of(context).translate("sorry"),
            '${data['msg']}', context);
        return isAvailable;
      } else {
        setState(() {
          isAvailable = true;
        });
        return isAvailable;
      }
    } catch (e) {
      print(e.toString());
    }
    return isAvailable;
  }
}
