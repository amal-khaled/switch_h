// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/widgets/product_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../specific_category_products/specific_category_products.dart';
import 'package:sizer/sizer.dart';

class HomeScreenCategories extends StatelessWidget {
  const HomeScreenCategories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CategoryLive> categoriesList =
        Provider.of<HomeProvider>(context, listen: false).categoriesList;
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (ctx, i) {
        return Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              child: Container(
                height: 40.h,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.025,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificCategoryProducts(
                                    getApiString(
                                        context,
                                        Provider.of<HomeProvider>(context, listen: false)
                                                .categoryArabicNameToSubcategoriesArabicNamesMap[
                                            categoriesList[i].categoryTitle],
                                        Provider.of<HomeProvider>(context, listen: false)
                                                .categoryEnglishNameToSubcategoriesEnglishNamesMap[
                                            categoriesList[i]
                                                .categoryEnglishTitle]),
                                    getApiString(
                                        context,
                                        Provider.of<HomeProvider>(context, listen: false)
                                                .categoryArabicNameToSubcategoriesIDsMap[
                                            categoriesList[i].categoryTitle],
                                        Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .categoryEnglishNameToSubcategoriesIDsMap[categoriesList[i].categoryEnglishTitle]),
                                    getApiString(context, categoriesList[i].categoryTitle, categoriesList[i].categoryEnglishTitle),
                                    categoriesList[i].categoryID /*Provider.of<AppLanguage>(context, listen: false).lang == "ar"
                                        ? Provider.of<HomeProvider>(context, listen: false)
                                                .categoryEnglishNameToSubcategoriesNamesMap[
                                            categoriesList[i]
                                                .categoryTitle]
                                        : Provider.of<HomeProvider>(context, listen: false)
                                                .categoryEnglishNameToSubcategoriesNamesMap[
                                            categoriesList[i]
                                                .categoryEnglishTitle],
                                    Provider.of<HomeProvider>(context, listen: false)
                                            .categoryEnglishNameToSubcategoriesIDsMap[
                                        categoriesList[i].categoryTitle] */ /*categoriesListIncludingProducts[i].categoryID*/ /*,
                                    Provider.of<AppLanguage>(context, listen: false).lang == "ar"
                                        ? categoriesList[i].categoryTitle:categoriesList[i].categoryEnglishTitle,
                                    categoriesList[i].categoryID*/
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 0, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getApiString(
                                  context,
                                  categoriesList[i].categoryTitle,
                                  categoriesList[i].categoryEnglishTitle),
                              style: TextStyle(
                                  fontFamily: usedFont,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor),
                            ),
                            Container(
                              width: 20.w,
                              decoration: BoxDecoration(
                                color: titleColor.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("more"),
                                  style: TextStyle(
                                      fontFamily: usedFont,
                                      fontSize: 13.sp,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height*0.3,
                      child: ListView.builder(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ProductWidget(categoriesList[i].categoryTitle,
                              categoriesList[i].categoryProducts[index],
                              index: index);
                        },
                        itemCount: categoriesList[i].categoryProducts.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (i % 2 == 0)
                ? Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await launch("https://bluezonekw.com/");
                        },
                        child: Container(
                          width: double.infinity,
                          height: 53.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://img.freepik.com/free-photo/eastern-sweets-assorted-traditional-turkish-delight-with-nuts_114579-20603.jpg?w=1380&t=st=1660124611~exp=1660125211~hmac=a8c664be440f1c88deabce155e6a079981645348c97dc04a5b36f9e848f669ac"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        );
      },
      itemCount: categoriesList.length,
    );
  }
}
