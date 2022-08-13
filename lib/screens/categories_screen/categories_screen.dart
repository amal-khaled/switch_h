import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/providers/app_localizations.dart';
import '../specific_category_products/specific_category_products.dart';
import 'package:sizer/sizer.dart';

class CategoriesGridView extends StatelessWidget {
  CategoriesGridView();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    List<CategoryLive> categoriesList =
        Provider.of<HomeProvider>(context, listen: false).categoriesList;
    // List<Brand> visibleWidgets=brandsList.where((widget) => widget.brandTitle == "JBS").toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        title: Text(
          AppLocalizations.of(context).translate("categories"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: brandColor),
        actions: <Widget>[
          CartIcon(key: ValueKey("CartIconKey")),
          SizedBox(width: fixPadding)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            child: Stack(
          children: [
            Container(),
            Card(
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
                          (MediaQuery.of(context).size.height / 1.3),
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 4),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //Todo try to include parameters to trigger data of category
                                  builder: (context) => SpecificCategoryProducts(
                                      getApiString(
                                          context,
                                          Provider.of<HomeProvider>(context, listen: false)
                                                  .categoryArabicNameToSubcategoriesArabicNamesMap[
                                              categoriesList[index]
                                                  .categoryTitle],
                                          Provider.of<HomeProvider>(context, listen: false)
                                                  .categoryEnglishNameToSubcategoriesEnglishNamesMap[
                                              categoriesList[index]
                                                  .categoryEnglishTitle]),
                                      getApiString(
                                          context,
                                          Provider.of<HomeProvider>(context, listen: false)
                                                  .categoryArabicNameToSubcategoriesIDsMap[
                                              categoriesList[index]
                                                  .categoryTitle],
                                          Provider.of<HomeProvider>(context, listen: false)
                                              .categoryEnglishNameToSubcategoriesIDsMap[categoriesList[index].categoryEnglishTitle]),
                                      getApiString(context, categoriesList[index].categoryTitle, categoriesList[index].categoryEnglishTitle),
                                      categoriesList[index].categoryID)));
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 40.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            categoriesList[index].imgFullPath),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    getApiString(
                                        context,
                                        categoriesList[index].categoryTitle,
                                        categoriesList[index]
                                            .categoryEnglishTitle),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: usedFont,
                                        fontSize: 13.sp,
                                        color: brandColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                  itemCount: categoriesList.length,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
