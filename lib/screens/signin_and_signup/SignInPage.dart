import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sweet/screens/signin_and_signup/SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'package:sweet/screens/signin_and_signup/forget_password.dart';
import 'package:toast/toast.dart';

import '../../main.dart';

//todo when keyboard opens overflow happens
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  DateTime currentBackPressTime;
  bool _isLoading = false;
  final TextEditingController _phoneControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  loginNow() async {
    try {
      if (_passwordControl.text.trim().isEmpty ||
          _phoneControl.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('completeTheData'),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      } else if (_phoneControl.text.length < 8) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('phoneError'),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      } else if (_passwordControl.text.length < 6 ||
          _passwordControl.text.length > 20) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('passError'),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        final response = await http.post(Uri.parse(APIUrl + "login"), headers: {
          "Accept": "application/json",
          "is_new": "1"
        }, body: {
          "phone": _phoneControl.text,
          "password": _passwordControl.text,
        });
        _isLoading = false;

        //var prif = SharedPreferences.getInstance();

        final data = jsonDecode(response.body);

        if (data["state"] == "1") {
          //SharedPreferences localStorage = await SharedPreferences.getInstance();
          Boxes.getUserDataBox().put("userToken", data['data']['api_token']);
          //HiveMethods.addAPIUserToken(data['data']["api_token"]);
          // localStorage.setString('token', data['data']["api_token"]);
          print(json.encode(data['data']["client"]).toString());
          print("json.encode(data['data'][" "]).toString()");
          Boxes.getUserDataBox().put(
              "userJsonData", json.encode(data['data']['client']).toString());
          //HiveMethods.addApiUserData(json.encode(data['data']["client"]));
          //localStorage.setString('user', json.encode(data['data']["client"]));
          Boxes.getUserDataBox().put("userName",
              json.encode(data['data']['client']['name']).toString());
          //HiveMethods.addUserName(json.encode(data['data']["client"]["name"]));
          Boxes.getUserDataBox().put("userPhone",
              json.encode(data['data']["client"]['phone']).toString());
          //HiveMethods.addUserPhone(json.encode(data['data']["client"]["phone"]));
          //localStorage.setString('user_id', json.encode(data['data']["client"]["id"].toString()));
          Boxes.getUserDataBox().put("userLoginStatus", "2");
          //HiveMethods.addLoginStatus2();
          //localStorage.setString('login', "2");

          return Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return HomeScreen(); //todo was Home(0)
              },
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: '${data["msg"]}',
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
          //01155556624
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
        // _showDialog (data["state"],m);

      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate('noInternet'),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            //padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.close),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 33.w,
                  height: 15.h,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/logo.png",
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Flexible(
                  flex: 8,
                  child: Container(
                    //padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
                    width: 100.w,
                    height: 70.h,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 35, bottom: 30),
                            width: 100.w,
                            height: 62.h,
                            decoration: BoxDecoration(
                              color: brandColor,
                              border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: brandColor),
                              // color: brandColor,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextField(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: usedFont,
                                        fontSize: defaultFontSize - 3,
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: _phoneControl,
                                      showCursor: true,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)
                                            .translate("phoneNumber"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: usedFont,
                                          fontSize: defaultFontSize - 5,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 1.0,
                                              style: BorderStyle.solid),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: defaultIconSize - 5,
                                        ),
                                        fillColor: brandColor,
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: usedFont,
                                          fontSize: defaultFontSize - 5,
                                        ),
                                        hintText: AppLocalizations.of(context)
                                            .translate("enterYourPhone"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    TextField(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: usedFont,
                                        fontSize: defaultFontSize - 3,
                                      ),
                                      controller: _passwordControl,
                                      obscureText: _obscureText,
                                      showCursor: true,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)
                                            .translate("password"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: usedFont,
                                          fontSize: defaultFontSize - 5,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 1.0,
                                              style: BorderStyle.solid),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                          size: defaultIconSize - 5,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: _obscureText
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  size: defaultIconSize,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white,
                                                  size: defaultIconSize,
                                                ),
                                          onPressed: () {
                                            _toggle();
                                          },
                                        ),
                                        fillColor: brandColor,
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: usedFont,
                                          fontSize: defaultFontSize - 5,
                                        ),
                                        hintText: AppLocalizations.of(context)
                                            .translate("enterYourPassword"),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordScreen()));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("forgotYourPassword"),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: usedFont,
                                            fontSize: 14,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.white,
                                                ),
                                                BoxShadow(
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                            child: MaterialButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Color(0xff41f7e2),
                                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("signIn"),
                                                    style: TextStyle(
                                                        fontFamily: usedFont,
                                                        fontSize: 15.sp,
                                                        color: brandColor),
                                                  ),
                                                ),
                                                onPressed: () => {loginNow()}),
                                          ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("don'tHaveAccount"),
                                          style: TextStyle(
                                              fontFamily: usedFont,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpPage()))
                                        },
                                        child: Container(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("signUp"),
                                            style: TextStyle(
                                                fontFamily: usedFont,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 1.6.h,
                            right: 25.w,
                            left: 25.w,
                            child: Container(
                              height: 7.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: brandColor),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color: brandColor),
                                  color: brandColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("signIn"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: usedFont),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class FacebookGoogleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.black12,
                        Colors.black54,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  "Or",
                  style: TextStyle(
                      color: Color(0xFF2c2b2b),
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.black12,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, right: 40.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff416ff7),
                  ),
                  child: Icon(
                    FontAwesomeIcons.facebookF,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () => {},
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFf7418c),
                  ),
                  child: new Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}*/
