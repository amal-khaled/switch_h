// ignore_for_file: deprecated_member_use

import 'package:sweet/real_api/real_subcategory.dart';

import 'real_products.dart';

class CategoryLive {
  int categoryID;
  String categoryTitle;
  String categoryEnglishTitle;
  int activity;
  int numberOfItems;
  String categoryImgURL;
  List<ProductLive> categoryProducts;
  List<SubcategoryLive> subcategoriesList;
  String imgFullPath;

  CategoryLive(
      {this.categoryID,
      this.categoryTitle,
      this.categoryEnglishTitle,
      this.activity,
      this.numberOfItems,
      this.categoryImgURL,
      this.categoryProducts,
      this.subcategoriesList,
      this.imgFullPath});

  CategoryLive.fromJson(Map<String, dynamic> json) {
    categoryID = json['id'];
    categoryTitle = json['name'];
    categoryEnglishTitle = json['name_en'];
    activity = json['activity'];
    numberOfItems = json['num'];
    categoryImgURL = json['img'];
    if (json['items'] != null) {
      categoryProducts = new List<ProductLive>();
      json['items'].forEach((v) {
        categoryProducts.add(new ProductLive.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      subcategoriesList = new List<SubcategoryLive>();
      json['sub_categories'].forEach((v) {
        subcategoriesList.add(new SubcategoryLive.fromJson(v));
      });
    }
    imgFullPath = json['img_full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.categoryID;
    data['name'] = this.categoryTitle;
    data['name_en'] = this.categoryEnglishTitle;
    data['activity'] = this.activity;
    data['num'] = this.numberOfItems;
    data['img'] = this.categoryImgURL;
    if (this.categoryProducts != null) {
      data['items'] = this.categoryProducts.map((v) => v.toJson()).toList();
    }
    if (this.subcategoriesList != null) {
      data['sub_categories'] =
          this.subcategoriesList.map((v) => v.toJson()).toList();
    }
    data['img_full_path'] = this.imgFullPath;
    return data;
  }
}
