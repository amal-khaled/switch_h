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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/icons/logo.png",
                width: 30.w,
                height: 20.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Text(
              AppLocalizations.of(context).translate("select_lang"),
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: usedFont,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      width: 35.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: (languageIndex == 0) ? titleColor : Colors.white,
                        border: Border.all(color: titleColor),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Center(
                        child: Text(
                          "English",
                          style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 13.sp,
                            color: (languageIndex == 0)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Boxes.getUserDataBox().put("userLang", "en");
                      //HiveMethods.addUserLang("en");
                      // setLanguage("en");
                      changeLanguage(0);
                      Provider.of<AppLanguage>(context, listen: false)
                          .changeLanguage(Locale('en'));
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: 35.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: (languageIndex == 1) ? titleColor : Colors.white,
                        border: Border.all(color: titleColor),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Center(
                        child: Text(
                          "اللغة العربية",
                          style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 13.sp,
                            color: (languageIndex == 1)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
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
