import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share/share.dart';
import 'package:sweet/providers/changeLang.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sweet/real_api/real_categories.dart';
import 'package:sweet/real_api/real_products.dart';
import 'package:sweet/screens/brands_screen/brands_screen.dart';
import 'package:sweet/screens/cart/cart_icon.dart';
import 'package:sweet/screens/categories_screen/categories_screen.dart';
import 'package:sweet/screens/home_screen/home_screen_categories.dart';
import 'package:sweet/screens/home_screen/brands_h_list.dart';
import 'package:sweet/screens/home_screen/slider_listview.dart';
import 'package:sweet/screens/orders/orders.dart';
import 'package:sweet/screens/settings/add_user_delivery_details.dart';
import 'package:sweet/screens/splash/splashScreen.dart';
import 'constants.dart';
import 'custom_animation.dart';
import 'local_data/boxes.dart';
import 'providers/app_localizations.dart';
import 'widgets/contact_us.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/signin_and_signup/SignInPage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductLiveAdapter());

  await Hive.openBox<int>('localCartItems');
  await Hive.openBox<String>('userData');
  await Hive.openBox<ProductLive>('localCartItemsObject');

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

/*  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);*/
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        /*ChangeNotifierProvider(create: (context) => AppStateNotifier()),*/
      ],
      child: MyApp(
        locale: appLanguage,
      )));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = brandColor.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  AppLanguage locale;

  MyApp({this.locale});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => locale,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData(unselectedWidgetColor: Colors.white),
            debugShowCheckedModeBanner: false,
            locale: model.appLocale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ar', 'AR'),
              Locale('en', 'US'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
// Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode ==
                        locale
                            .languageCode /*&&
                supportedLocale.countryCode == locale.countryCode*/
                    ) {
                  return supportedLocale;
                }
              }
// If the locale of the device is not supported, use the first one
// from the list (English, in this case).
              return supportedLocales.first;
            },
            title: "Sweet H",
//home: OnBoardScreen(),
            home: SplashScreen(),
            builder: EasyLoading.init(),
          );
        });
      }),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<CategoryLive> categoriesListLive;
  HomeScreen({Key key, this.categoriesListLive}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool stillClearing = false;
  List<int> localCartItemsList = [];

  share(BuildContext context, String packageName) {
    final RenderBox box = context.findRenderObject();

    Share.share(packageName,
        subject: "Sweet H :",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<PackageInfo> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  Future<PackageInfo> getPackageNameInFutureFormat() async {
    return _getPackageInfo().then((PackageInfo pi) => pi);
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUpdates();
    checkLogin();
  }

  checkLogin() async {
    if (Boxes.getUserDataBox().get("userLoginStatus") == null) {
      Boxes.getUserDataBox().put("userLoginStatus", "1");
    } else {
      print("login status: " + Boxes.getUserDataBox().get("userLoginStatus"));
    }
  }

  checkUpdates() async {
    final newVersion = NewVersion(
      iOSId: '1582302249',
      androidId: 'com.bluezone.sweet',
    );
    final status = await newVersion.getVersionStatus();
    if (status.localVersion != status.storeVersion) {
      //debugPrint(status.releaseNotes);
      //debugPrint(status.appStoreLink);
      //debugPrint(status.localVersion);
      //debugPrint(status.storeVersion);
      //debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        allowDismissal: false,
        context: context,
        versionStatus: status,
        dialogTitle: AppLocalizations.of(context).translate("urgentUpdate"),
        dialogText: AppLocalizations.of(context).translate("shouldUpdate"),
      );
      //newVersion.showAlertIfNecessary(context: context);
    }
/*    const simpleBehavior = false;
    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }*/
  }
/*  basicStatusCheck(NewVersion newVersion) {

  }*/

  clearUserDate() {
    Boxes.getUserDataBox().put("userLoginStatus", "1");
    Boxes.getUserDataBox().put("userDeliveryPrice", null);
    Boxes.getUserDataBox().put("userGovern", null);
    Boxes.getUserDataBox().put("userRegion", null);
    Boxes.getUserDataBox().put("userGovernID", null);
    Boxes.getUserDataBox().put("userJsonData", null);
    Boxes.getUserDataBox().put("userName", null);
    Boxes.getUserDataBox().put("userPhone", null);
    Boxes.getUserDataBox().put("userAddress", null);
  }

  //var homeScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          return true;
        },
        child: Scaffold(
          key: homeScaffoldKey,
          backgroundColor: Colors.blueGrey[50],
          drawer: SafeArea(
            child: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                        /*child: Text(
                        "sdf",
                        textAlign: TextAlign.center,
                      ),*/
                        ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/logo.png"),
                          scale: 5,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.dst)),
                      color: Colors.white,
                    ),
                  ),
                  Boxes.getUserDataBox().get("userLoginStatus") == "2"
                      ? ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: brandColor,
                          ),
                          title: Text(
                            AppLocalizations.of(context).translate("logout"),
                            style: TextStyle(
                                fontFamily: usedFont,
                                fontSize: 12.sp,
                                color: Colors.black54),
                          ),
                          onTap: () {
                            clearUserDate();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        )
                      : stillClearing
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListTile(
                              leading: Icon(
                                Icons.person,
                                color: brandColor,
                              ),
                              title: Text(
                                AppLocalizations.of(context).translate("login"),
                                style: TextStyle(
                                    fontFamily: usedFont,
                                    fontSize: 12.sp,
                                    color: Colors.black54),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()));
                              },
                            ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate("yourDeliveryInformation"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AddUserDeliveryDetails(
                                false,
                              )));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.category,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("categories"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesGridView()));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.branding_watermark,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("brands"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrandsGridView()));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.delivery_dining,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("myOrders"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Order()));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("settings"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    },
                  ),
                  Divider(),
                  FutureBuilder<PackageInfo>(
                      future: getPackageNameInFutureFormat(),
                      builder: (BuildContext context,
                          AsyncSnapshot<PackageInfo> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.hasData) {
                          return ListTile(
                              title: Text(
                                AppLocalizations.of(context).translate("share"),
                                style: TextStyle(
                                    fontFamily: usedFont,
                                    fontSize: 12.sp,
                                    color: Colors.black54),
                              ),
                              leading: Icon(
                                Icons.share,
                                color: brandColor,
                              ),
                              onTap: () {
                                share(
                                    context,
                                    'اهلا بك تستطيع تحميل Sweet H من خلال الرابط: \n https://play.google.com/store/apps/details?'
                                            'id=' +
                                        snapshot.data.packageName);
                                Navigator.pop(context);
                              });
                        } else
                          return Container(
                              height: 1.h,
                              width: 1.w,
                              child: CircularProgressIndicator());
                        //handle other connection statuses
                      }),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.contact_phone,
                      color: brandColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("contactUs"),
                      style: TextStyle(
                          fontFamily: usedFont,
                          fontSize: 12.sp,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      showDialog();
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            shape: shapeForAppBars(),
            iconTheme: IconThemeData(color: brandColor),
            centerTitle: true,
            title: Text(
              'Sweet H',
              style: TextStyle(
                  fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
/*          leading: IconButton(
              icon: const Icon(Icons.menu, size: 30, color: brandColor),
              onPressed: () {
                _controller.toggle();
              },
            ),*/
            actions: <Widget>[
              CartIcon(
                key: ValueKey("CartIconKey"),
              ),
              SizedBox(width: fixPadding)
            ],
            leading: Builder(
                builder: (context) => // Ensure Scaffold is in context
                    IconButton(
                        icon: ImageIcon(
                          AssetImage("assets/icons/menu.png"),
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer())),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: 100.w, height: 28.h, child: HomeSliderListView()),
                BrandsInHList(),
                HomeScreenCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 600,
            child: SizedBox.expand(child: ContactSweet()),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
