import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/providers/home_provider.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context).translate("termsAndConditions"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: getApiString(
                    context,
                    Provider.of<HomeProvider>(context, listen: false)
                        .settingList[0]
                        .strategy,
                    Provider.of<HomeProvider>(context, listen: false)
                        .settingList[0]
                        .strategyEn),
                style: TextStyle(
                  fontFamily: usedFont,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
