import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sizer/sizer.dart';
import 'package:sweet/providers/changeLang.dart';
import '../../constants.dart';
import '../../providers/app_localizations.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;
/*  setLanguage(lang) async {

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', lang);
  }*/

  @override
  void initState() {
    super.initState();
    getLanguageIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          shape: shapeForAppBars(),
          iconTheme: IconThemeData(color: brandColor),
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("language"),
            style: TextStyle(
                fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
          )),
      body: ListView(
        children: [
          Column(children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate("english"),
                style: TextStyle(
                    fontFamily: usedFont,
                    fontSize: 13.sp,
                    color: Colors.black87),
              ),
              trailing: trailingWidget(0),
              onTap: () {
                Boxes.getUserDataBox().put("userLang", "en");
                //HiveMethods.addUserLang("en");
                // setLanguage("en");
                changeLanguage(0);
                Provider.of<AppLanguage>(context, listen: false)
                    .changeLanguage(Locale('en'));
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate("arabic"),
                style: TextStyle(
                    fontFamily: usedFont,
                    fontSize: 13.sp,
                    color: Colors.black87),
              ),
              trailing: trailingWidget(1),
              onTap: () {
                Boxes.getUserDataBox().put("userLang", "ar");
                //HiveMethods.addUserLang("ar");
                //setLanguage("ar");
                changeLanguage(1);
                Provider.of<AppLanguage>(context, listen: false)
                    .changeLanguage(Locale('ar'));
              },
            )
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: brandColor)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }

  getLanguageIndex() async {
    //var prefs = await SharedPreferences.getInstance();
    var userLang = Boxes.getUserDataBox().get('userLang');

    //if (prefs.getString('language_code') == "en")
    if (userLang == "en")
      changeLanguage(0);
    else
      changeLanguage(1);
  }
}
