import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';

import 'componnent/body.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({Key key}) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: brandColor),
        elevation: 0.0,
        shape: shapeForAppBars(),
        title: Text(AppLocalizations.of(context).translate("address"),
            style: TextStyle(
                fontFamily: usedFont, fontSize: 17.sp, color: brandColor)),
      ),
      body: AddressBody(),
    );
  }
}
