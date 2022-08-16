// ignore_for_file: unused_element, unused_local_variable, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/screens/settings/terms_and_conditions.dart';
import '../../providers/app_localizations.dart';
import '../../providers/home_provider.dart';
import 'languages_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // String appVersion = "loading...";
  // findAppVersion() async {
  //   final newVersion = NewVersion(
  //     iOSId: '1582302249',
  //     androidId: 'com.bluezone.sweet',
  //   );
  //   final status = await newVersion.getVersionStatus();
  //   setState(() {
  //     appVersion = status.localVersion;
  //   });
  // }

  // Future<void> _launchInWebViewOrVC(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: true,
  //       forceWebView: true,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shape: shapeForAppBars(),
          iconTheme: IconThemeData(
            color: brandColor, //change your color here
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("settings"),
            style: TextStyle(
              color: titleColor,
              fontFamily: usedFont,
            ),
          )),
      body: buildSettingsList(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildSettingsList() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          // ListTile(
          //     title: Text(
          //       AppLocalizations.of(context)
          //           .translate("yourDeliveryInformation"),
          //       style: TextStyle(
          //           fontFamily: usedFont, fontSize: 14, color: Colors.black87),
          //     ),
          //     leading: Icon(Icons.delivery_dining),
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (_) => AddUserDeliveryDetails(false)));
          //     }),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("language"),
              style: TextStyle(
                fontFamily: usedFont,
                fontSize: 13.sp,
                color: titleColor,
              ),
            ),
            // subtitle: getApiString(
            //     context,
            //     AppLocalizations.of(context).translate("arabic"),
            //     AppLocalizations.of(context).translate("english")),
            leading: Icon(
              Icons.language,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LanguagesScreen(),
              ));
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("termsAndConditions"),
              style: TextStyle(
                fontFamily: usedFont,
                fontSize: 13.sp,
                color: titleColor,
              ),
            ),
            leading: Icon(
              Icons.description,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TermsAndConditions(),
              ));
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Image.asset(
                  'assets/images/bluezone_logo.png',
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: RichText(
                      text: TextSpan(
                        text: "Powered by BlueZone",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            String toLaunch = 'https://bluezonekw.com/';
                          },
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 12.sp,
                            color: titleColor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            launch("https://www.facebook.com/" +
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .settingList[0]
                                    .fbLink);
                          },
                          child: Image.asset(
                            "assets/icons/facebook-logo.png",
                            color: titleColor,
                            fit: BoxFit.contain,
                            width: 10.w,
                            height: 10.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch('https://instagram.com/' +
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .settingList[0]
                                    .instaLink);
                          },
                          child: Image.asset(
                            "assets/icons/instagram.png",
                            color: titleColor,
                            fit: BoxFit.contain,
                            width: 10.w,
                            height: 10.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch("https://www.linkedin.com/in/bluezoneweb");
                          },
                          child: Image.asset(
                            "assets/icons/linkedin.png",
                            color: titleColor,
                            fit: BoxFit.contain,
                            width: 10.w,
                            height: 10.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch('https://twitter.com/' +
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .settingList[0]
                                    .twLink);
                          },
                          child: Image.asset(
                            "assets/icons/twitter.png",
                            color: titleColor,
                            fit: BoxFit.contain,
                            width: 10.w,
                            height: 10.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
//     SettingsList(
//       backgroundColor: Colors.white,
//       sections: [
//         SettingsSection(
//           title: AppLocalizations.of(context).translate("common"),
//           titleTextStyle: TextStyle(
//               fontFamily: usedFont, fontSize: 14, color: Colors.black87),
//           tiles: [
// /*            SettingsTile(
//               title: AppLocalizations.of(context)
//                   .translate("yourDeliveryInformation"),
//               leading: Icon(Icons.delivery_dining),
//               onPressed: (context) {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => SavedUserInformation()));
//               },
//             ),*/
//             SettingsTile(
//               titleTextStyle: TextStyle(
//                   fontFamily: usedFont, fontSize: 13.sp, color: Colors.grey),
//               title: AppLocalizations.of(context).translate("language"),
//               subtitleTextStyle: TextStyle(
//                   fontFamily: usedFont, fontSize: 12, color: Colors.grey),
//               subtitle: getApiString(
//                   context,
//                   AppLocalizations.of(context).translate("arabic"),
//                   AppLocalizations.of(context).translate("english")),
//               leading: Icon(Icons.language),
//               onPressed: (context) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => LanguagesScreen(),
//                 ));
//               },
//             ),
//           ],
//         ),
//         SettingsSection(
//           title: AppLocalizations.of(context).translate("sweet"),
//           titleTextStyle: TextStyle(
//               fontFamily: usedFont, fontSize: 14, color: Colors.black87),
//           tiles: [
//             SettingsTile(
//               title:
//                   AppLocalizations.of(context).translate("termsAndConditions"),
//               titleTextStyle: TextStyle(
//                   fontFamily: usedFont, fontSize: 13.sp, color: Colors.grey),
//               leading: Icon(Icons.description),
//               onPressed: (context) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => TermsAndConditions(),
//                 ));
//               },
//             ),
//             /* SettingsTile(
//               title: AppLocalizations.of(context).translate("privacyPolicy"),
//               leading: Icon(Icons.policy),
//               onPressed: (context) {
//                 Future<void> _launched;
//                 String toLaunch = 'https://www.google.com/';
//                 _launched = _launchInWebViewOrVC(toLaunch);
//               },
//             ),*/
//           ],
//         ),
//         CustomSection(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 22, bottom: 0),
//                 child: Image.asset(
//                   'assets/images/bluezone_logo.png',
//                   height: 20.h,
//                   width: 20.w,
//                   alignment: Alignment.bottomCenter,
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Version: $appVersion',
//                         style: TextStyle(
//                             fontFamily: usedFont,
//                             fontSize: 14,
//                             color: Colors.grey),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: RichText(
//                           text: TextSpan(
//                             text: "Powered by BlueZone",
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 String toLaunch = 'https://bluezonekw.com/';
//                                 _launched = _launchInWebViewOrVC(toLaunch);
//                               },
//                             style: TextStyle(
//                                 fontFamily: usedFont,
//                                 fontSize: 12.sp,
//                                 color: brandColor,
//                                 decoration: TextDecoration.underline),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ), /*Text(
//                 'Version: 1.0.0\nPowered by BlueZone',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: brandColor),
//               )*/
//             ],
//           ),
//         ),
//       ],
    // );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   findAppVersion();
  // }
}
