import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/local_data/hive_methods.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/load_data.dart';
import 'package:sweet/real_api/offers.dart';
import 'package:sweet/real_api/real_brands.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/real_api/setting.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading;
  LoadData api;
  List<CategoryLive> categoriesList = [];

  List<Setting> settingList = [];

  List<OffersLive> offersList = [];
  List<BrandsLive> brandsList = [];
  Map<String, List<int>> categoryEnglishNameToSubcategoriesIDsMap = {};
  Map<String, List<int>> categoryArabicNameToSubcategoriesIDsMap =
      {}; //for arabic
  Map<String, List<String>> categoryEnglishNameToSubcategoriesEnglishNamesMap =
      {};
  Map<String, List<String>> categoryArabicNameToSubcategoriesArabicNamesMap =
      {}; //for arabic
  Map<int, List<int>> categoryIDToSubcategoriesIDsMap = {};
  Map<int, List<String>> categoryIDToSubcategoriesEnglishNamesMap = {};
  Map<int, List<String>> categoryIDToSubcategoriesArabicNamesMap =
      {}; //for arabic

  //List<List<ProductLive>> productsListLive = [];
  //List<BrandLive> brands;
  //List<SliderLive> sliders;
  myTimer(bool isLoading) {
    Timer(const Duration(seconds: 3), () {
      if (isLoading == true) {
        EasyLoading.show(status: 'load.......');
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  tokenCheck() async {
    if (Boxes.getUserDataBox().get("userToken") == null) {
      await Boxes.getUserDataBox()
          .put("userToken", HiveMethods.createCryptoRandomString());
      print("token granted for first time: " +
          Boxes.getUserDataBox().get("userToken"));
    } else {
      print("token was granted: " + Boxes.getUserDataBox().get("userToken"));
    }
  }

  getData() async {
    try {
/*      final response = await http.get(Uri.parse(APIUrl + "categories"));
      if (jsonDecode(response.body)["state"] == "1") {*/
      var data = await api.getData(
          link: "${APIUrl}categories", type: "list", call: "get");

      if (data != null) {
        data["categories"].forEach((element) {
          categoriesList.add(CategoryLive.fromJson(element));
        });
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoriesList(categoriesList);
        data["categories"].forEach((element) {
          List<int> subcategoriesIDsList = [];
          List<String> subcategoriesEnglishNamesList = [];
          List<String> subcategoriesArabicNamesList = []; //for arabic

          for (int i = 0;
              i < CategoryLive.fromJson(element).subcategoriesList.length;
              i++) {
            // if(Provider.of<HomeProvider>(context, listen: false).subcategoriesIDsListThatHasProducts.contains(CategoryLive.fromJson(element).subcategoriesList[i].subcategoryID)) {
            subcategoriesIDsList.add(CategoryLive.fromJson(element)
                .subcategoriesList[i]
                .subcategoryID);
            subcategoriesEnglishNamesList.add(CategoryLive.fromJson(element)
                .subcategoriesList[i]
                .subcategoryNameEn);
            subcategoriesArabicNamesList.add(CategoryLive.fromJson(element)
                .subcategoriesList[i]
                .subcategoryName);
            //}
          }
          categoryEnglishNameToSubcategoriesIDsMap[
                  CategoryLive.fromJson(element).categoryEnglishTitle] =
              subcategoriesIDsList;
          categoryArabicNameToSubcategoriesIDsMap[CategoryLive.fromJson(element)
              .categoryTitle] = subcategoriesIDsList;

          categoryEnglishNameToSubcategoriesEnglishNamesMap[
                  CategoryLive.fromJson(element).categoryEnglishTitle] =
              subcategoriesEnglishNamesList;
          categoryArabicNameToSubcategoriesArabicNamesMap[
                  CategoryLive.fromJson(element).categoryTitle] =
              subcategoriesArabicNamesList;

          categoryIDToSubcategoriesIDsMap[
              CategoryLive.fromJson(element).categoryID] = subcategoriesIDsList;
          categoryIDToSubcategoriesEnglishNamesMap[
                  CategoryLive.fromJson(element).categoryID] =
              subcategoriesEnglishNamesList;
          categoryIDToSubcategoriesArabicNamesMap[CategoryLive.fromJson(element)
              .categoryID] = subcategoriesArabicNamesList;
          // offersList.add(CategoryLive.fromJson(element));
        });

        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryEnglishNameToSubcategoriesIDsMap(
                categoryEnglishNameToSubcategoriesIDsMap);
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryArabicNameToSubcategoriesIDsMap(
                categoryArabicNameToSubcategoriesIDsMap); //for arabic
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryEnglishNameToSubcategoriesEnglishNamesMap(
                categoryEnglishNameToSubcategoriesEnglishNamesMap);
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryArabicNameToSubcategoriesArabicNamesMap(
                categoryArabicNameToSubcategoriesArabicNamesMap); //for arabic
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryIDToSubcategoriesEnglishNamesMap(
                categoryIDToSubcategoriesEnglishNamesMap);
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryIDToSubcategoriesArabicNamesMap(
                categoryIDToSubcategoriesArabicNamesMap); //for arabic
        Provider.of<HomeProvider>(context, listen: false)
            .setCategoryIDToSubcategoriesIDsMap(
                categoryIDToSubcategoriesIDsMap);

        data["sliders"].forEach((element) {
          offersList.add(OffersLive.fromJson(element));
        });
        Provider.of<HomeProvider>(context, listen: false)
            .setOffersList(offersList);

        data["brands"].forEach((element) {
          brandsList.add(BrandsLive.fromJson(element));
        });
        Provider.of<HomeProvider>(context, listen: false)
            .setBrandsList(brandsList);

        settingList.add(Setting.fromJson(data["setting"]));
        Provider.of<HomeProvider>(context, listen: false)
            .setSetting(settingList);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.info,
        style: AlertStyle(
          titleStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont,
              color: Colors.indigo),
          descStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont),
        ),
        title: AppLocalizations.of(context).translate("networkError"),
        desc: AppLocalizations.of(context).translate("networkErrorMSG"),
        buttons: [
          DialogButton(
            child: Text(
              AppLocalizations.of(context).translate("reload"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: usedFont,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            color: Colors.lightBlue,
          ),
        ],
      ).show();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    tokenCheck();
    myTimer(isLoading);
    api = new LoadData(context);
    getData();

    /*Timer(Duration(seconds: 6), () {});*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
