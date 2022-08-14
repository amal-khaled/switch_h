// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/local_data/hive_methods.dart';
import 'package:sweet/real_api/real_products.dart';
import 'package:sweet/screens/details/product_details_screen.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

class ProductWidget extends StatefulWidget {
  final String title;
  final int index;
  final ProductLive product;
  bool inDetailsScreen;
  ProductWidget(this.title, this.product, {this.inDetailsScreen, this.index});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int count;
  //bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      count = setCount();
    });
    super.initState();
  }

  int setCount() {
    return Boxes.getLocalCartItemsBox().get(widget.product.productID) ?? 0;
  }

  Widget getAddIconOrProductCount() {
    return ValueListenableBuilder(
      valueListenable: Boxes.getLocalCartItemsBox().listenable(),
      builder: (context, Box<int> localCartItemsListIDs, _) {
        final value =
            Boxes.getLocalCartItemsBox().get(widget.product.productID);
        return value == null
            ? Icon(
                Icons.add_circle,
                color: brandColor,
              )
            : ClipOval(
                child: Container(
                  color: brandColor,
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //productsList=Provider.of<HomeProvider>(context, listen: false).allProductsInMap[product];
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
            ),
          )),
      child: Container(
        padding: EdgeInsets.only(left: 0.5, right: 0.5, top: 5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 15.0,
            offset: Offset(0, 0.75),
          ),
        ]),
        child: Container(
          width: 50.w,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(left: 20,right: 20),
                    height: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.productImageURL),
                        fit: BoxFit.contain,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  widget.product.productOriginalPrice ==
                          widget.product.productPrice
                      ? Container(
                          height: 0,
                        )
                      : Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            //margin: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: brandColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            child: Text(
                                '-${widget.product.discountPercentage.toString()}%',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                )),
                          ),
                        ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      //margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: ValueListenableBuilder(
                            valueListenable:
                                Boxes.getLocalCartItemsBox().listenable(),
                            builder:
                                (context, Box<int> localCartItemsListIDs, _) {
                              final value = Boxes.getLocalCartItemsBox()
                                  .get(widget.product.productID);
                              return value == null
                                  ? Icon(
                                      Icons.add_circle,
                                      color: brandColor,
                                      size: 27.sp,
                                    )
                                  : Container(
                                      width: 6.03.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                          color: brandColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    );
                            },
                          ),
                          onPressed: () async {
                            if (widget.inDetailsScreen == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      product: widget.product,
                                    ),
                                  ));
                            } else {
                              checkProductQuantity(
                                  productId: widget.product.productID);
                              // if (widget.product.productQuantity == 0) {
                              //   showDialogBox(
                              //       AppLocalizations.of(context)
                              //           .translate("sorry"),
                              //       '${AppLocalizations.of(context).translate("soldOut")}',
                              //       context);
                              // } else {
                              //   count = setCount();
                              //   if (count == widget.product.productQuantity) {

                              //   } else {
                              //     await HiveMethods
                              //         .addProductToLocalCartItemObject(
                              //             context, widget.product, 1);
                              //     setState(() {
                              //       count++;
                              //       //_isLoading = true;
                              //     });
                              //   }
                              // }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Text(
                      getApiString(
                          context,
                          widget.product.productTitle.length > 16
                              ? widget.product.productTitle.replaceRange(
                                  16, widget.product.productTitle.length, '...')
                              : widget.product.productTitle,
                          widget.product.productEnglishTitle.length > 16
                              ? widget.product.productEnglishTitle.replaceRange(
                                  16,
                                  widget.product.productEnglishTitle.length,
                                  '...')
                              : widget.product.productEnglishTitle),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Text(
                      "${widget.product.productPrice}${AppLocalizations.of(context).translate("kd")}",
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: brandColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  checkProductQuantity({int productId}) async {
    final String apiUrlTest = APIUrl + "check-product";
    // "https://rayan.openshoop.com/api/v1/check-product";
    try {
      Map<String, dynamic> body = {
        "product_id": productId.toString(),
        "color": "",
        "size": "",
        "type": "2"
      };
      Map<String, String> headers = {
        "Content-lang": Boxes.getUserDataBox().get("userLang"),
        "is_new": "1"
      };
      var response =
          await http.post(Uri.parse(apiUrlTest), body: body, headers: headers);
      var data = jsonDecode(response.body);
      print(data);
      print(productId);
      if (data['state'] == "4") {
        showDialogBox(AppLocalizations.of(context).translate("sorry"),
            '${data['msg']}', context);
      } else {
        HiveMethods.addProductToLocalCartItemObject(context, widget.product, 1);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
