import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_brands.dart';
import 'package:sweet/screens/brands_screen/brands_screen.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../specific_brand_products/specific_brand_products.dart';

class BrandsInHList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<BrandsLive> brandsList =
        Provider.of<HomeProvider>(context, listen: false).brandsList;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BrandsGridView()));
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate("brands"),
                  style: TextStyle(
                      fontFamily: usedFont,
                      fontSize: 13.sp,
                      color: brandColor),
                ),
                Text(
                  AppLocalizations.of(context).translate("more"),
                  style: TextStyle(
                      fontFamily: usedFont,
                      fontSize: 13.sp,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(30.0),
                bottomRight: const Radius.circular(30.0),
              )
          ),
         // padding: EdgeInsets.all(10),
          height: 16.h,

          child: Center(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return InkWell(
                    onTap: () {
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificBrandProducts(
                                brandsList[index].brandID,
                                brandsList[index].brandTitle),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25.w,
                          height: 8.4.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    brandsList[index].brandFullImageURL),
                                fit: BoxFit.contain),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          brandsList[index].brandTitle,
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 12.sp,
                              color: Colors.black87),
                        )
                      ],
                    ));
              },
              itemCount: brandsList.length,
            ),
          ),
        ),
      ],
    );
  }
}
