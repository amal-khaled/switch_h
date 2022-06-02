import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:sweet/real_api/real_products.dart';
import 'boxes.dart';

class HiveMethods {
/*   static Future addUserLang(String lang) async {
     final userLang = LocalUserData()
       ..userLang = lang;

     final box = Boxes.getUserLangBox();
     box.clear();
     box.add(userLang);
   }*/

  static addProductToLocalCartItemObject(
      BuildContext context, ProductLive productLive, int count) {
    final box = Boxes.getLocalCartItemsObjectBox();
    box.put(productLive.productID, productLive);
    final box1 = Boxes.getLocalCartItemsBox();
    int oldCount = box1.get(productLive.productID) ?? 0;
    box1.put(productLive.productID, count + oldCount);
    setTotalPrice(context);
  }

/*   static addProductToLocalCartItem(BuildContext context,int productID, int count) {
     final box1 = Boxes.getLocalCartItemsBox();
     int oldCount =box1.get(productID)??0;
     box1.put(productID, count+oldCount);
     setTotalPrice(context);
   }*/

/*  static setTotalPriceObject(BuildContext context) {
     double total = 0.0;
     if (Boxes.getLocalCartItemsObjectBox().keys == null) {
       //totalInCart = total;
       Boxes.getUserDataBox().put("totalInCart", 0.0.toString());

     } else {
       for (int i = 0; i < Boxes.getLocalCartItemsObjectBox().keys.length; i++) {
         total += Provider.of<HomeProvider>(context, listen: false).productIDToProduct[Boxes.getLocalCartItemsObjectBox().keys.toList()[i]].productPrice * Boxes.getLocalCartItemsBox().getAt(i);
       }
       Boxes.getUserDataBox().put("totalInCart", total.toString());
     }
   }*/

  static setTotalPrice(BuildContext context) {
    double total = 0.0;
    if (Boxes.getLocalCartItemsBox().keys == null ||
        Boxes.getLocalCartItemsBox().isEmpty) {
      //totalInCart = total;
      Boxes.getUserDataBox().put("totalInCart", 0.0.toString());
    } else {
      for (int i = 0; i < Boxes.getLocalCartItemsBox().keys.length; i++) {
        total += Boxes.getLocalCartItemsObjectBox()
                .get(Boxes.getLocalCartItemsBox().keyAt(i))
                .productPrice *
            Boxes.getLocalCartItemsBox().getAt(i);
      }
      Boxes.getUserDataBox().put("totalInCart", total.toString());
    }
  }

  static String createCryptoRandomString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
}
