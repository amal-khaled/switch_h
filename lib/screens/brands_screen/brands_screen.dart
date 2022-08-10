import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_brands.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/screens/specific_brand_products/specific_brand_products.dart';

import 'package:sizer/sizer.dart';
class BrandsGridView extends StatelessWidget {
  BrandsGridView();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    //List<Brand> visibleWidgets=brandsList.where((widget) => widget.brandTitle == "JBS").toList();
    final List<BrandsLive> brandsList=Provider.of<HomeProvider>(context, listen: false).brandsList;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        title: Text(
          AppLocalizations.of(context).translate("brands"),
          style: TextStyle(fontFamily: usedFont,fontSize: 17.sp,color: titleColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: titleColor),
        actions: <Widget>[
          CartIcon(key: ValueKey("CartIconKey")),
          SizedBox(width: fixPadding)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Center(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                      crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 4),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpecificBrandProducts(brandsList[index].brandID
                                  ,getApiString(context,brandsList[index].brandTitle,brandsList[index].brandEnglishTitle)
                              ),
                            )),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40.w,
                                height: 22.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          brandsList[index].brandFullImageURL),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                getApiString(context,brandsList[index].brandTitle,brandsList[index].brandEnglishTitle),
                                style: TextStyle(fontFamily: usedFont,fontSize: 13.sp,color: brandColor),
                              )
                            ],
                          ),
                        ));
                  },
                  itemCount: brandsList.length,
                ),
              ),
            )),
      ),
    );
  }
}
