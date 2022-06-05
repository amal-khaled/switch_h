import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/local_data/hive_methods.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/real_api/real_products.dart';
import 'package:sweet/screens/cart/cart.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sweet/widgets/product_widget.dart';
import 'package:toast/toast.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailsScreen extends StatefulWidget {
  final ProductLive product;

  const ProductDetailsScreen({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int numOfItems = 1;
  List<ProductLive> similarProducts = [];

/*  int getAddIconOrProductCount() {
    if (Provider.of<HomeProvider>(context, listen: false)
                    .productIdToProductCountInCart[
                widget.product.productID.toString()] ==
            0 ||
        Provider.of<HomeProvider>(context, listen: false)
                    .productIdToProductCountInCart[
                widget.product.productID.toString()] ==
            null) {
      return 0;
    } else
      return Provider.of<HomeProvider>(context, listen: false)
                  .productIdToProductCountInCart[
              widget.product.productID.toString()]?? 0;
  }*/

  @override
  void initState() {
    super.initState();
    getSimilarProducts();
  }

/*  int getCountOfProductInCart() {
    List<CartItem> cartItemsList =
        Provider.of<HomeProvider>(context, listen: false).cartItemsList;
    try {
      return cartItemsList
          .where((widget) =>
      widget.product.productID == this.widget.product.productID)
          .toList()[0]
          .quantity;
    } catch (e) {
      return 0;
    }
  }*/
  getSimilarProducts() {
    List<ProductLive> productsList = [];
    List<CategoryLive> categoriesList =
        Provider.of<HomeProvider>(context, listen: false).categoriesList;
    for (int i = 0; i < categoriesList.length; i++) {
      productsList.addAll(categoriesList[i].categoryProducts);
    }
    productsList = productsList
        .where((widget) =>
            widget.productSubcategoryID ==
            this.widget.product.productSubcategoryID)
        .toList();
    similarProducts = productsList
        .where((widget) => widget.productID != this.widget.product.productID)
        .toList();
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox.fromSize(
      size: Size(30.sp, 30.sp), // button width and height
      child: ClipOval(
        child: Material(
          color: brandColor, // button color
          child: InkWell(
            splashColor: brandColor, // splash color
            onTap: press as void Function(), // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 25.sp,
                  color: Colors.white,
                ), // icon// text
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        centerTitle: true,
        title: Text(
          'Sweet H',
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          CartIcon(
            key: ValueKey("CartIconKey"),
          ),
          SizedBox(width: fixPadding)
        ],
        leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context))),
      ),
      bottomNavigationBar: Material(
        child: Container(
          height: 6.h,
          child: Row(
            children: [
              //this was item body
              Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: OutlinedButton.icon(
                      icon: Container(
                        width: 40.sp,
                        height: 40.sp,
                        child: Icon(
                          Icons.payments_rounded,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      label: Text(
                        "${((Boxes.getLocalCartItemsBox().get(widget.product.productID) ?? 0 + numOfItems) * widget.product.productPrice).toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 13.sp,
                            color: Colors.white),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.2),
                              topRight: Radius.circular(20.2)),
                        ),
                      ),
                    )),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: OutlinedButton.icon(
                      icon: CartIcon(
                        key: ValueKey("CartIconKey"),
                        color: Colors.white,
                      ),
                      label: Text(
                        AppLocalizations.of(context).translate("addToCart"),
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 13.sp,
                            color: Colors.white),
                      ),
                      onPressed: () async {
                        // if (isAvailable == false) {
                        //   showDialogBox(
                        //       AppLocalizations.of(context).translate("sorry"),
                        //       '${AppLocalizations.of(context).translate("soldOut")}',
                        //       context);
                        // }

                        if (isAvailable == true) {
                          // if (Boxes.getLocalCartItemsBox()
                          //         .get(widget.product.productID) ??
                          //     0 + numOfItems > quantity) {
                          //   showDialogBox(
                          //       AppLocalizations.of(context).translate("sorry"),
                          //       '${AppLocalizations.of(context).translate("only")} $quantity ${AppLocalizations.of(context).translate("availableNow")}',
                          //       context);
                          // } else {
                          if (numOfItems > 0) {
                            await HiveMethods.addProductToLocalCartItemObject(
                                context, widget.product, numOfItems);
                            setState(() {
                              numOfItems = 1;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Cart()));
                            });
                          } else {
                            Toast.show(AppLocalizations.of(context)
                                .translate("addProductCount"));
                          }
                          // }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: brandColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.2),
                              topRight: Radius.circular(20.2)),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      /*  Flexible(
                        flex: 0,
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 07.w,
                                height: 3.5.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: brandColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),*/
//column of image and description and title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  height: 27.h,
                                  width: 8.w,
                                  child: Stack(
                                    children: <Widget>[
                                      Carousel(
                                        dotSize: 4.sp,
                                        dotSpacing: 4.w,
                                        dotColor: Colors.lightBlueAccent,
                                        indicatorBgPadding: 4.sp,
                                        dotBgColor: Colors.transparent,
                                        borderRadius: true,
                                        dotVerticalPadding: 5.0,
                                        dotPosition: DotPosition.bottomRight,
                                        images: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                image: NetworkImage(widget
                                                    .product.productImageURL),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      widget.product.productOriginalPrice ==
                                              widget.product.productPrice
                                          ? Container(
                                              height: 0,
                                            )
                                          : Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              child: Container(
                                                padding: EdgeInsets.all(5.0),
                                                margin: EdgeInsets.all(0.0),
                                                decoration: BoxDecoration(
                                                  color: brandColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(
                                                      10.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  '-${widget.product.discountPercentage.toString()}%',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: usedFont,
                                                      fontSize: 6.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    /*       TextSpan(
                                        text:
                                            "${AppLocalizations.of(context).translate("productName")}\n",
                                        style: TextStyle(color: brandColor)),*/
                                    TextSpan(
                                      text: getApiString(
                                          context,
                                          widget.product.productTitle.length >
                                                  26
                                              ? widget.product.productTitle
                                                  .replaceRange(
                                                      26,
                                                      widget.product
                                                          .productTitle.length,
                                                      '...')
                                              : widget.product.productTitle,
                                          widget.product.productEnglishTitle
                                                      .length >
                                                  26
                                              ? widget
                                                  .product.productEnglishTitle
                                                  .replaceRange(
                                                      26,
                                                      widget
                                                          .product
                                                          .productEnglishTitle
                                                          .length,
                                                      '...')
                                              : widget
                                                  .product.productEnglishTitle),
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          fontSize: 16.sp,
                                          color: Colors.black87),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  widget.product.productOriginalPrice ==
                                          widget.product.productPrice
                                      ? Container(
                                          height: 0,
                                        )
                                      : RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            text:
                                                "${widget.product.productOriginalPrice.toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(
                                                    fontFamily: usedFont,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                          ),
                                        ),
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text:
                                          "${widget.product.productPrice.toStringAsFixed(2)} ${AppLocalizations.of(context).translate("kd")}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              fontFamily: usedFont,
                                              color: brandColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      buildOutlineButton(
                                        icon: Icons.remove,
                                        press: () {
                                          if (numOfItems > 0) {
                                            setState(() {
                                              numOfItems--;
                                            });
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20 / 2),
                                        child: Text(
                                          // if our item is less  then 10 then  it shows 01 02 like that
                                          numOfItems.toString().padLeft(2, ""),
                                          style: TextStyle(
                                              fontFamily: usedFont,
                                              color: Colors.black,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                      buildOutlineButton(
                                          icon: Icons.add,
                                          press: () {
                                            checkProductQuantity(
                                                productId:
                                                    widget.product.productID);
                                          }),
                                    ],
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable:
                                        Boxes.getLocalCartItemsBox()
                                            .listenable(),
                                    builder: (context,
                                        Box<int> localCartItemsListIDs, _) {
                                      final productCounts =
                                          localCartItemsListIDs
                                              .get(widget.product.productID);
                                      return productCounts == null
                                          ? Container(
                                              height: 0,
                                            )
                                          : Text(
                                              "${AppLocalizations.of(context).translate("exist")} ${productCounts.toString()} ${AppLocalizations.of(context).translate("inCart")}",
                                              style: TextStyle(
                                                  fontFamily: usedFont,
                                                  color: Colors.grey,
                                                  fontSize: 10.sp),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                /*TextSpan(
                                    text:
                                        "${AppLocalizations.of(context).translate("productDescription")}\n",
                                    style: TextStyle(color: brandColor)),*/
                                TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate("details"),
                                  style: TextStyle(
                                      fontFamily: usedFont,
                                      fontSize: 13.sp,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                /*TextSpan(
                                    text:
                                        "${AppLocalizations.of(context).translate("productDescription")}\n",
                                    style: TextStyle(color: brandColor)),*/
                                TextSpan(
                                  text: getApiString(
                                      context,
                                      widget.product.productDescription,
                                      widget.product.productEnglishDescription),
                                  style: TextStyle(
                                      fontFamily: usedFont,
                                      fontSize: 13.sp,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 10,
                            child: Container(
                              color: Colors.blueGrey[50],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            similarProducts.length != 0
                                ? Container(
                                    height: 4.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("similarProducts"),
                                      style: TextStyle(
                                          fontFamily: usedFont,
                                          color: Colors.grey,
                                          fontSize: 16),
                                      textAlign: TextAlign.start,
                                    ))
                                : SizedBox(
                                    height: 1,
                                  ),
                            similarProducts.length != 0
                                ? Container(
                                    height: 40.h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        //controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount: similarProducts.length,
                                        itemBuilder: (context, index) {
                                          return ProductWidget(
                                            getApiString(
                                                context,
                                                similarProducts[index]
                                                    .productTitle,
                                                similarProducts[index]
                                                    .productEnglishTitle),
                                            similarProducts[index],
                                            index: index,
                                            inDetailsScreen: true,
                                          );
                                        }),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  bool isAvailable = false;
  int quantity = 0;
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
        setState(() {
          isAvailable = false;
        });
        showDialogBox(AppLocalizations.of(context).translate("sorry"),
            '${data['msg']}', context);
      } else {
        setState(() {
          numOfItems++;
          isAvailable = true;
        });
        // if (numOfItems == int.parse(data['data'])) {
        //   setState(() {
        //     numOfItems = numOfItems;
        //     isAvailable = true;
        //     quantity = data['data'];
        //   });

        //   showDialogBox(
        //       AppLocalizations.of(context).translate("sorry"),
        //       '${AppLocalizations.of(context).translate("only")} ${data['data']} ${AppLocalizations.of(context).translate("availableNow")}',
        //       context);
        // } else if (int.parse(data['data']) > numOfItems) {
        //   setState(() {
        //     numOfItems++;
        //     isAvailable = true;
        //     quantity = data['data'];
        //     //_isLoading = true;
        //   });
        // }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
