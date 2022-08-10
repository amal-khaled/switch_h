import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';

import 'package:sweet/real_api/load_data.dart';

import 'package:sweet/real_api/real_products.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/screens/splash/splashScreen.dart';
import 'package:sweet/widgets/product_widget.dart';
import 'package:sizer/sizer.dart';

class SpecificCategoryProducts extends StatefulWidget {
  final List<String> subcategoriesTitlesList;
  final List<int> subcategoriesIDsList;
  final String chosenCategory;
  final int chosenCategoryID;
  SpecificCategoryProducts(this.subcategoriesTitlesList,
      this.subcategoriesIDsList, this.chosenCategory, this.chosenCategoryID);

  @override
  _SpecificCategoryProductsState createState() =>
      _SpecificCategoryProductsState();
}

class _SpecificCategoryProductsState extends State<SpecificCategoryProducts> {
  bool isLoading;
  LoadData api;
  String value = "";
  List<ProductLive> categoryProducts = [];
  getCategoryProducts() async {
    // print("${APIUrl}items?sub_id=${widget.chosenCategoryID.toString()}&type=all");
    try {
      var data = await api.getData(
          link:
              "${APIUrl}items?sub_id=${widget.chosenCategoryID.toString()}&type=all",
          type: "list",
          call: "get");
      if (data != null) {
        data["items"].forEach((element) {
          //print(element);
          categoryProducts.add(ProductLive.fromJson(element));
        });
        //Provider.of<HomeProvider>(context, listen: false).setCategoryProductIDToProductMap(categoryProducts);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        EasyLoading.dismiss();
        Alert(
          context: context,
          type: AlertType.info,
          style: AlertStyle(
            titleStyle: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                fontFamily: usedFont,
                color: Colors.indigo),
            descStyle: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                fontFamily: usedFont),
          ),
          title: AppLocalizations.of(context).translate("networkError"),
          desc: AppLocalizations.of(context).translate("networkErrorMSG"),
          buttons: [
            DialogButton(
              child: Text(
                AppLocalizations.of(context).translate("reload"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: usedFont,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SplashScreen()));
              },
              color: Colors.lightBlue,
            ),
          ],
        ).show();
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.info,
        style: AlertStyle(
          titleStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont,
              color: Colors.indigo),
          descStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont),
        ),
        title: AppLocalizations.of(context).translate("networkError"),
        desc: AppLocalizations.of(context).translate("networkErrorMSG"),
        buttons: [
          DialogButton(
            child: Text(
              AppLocalizations.of(context).translate("reload"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: usedFont,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
// Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            color: Colors.lightBlue,
          ),
        ],
      ).show();
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    api = new LoadData(context);
    getCategoryProducts();
    super.initState();
  }

  List<String> apiSort = ["lowestPrice", "highestPrice", "bestDiscount"];
  @override
  Widget build(BuildContext context) {
    List<String> filter = [
      AppLocalizations.of(context).translate("high_price"),
      AppLocalizations.of(context).translate("low_price"),
      AppLocalizations.of(context).translate("high_discount"),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        title: Text(
          widget.chosenCategory,
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: titleColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: brandColor),
        actions: <Widget>[
          CartIcon(key: ValueKey("CartIconKey")),
          SizedBox(width: fixPadding)
        ],
      ),
      /*body: ScrollableTabsPreparation(allCategoryProducts,Provider.of<HomeProvider>(context, listen: false).allSubcategoryByCategory.keys.toList() */ /*Provider.of<HomeProvider>(context, listen: false).allProductsInMapByName.keys.toList()*/ /*, context),*/
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widget.subcategoriesIDsList == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 60.0,
                        color: Colors.grey,
                      ),
                      Text(
                        AppLocalizations.of(context).translate("noProducts"),
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 10.sp,
                            color: Colors.grey),
                      )
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: DropdownButton<String>(
                          isDense: true,
                          underline: const SizedBox(),
                          iconEnabledColor: titleColor,
                          iconDisabledColor: titleColor,
                          icon: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: titleColor,
                          ),
                          hint: Text(
                            (value != "") ? value : AppLocalizations.of(context).translate("sort"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: titleColor,
                              fontFamily: usedFont,
                              fontSize: 13.sp,
                            ),
                          ),
                          items: List.generate(filter.length, (index) {
                            return DropdownMenuItem(
                              value: filter[index],
                              child: Column(
                                children: [
                                  Text(
                                    filter[index],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Divider(
                                    color: brandColor,
                                  )
                                ],
                              ),
                              onTap: () {
                                // newItem.sortList(index);
                                setState(() {
                                  value = filter[index];
                                });
                                // firstLoad();
                              },
                            );
                          }),
                          onChanged: (val) {
                            setState(() {
                              value = val;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: ScrollableListTabView(
                        
                          tabHeight: 7.h,
                          bodyAnimationDuration:
                              const Duration(milliseconds: 150),
                          tabAnimationCurve: Curves.easeOut,
                          tabAnimationDuration:
                              const Duration(milliseconds: 200),
                          tabs: getScrollableListTabs()),
                    ),
                  ],
                ),
    );
  }

  List<ScrollableListTab> getScrollableListTabs() {
    List<ScrollableListTab> scrollableListTabList = [];

    for (int i = 0; i < widget.subcategoriesIDsList.length; i++) {
      List<ProductLive> visibleWidgets = categoryProducts
          .where((widget2) =>
              widget2.productSubcategoryID == widget.subcategoriesIDsList[i])
          .toList();
      print(widget.subcategoriesTitlesList[i]);
      print(visibleWidgets.length);
      print(i);
      if (visibleWidgets.length != 0) {
        scrollableListTabList.add(
          ScrollableListTab(
              tab: ListTab(
                label: Text(
                  widget.subcategoriesTitlesList[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: usedFont,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      ),
                ),
                activeBackgroundColor: titleColor,
                inactiveBackgroundColor: Colors.white,
                borderColor: Colors.red,
              ),
              body: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: visibleWidgets.length,
                itemBuilder: (context, index) => ProductWidget(
                  visibleWidgets[index].productTitle,
                  visibleWidgets[index],
                  index: index,
                ),
              )),
        );
      }
    }
    return scrollableListTabList;
  }
}
