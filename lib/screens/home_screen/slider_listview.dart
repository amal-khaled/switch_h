import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/providers/changeLang.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/offers.dart';
import 'package:sweet/screens/specific_offer_products/specific_offer_products.dart';
import 'package:sizer/sizer.dart';

class HomeSliderListView extends StatelessWidget {
  const HomeSliderListView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<OffersLive> offersList =
        Provider.of<HomeProvider>(context, listen: false).offersList;
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 28.h,
          width: MediaQuery.of(context).size.width,
          child: Carousel(
            dotSize: 4.sp,
            dotSpacing: 4.w,
            dotColor: Colors.lightBlueAccent,
            indicatorBgPadding: 4.sp,
            dotBgColor: Colors.transparent,
            borderRadius: true,
            dotVerticalPadding: 4.sp,
            dotPosition:
                Provider.of<AppLanguage>(context, listen: false).lang == "en"
                    ? DotPosition.bottomRight
                    : DotPosition.bottomLeft,
            images: getSliderItem(context, offersList)
            /*getSliderItem(
                MediaQuery.of(context).size.width,
                'assets/images/slider/slider_2.jpg',
                'BuyNow',
                'make your shopping from home, no need to go out',
              ),
              getSliderItem(
                MediaQuery.of(context).size.width,
                'assets/images/slider/slider_1.jpg',
                'Enjoy',
                'Enjoy our services with low cost',
              ),
              getSliderItem(
                MediaQuery.of(context).size.width,
                'assets/images/slider/slider_3.jpg',
                'OrderNow',
                'we arrives in a few minutes',
              ),*/
            ,
          ),
        ),
      ],
    );
  }

  List<Widget> getSliderItem(
      BuildContext context, List<OffersLive> offersList) {
    List<Widget> offers = [];
    for (int i = 0; i < offersList.length; i++) {
      offers.add(Container(
        decoration: BoxDecoration(
          /*borderRadius: BorderRadius.circular(10.0),*/
          image: DecorationImage(
            image: NetworkImage(offersList[i].offerImageFullPath),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 28.h,
              width: 100.w,
              // color: Colors.black.withOpacity(0.35),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(
                    //   offersList[i].offerText,
                    //   style: TextStyle(
                    //       fontFamily: usedFont,
                    //       fontSize: 13.sp,
                    //       color: Colors.black),
                    // ),
                    /*SizedBox(height: 10.0),
                    Container(
                      width: 170.0,
                      child: Text(
                        '${offersList[i].offerID} products',
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ),*/
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: brandColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 5.0, right: 15.0, left: 15.0),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpecificOfferProducts(
                                    offersList[i].offerID,
                                    offersList[i].offerText),
                              )),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("seeDetails"),
                            style: TextStyle(
                                fontFamily: usedFont,
                                fontSize: 13.sp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return offers;
  }
}
