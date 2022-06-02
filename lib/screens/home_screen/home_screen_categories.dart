import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/widgets/product_widget.dart';
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
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Container(
            height: 42.h,
            width: double.infinity,
            child: Column(
              children: [
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
                    color: Colors.blueGrey[50],
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getApiString(context, categoriesList[i].categoryTitle,
                              categoriesList[i].categoryEnglishTitle),
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
                Expanded(
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
        );
      },
      itemCount: categoriesList.length,
    );
  }
}
