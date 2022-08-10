// ignore_for_file: unused_element, unused_local_variable, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/screens/settings/terms_and_conditions.dart';
import '../../providers/app_localizations.dart';
import 'add_user_delivery_details.dart';
import 'languages_screen.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = "loading...";
  findAppVersion() async {
    final newVersion = NewVersion(
      iOSId: '1582302249',
      androidId: 'com.bluezone.sweet',
    );
    final status = await newVersion.getVersionStatus();
    setState(() {
      appVersion = status.localVersion;
    });
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

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
            style: TextStyle(color: brandColor),
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
          ListTile(
              title: Text(
                AppLocalizations.of(context)
                    .translate("yourDeliveryInformation"),
                style: TextStyle(
                    fontFamily: usedFont, fontSize: 14, color: Colors.black87),
              ),
              leading: Icon(Icons.delivery_dining),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AddUserDeliveryDetails(false)));
              }),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("language"),
              style: TextStyle(
                  fontFamily: usedFont, fontSize: 13.sp, color: Colors.grey),
            ),
            // subtitle: getApiString(
            //     context,
            //     AppLocalizations.of(context).translate("arabic"),
            //     AppLocalizations.of(context).translate("english")),
            leading: Icon(Icons.language),
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
                  fontFamily: usedFont, fontSize: 13.sp, color: Colors.grey),
            ),
            leading: Icon(Icons.description),
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
                padding: const EdgeInsets.only(top: 22, bottom: 0),
                child: Image.asset(
                  'assets/images/bluezone_logo.png',
                  height: 20.h,
                  width: 20.w,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Version: $appVersion',
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                color: brandColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
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

  @override
  void initState() {
    super.initState();
    findAppVersion();
  }
}
