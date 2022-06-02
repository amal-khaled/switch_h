import 'package:flutter/material.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/real_api/load_data.dart';
import 'package:sweet/real_api/real_products.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/widgets/product_widget.dart';
import 'package:sizer/sizer.dart';

class SpecificBrandProducts extends StatefulWidget {
  final String brandTitle;
  final int brandID;

  SpecificBrandProducts(this.brandID, this.brandTitle);

  @override
  _SpecificBrandProductsState createState() => _SpecificBrandProductsState();
}

class _SpecificBrandProductsState extends State<SpecificBrandProducts> {
  bool isLoading;
  LoadData api;
  List<ProductLive> productsList = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    api = new LoadData(context);
    getData();
    /*Timer(Duration(seconds: 6), () {});*/
  }

  @override
  Widget build(BuildContext context) {
    //List<Product> visibleWidgets=itemsList.where((widget) => widget.productBrand == brandTitle).toList();
    return Scaffold(
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        backgroundColor: Colors.white,
        title: Text(
          widget.brandTitle,
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        elevation: 0,
        actions: <Widget>[
          CartIcon(key: ValueKey("CartIconKey")),
          SizedBox(width: fixPadding)
        ],
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productsList.length == 0
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
                            fontSize: 12.sp,
                            color: Colors.grey),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (ctx, index) {
                            return ProductWidget(
                              widget.brandTitle,
                              productsList[index],
                              index: index,
                            );
                          },
                          itemCount: productsList.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void getData() async {
    var data = await api.getData(
        link: "${APIUrl}items?type=brands&sub_id=${widget.brandID.toString()}",
        type: "list",
        call: "get");

    if (data != null) {
      data['items'].forEach((element) {
        productsList.add(ProductLive.fromJson(element));
      });

      setState(() {
        productsList = productsList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }
}
