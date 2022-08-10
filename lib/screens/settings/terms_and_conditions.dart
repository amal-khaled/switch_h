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
        title: Text(
          AppLocalizations.of(context).translate("termsAndConditions"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
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
                        fontFamily: usedFont, fontSize: 12, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
