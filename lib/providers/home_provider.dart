import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet/real_api/offers.dart';
import 'package:sweet/real_api/real_brands.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/real_api/setting.dart';

class HomeProvider with ChangeNotifier {
  List<CategoryLive> categoriesList;
  //List<CartItem> cartItemsList;

  List<int> localCartItemsListIDs;

  List<OffersLive> offersList;
  List<BrandsLive> brandsList;
  List<Setting> settingList;

  Map<String, List<int>> categoryEnglishNameToSubcategoriesIDsMap;
  Map<String, List<int>> categoryArabicNameToSubcategoriesIDsMap; //for arabic
  Map<String, List<String>> categoryEnglishNameToSubcategoriesEnglishNamesMap;
  Map<String, List<String>>
      categoryArabicNameToSubcategoriesArabicNamesMap; //for arabic
  Map<int, List<int>> categoryIDToSubcategoriesIDsMap;
  Map<int, List<String>> categoryIDToSubcategoriesEnglishNamesMap;
  Map<int, List<String>> categoryIDToSubcategoriesArabicNamesMap; //for arabic

  //List<int> subcategoriesIDsListThatHasProducts=[];

  setCategoriesList(categoriesList) {
    this.categoriesList = categoriesList;
    // setProductIDToProductMap();
    notifyListeners();
  }

/////////

  setCategoryEnglishNameToSubcategoriesIDsMap(
      categoryNameToSubcategoriesIDsMap) {
    this.categoryEnglishNameToSubcategoriesIDsMap =
        categoryNameToSubcategoriesIDsMap;
    notifyListeners();
  }

  setCategoryArabicNameToSubcategoriesIDsMap(
      categoryNameToSubcategoriesIDsMap) {
    this.categoryArabicNameToSubcategoriesIDsMap =
        categoryNameToSubcategoriesIDsMap;
    notifyListeners();
  }

  setCategoryEnglishNameToSubcategoriesEnglishNamesMap(
      categoryEnglishNameToSubcategoriesNamesMap) {
    this.categoryEnglishNameToSubcategoriesEnglishNamesMap =
        categoryEnglishNameToSubcategoriesNamesMap;
    notifyListeners();
  }

  setCategoryArabicNameToSubcategoriesArabicNamesMap(
      categoryArabicNameToSubcategoriesArabicNamesMap) {
    this.categoryArabicNameToSubcategoriesArabicNamesMap =
        categoryArabicNameToSubcategoriesArabicNamesMap;
    notifyListeners();
  }

  setCategoryIDToSubcategoriesIDsMap(categoryIDToSubcategoriesIDsMap) {
    this.categoryIDToSubcategoriesIDsMap = categoryIDToSubcategoriesIDsMap;
    notifyListeners();
  }

  setCategoryIDToSubcategoriesEnglishNamesMap(
      categoryIDToSubcategoriesEnglishNamesMap) {
    this.categoryIDToSubcategoriesEnglishNamesMap =
        categoryIDToSubcategoriesEnglishNamesMap;
    notifyListeners();
  }

  setCategoryIDToSubcategoriesArabicNamesMap(
      categoryIDToSubcategoriesArabicNamesMap) {
    this.categoryIDToSubcategoriesArabicNamesMap =
        categoryIDToSubcategoriesArabicNamesMap;
    notifyListeners();
  }
  ///////////

  setOffersList(offersList) {
    this.offersList = offersList;
    notifyListeners();
  }

  setBrandsList(brandsList) {
    this.brandsList = brandsList;
    notifyListeners();
  }

  void setSetting(settingList) {
    this.settingList = settingList;
    notifyListeners();
  }

/*  setCategoryProductIDToProductMap(List<ProductLive> productsList) {
    for (int i = 0; i < productsList.length; i++) {
      productIDToProduct[productsList[i].productID]=productsList[i];
      //the next part added to filter empty subcategories.
*/ /*      if(productsList[i].productTitle.isNotEmpty){

        subcategoriesIDsListThatHasProducts.add(productsList[i].productSubcategoryID);
      }
      print(subcategoriesIDsListThatHasProducts);*/ /*

    }
    notifyListeners();

  }*/
/*  setProductIDToProductMap() {

    productIDToProduct={};
    List<ProductLive> productsList = [];
    for (int i = 0; i < categoriesList.length; i++) {
      productsList.addAll(categoriesList[i].categoryProducts);

    }
    for (int i = 0; i < productsList.length; i++) {
      productIDToProduct[productsList[i].productID]=productsList[i];

      //the next part added to filter empty subcategories.

*/ /*      if(productsList[i].productTitle.isNotEmpty){

        subcategoriesIDsListThatHasProducts.add(productsList[i].productSubcategoryID);
      }
      print(subcategoriesIDsListThatHasProducts);*/ /*

    }
    notifyListeners();

  }*/
}
