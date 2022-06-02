



import 'package:flutter/material.dart';
import 'package:sweet/local_data/boxes.dart';

class AppLanguage extends ChangeNotifier {
  Locale appLocale ; //todo change to ar
  String lang;

  fetchLocale() async {
    //var prefs = await SharedPreferences.getInstance();
    if (Boxes.getUserDataBox().get("userLang")==null) {

      lang = "ar"; //todo change to ar
      await Boxes.getUserDataBox().put("userLang",lang);
      appLocale = Locale(lang); //todo change to ar
    } else {
      lang =  Boxes.getUserDataBox().get("userLang");

      appLocale = Locale(lang);
    }
    notifyListeners();
  }
  void changeLanguage(Locale locale) async {
   // var prefs = await SharedPreferences.getInstance();
    if (appLocale == locale) {
      return;
    }
    if (locale == Locale("en")) {

      lang = "en";
      appLocale = Locale(lang);
      await Boxes.getUserDataBox().put("userLang",lang);
      //HiveMethods.addUserLang(lang);
      // await prefs.setString('countryCode', 'US');
    }

    if (locale == Locale("ar")) {

      lang = "ar";
      appLocale = Locale(lang);
      await Boxes.getUserDataBox().put("userLang",lang);
      //HiveMethods.addUserLang(lang);
      // await prefs.setString('countryCode', '');
    }
    notifyListeners();
  }
}
