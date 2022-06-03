// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/providers/changeLang.dart';
import 'package:sizer/sizer.dart';

// Base Url test
// ممكن اعمل رن على الاميوليتر؟
/*
final String baseUrl = "https://apitest.myfatoorah.com";
final String mAPIKey = "bearer Tfwjij9tbcHVD95LUQfsOtbfcEEkw1hkDGvUbWPs9CscSxZOttanv3olA6U6f84tBCXX93GpEqkaP_wfxEyNawiqZRb3Bmflyt5Iq5wUoMfWgyHwrAe1jcpvJP6xRq3FOeH5y9yXuiDaAILALa0hrgJH5Jom4wukj6msz20F96Dg7qBFoxO6tB62SRCnvBHe3R-cKTlyLxFBd23iU9czobEAnbgNXRy0PmqWNohXWaqjtLZKiYY-Z2ncleraDSG5uHJsC5hJBmeIoVaV4fh5Ks5zVEnumLmUKKQQt8EssDxXOPk4r3r1x8Q7tvpswBaDyvafevRSltSCa9w7eg6zxBcb8sAGWgfH4PDvw7gfusqowCRnjf7OD45iOegk2iYSrSeDGDZMpgtIAzYVpQDXb_xTmg95eTKOrfS9Ovk69O7YU-wuH4cfdbuDPTQEIxlariyyq_T8caf1Qpd_XKuOaasKTcAPEVUPiAzMtkrts1QnIdTy1DYZqJpRKJ8xtAr5GG60IwQh2U_-u7EryEGYxU_CUkZkmTauw2WhZka4M0TiB3abGUJGnhDDOZQW2p0cltVROqZmUz5qGG_LVGleHU3-DgA46TtK8lph_F9PdKre5xqXe6c5IYVTk4e7yXd6irMNx4D4g1LxuD8HL4sYQkegF2xHbbN8sFy4VSLErkb9770-0af9LT29kzkva5fERMV90w";
*/
final String baseUrl = "https://api.myfatoorah.com";
final String mAPIKey =
    "nRS9cPOyz5TdRb42N-t-Q8ALM2YYVpDceW8iHt7dQaIDUJY2A4rzjyNv7SENb9jwpy4o7Lx5TdqB-57PaOg2SxNYjuwUoBuTYHLY9BiT9BH0nY5DDh-wRM3aqRGb8u6Fncwz2BpjsHBaTBG_4eFrCYcO_Ahf-piQ-npnSwkXSN79zGXzvPgWU23S9-lNvQCghQrs3TAlKl1oIfkiyFWrxDK2zfKXNcSj_zB_I7wlTuiNAuLGyEranGpAkZ1o75cCbp04ufN52ydu_WwfUKgaIkFecnTooBYF_7LC979KyJo6JnHOvn3Mcby_DqWzUY434zZohsqqMzfHijNLSC2CbtzAyuVb7LHMk5n2U5NcvXiAhLUTuCGA-AFcuok6HJQ6cHfhw76C9NtvDr6Mj_JogkZruj-DZvKiZoHyD_l065_MKOTKNKUQ4-yufg-Qz43eQ92PmZ8D7hTDotp4-MDoshXsVFSkwwZ9OllwdgcVMhgpx7Tg5nv8ou5IPkvtCp0mFhgu7O17eUMxWkpjSFzmGoqahWb5LEs2Mmlgg313c1C3299vvG4Ki2LtBpdkhiQNWpzbC2Ex4BMJbZodX_dC1D6d4h4_6cm-V5k9sf9NFv_6pOym0BP11JZxWkAJ6g5QNfvo6umQoQv00zD8tfytKbLCpTycff8nvZFf8TeDM9neNryy";
// final String urlTest = "https://apitest.myfatoorah.com";
// final String mApiKeyTest =
//     "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
const String APIUrl =
// "https://rayan.openshoop.com/api/v1/";
    "https://sweeeth.com/api/v1/";
const String usedFont = "Cairo";
const Color brandColor = Color(0xFF00ABFE);
Color brandColor100 = Colors.blueAccent[100];
Color scaffoldBgColor = Color(0xFFF4F4F4);
Color primaryColor = Color(0xFFF2647C);
Color callColor = Color(0xFF72F264);
Color darkPrimaryColor = Color(0xFFCA445D);
Color tabsBarColor = Color(0xFF444BCA);
Color greyColor = Colors.grey;
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color lightGreyColor = Colors.grey.withOpacity(0.3);

double fixPadding = 10.sp;
double defaultFontSize = 17.sp;
double defaultIconSize = 17.sp;
SizedBox heightSpace = SizedBox(height: 10.0);
SizedBox widthSpace = SizedBox(width: 10.0);

TextStyle bottomBarItemStyle = TextStyle(
  color: greyColor,
  fontSize: 12.0,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle bigHeadingStyle = TextStyle(
  fontSize: 22.0,
  color: blackColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w600,
);

TextStyle headingStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle greyHeadingStyle = TextStyle(
  fontSize: 16.0,
  color: greyColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle blueTextStyle = TextStyle(
  fontSize: 18.0,
  color: brandColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w400,
);

TextStyle whiteHeadingStyle = TextStyle(
  fontSize: 22.0,
  color: whiteColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle whiteSubHeadingStyle = TextStyle(
  fontSize: 14.0,
  color: whiteColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.normal,
);

TextStyle wbuttonWhiteTextStyle = TextStyle(
  fontSize: 16.0,
  color: whiteColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle buttonBlackTextStyle = TextStyle(
  fontSize: 16.0,
  color: blackColor,
  fontFamily: usedFont,
  fontWeight: FontWeight.w500,
);

TextStyle moreStyle = TextStyle(
  fontSize: 14.0,
  color: primaryColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

TextStyle priceStyle = TextStyle(
  fontSize: 18.0,
  color: primaryColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
);

TextStyle timeStyle = TextStyle(
  fontSize: 16.0,
  color: primaryColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
);

TextStyle countStyle = TextStyle(
  fontSize: 16.0,
  color: primaryColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
);

TextStyle lightGreyStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.grey.withOpacity(0.6),
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

// List Item Style Start
TextStyle listItemTitleStyle = TextStyle(
  fontSize: 15.0,
  color: blackColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);
TextStyle listItemSubTitleStyle = TextStyle(
  fontSize: 14.0,
  color: greyColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.normal,
);

TextStyle listItemSupervisorStyle = TextStyle(
  fontSize: 12.0,
  color: greyColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.normal,
);
TextStyle listItemContactStyle = TextStyle(
  fontSize: 12.0,
  color: greyColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.normal,
);
// List Item Style End

// AppBar Style Start
TextStyle appbarHeadingStyle = TextStyle(
  color: darkPrimaryColor,
  fontSize: 14.0,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);
TextStyle appbarSubHeadingStyle = TextStyle(
  color: whiteColor,
  fontSize: 13.0,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

RoundedRectangleBorder shapeForAppBars() {
  return RoundedRectangleBorder(
    side: BorderSide(
      width: 2,
      color: brandColor,
      style: BorderStyle.solid,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(20.0),
    ),
  );
}
// AppBar Style End

// Search text style start
TextStyle searchTextStyle = TextStyle(
  color: whiteColor.withOpacity(0.6),
  fontSize: 16.0,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);
showDialogBox(title, body, context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(
          title,
          style: TextStyle(
              color: brandColor,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont),
        ),
        content: new Text(
          body,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: usedFont),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              AppLocalizations.of(context).translate("close"),
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: usedFont),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

dynamic getApiString(
  BuildContext context,
  var arabicTerm,
  var englishTerm,
) {
  String lang = Provider.of<AppLanguage>(context, listen: false).lang;
  if (lang == "en") {
    return englishTerm;
  } else
    return arabicTerm;
}

getAlert(BuildContext context, AlertType alertType, String title, String desc,
    String positiveButton, Widget widget, String negativeButton) {
  Alert(
    context: context,
    type: alertType,
    style: AlertStyle(
      titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: usedFont,
          color: Colors.indigo),
      descStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: usedFont),
    ),
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        child: Text(
          positiveButton,
          style: TextStyle(
              color: Colors.white,
              fontFamily: usedFont,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => widget));
        },
        color: brandColor,
      ),
      DialogButton(
        child: Text(
          negativeButton,
          style: TextStyle(
              color: Colors.white,
              fontFamily: usedFont,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.grey,
      ),
    ],
  ).show();
}



// Search text style end

// Search History text style start

// Search History text style End
