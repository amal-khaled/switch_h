import 'package:hive/hive.dart';
part 'real_products.g.dart';
@HiveType(typeId: 0)
class ProductLive extends HiveObject {
  @HiveField(0)
  int productID;
  @HiveField(1)
  String createdAt;
  @HiveField(2)
  String updatedAt;
  @HiveField(3)
  String productTitle;
  @HiveField(4)
  String productDescription;
  @HiveField(5)
  double productOriginalPrice;
  @HiveField(6)
  double productPrice;
  @HiveField(7)
  int productBrandID;
  @HiveField(8)
  int productSubcategoryID;
  @HiveField(9)
  String productCategoryID;
  @HiveField(10)
  int productQuantity;
  @HiveField(11)
  String productEnglishTitle;
  @HiveField(12)
  String productEnglishDescription;
  @HiveField(13)
  String productImageURL;
  //String productTags;
  @HiveField(14)
  int discountPercentage;

  ProductLive(
      {this.productID,
        this.createdAt,
        this.updatedAt,
        this.productTitle,
        this.productDescription,
        this.productOriginalPrice,
        this.productPrice,
        this.productBrandID,
        this.productSubcategoryID,
        this.productCategoryID,
        this.productQuantity,
        this.productEnglishTitle,
        this.productEnglishDescription,
        this.productImageURL,
       // this.productTags,
        this.discountPercentage});

  ProductLive.fromJson(Map<String, dynamic> json) {
    productID = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productTitle = json['name'];
    productDescription = json['description'];
    productOriginalPrice = json["price"].toDouble();
    productPrice = json["over_price"].toDouble();
    productBrandID = json['brand_id'];
    productSubcategoryID = json['subCategory_id'];
    productCategoryID = json['category_id'];
    productQuantity = json['qut'];
    //productTags = json['tags'].toString();
    productEnglishTitle = json['name_en'];
    productEnglishDescription = json['description_en'];
    productImageURL = json['img_full_path'];
    discountPercentage = json['precentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.productID;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.productDescription;
    data['description'] = this.productDescription;
    data['price'] = this.productOriginalPrice;
    data['over_price'] = this.productPrice;
    data['brand_id'] = this.productBrandID;
    data['subCategory_id'] = this.productSubcategoryID;
    data['category_id'] = this.productCategoryID;
    data['qut'] = this.productQuantity;
    //data['tags'] = this.productTags;
    data['name_en'] = this.productEnglishTitle;
    data['description_en'] = this.productEnglishDescription;
    data['img_full_path'] = this.productImageURL;
    data['precentage'] = this.discountPercentage;
    return data;
  }
}