// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'SignInPage.dart';

//todo when keyboard opens overflow happens
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final TextEditingController _phoneControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  final TextEditingController _nameControl = new TextEditingController();

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  loginNow() async {}
  signUp() async {
    final tok = Boxes.getUserDataBox().get("userToken");
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var tok = localStorage.getString('token');
    if (tok != null) {
      try {
        if (_passwordControl.text.trim().isEmpty ||
            _phoneControl.text.trim().isEmpty ||
            _nameControl.text.trim().isEmpty) {
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
        } else if (_nameControl.text.length < 4) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('nameError'),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else if (_nameControl.text.length > 30) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('nameError'),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else if (_passwordControl.text.length < 6 ||
            _passwordControl.text.length > 20) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                .translate('passwordLengthShouldBeBetween6and20'),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else {
          if (this.mounted) {
            setState(() {
              _isLoading = true;
            });
          }
          final response =
              await http.post(Uri.parse(APIUrl + "register"), headers: {
            "Accept": "application/json"
          }, body: {
            "phone": _phoneControl.text,
            "password": _passwordControl.text,
            "name": _nameControl.text,
            "code": "965",
            "country": "الكويت",
            "activity": "1",
            "token": tok.toString()
          });

          //var prif = SharedPreferences.getInstance();

          final data = jsonDecode(response.body);
          if (response.statusCode == 200) {
            if (data["state"] == "1") {
              // SharedPreferences localStorage = await SharedPreferences.getInstance();
              Boxes.getUserDataBox().put("userLoginStatus", '1');
              // localStorage.setString('login', "1");
              Boxes.getUserDataBox()
                  .put("userToken", data['data']["api_token"]);
              // localStorage.setString('token', data['data']["api_token"]);
              Boxes.getUserDataBox().put("userJsonData",
                  json.encode(data['data']["client"]).toString());
              Boxes.getUserDataBox().put("userName",
                  json.encode(data['data']["client"]["name"]).toString());
              Boxes.getUserDataBox().put("userPhone",
                  json.encode(data['data']["client"]["phone"]).toString());
              //localStorage.setString('user', json.encode(data['data']["client"]));
              /*var user =  "kckkkkrkfrkkk";
                var phone = jsonDecode(user)["phone"];*/
              return Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomeScreen();
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
          } else {}
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('noInternet'),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("reOpenTheApp"),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
    }
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
    ToastContext().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            //padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
            height: MediaQuery.of(context).size.height,
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Container(
                  height: 26.h,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage("assets/images/women_find.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2.h,
                        left: 2.w,
                        child: InkWell(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Icon(Icons.close),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
                  width: 100.w,
                  height: 74.h,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 35, bottom: 30),
                          width: 100.w,
                          height: 69.h,
                          decoration: BoxDecoration(
                            color: brandColor,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: brandColor),
                            // color: brandColor,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
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
                                    controller: _nameControl,
                                    showCursor: true,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate("userName"),
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
                                        Icons.person,
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
                                          .translate("enterYourName"),
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
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                            size: defaultIconSize,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate("useCombination"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: usedFont,
                                              fontSize: defaultFontSize - 7,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      )),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 20.0),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate("signUp"),
                                                  style: TextStyle(
                                                      fontFamily: usedFont,
                                                      fontSize: 15.sp,
                                                      color: brandColor),
                                                ),
                                              ),
                                              onPressed: () => {signUp()}),
                                        ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate("alreadyHaveAccount"),
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
                                                    SignInPage()))
                                      },
                                      child: Container(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("signIn"),
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
                                      .translate("signUp"),
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
