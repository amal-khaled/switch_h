// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';
import '../../main.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _isload = false;
  final TextEditingController _codeControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();

  //////////////login //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  my_login() async {
    final tok = Boxes.getUserDataBox().get("userToken");
    if (tok != null) {
      try {
        if (_passwordControl.text.trim().isEmpty ||
            _codeControl.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("completeTheData"),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else if (_passwordControl.text.length < 6) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("shortPassword"),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else {
          if (this.mounted) {
            setState(() {
              _isload = true;
            });
          }
          final response =
              await http.post(Uri.parse(APIUrl + "changPassword"), headers: {
            "Accept": "application/json"
          }, body: {
            "code": _codeControl.text,
            "password": _passwordControl.text,
            "token": tok.toString()
          });

          //var prif = SharedPreferences.getInstance();

          final data = jsonDecode(response.body);

          if (data["state"] == "1") {
            Boxes.getUserDataBox().put("userLoginStatus", "2");
            Boxes.getUserDataBox().put("userToken", data['data']["api_token"]);
            Boxes.getUserDataBox().put("userJsonData", data['data']["client"]);

            return Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            Fluttertoast.showToast(
              msg: '${data["msg"]}',
              backgroundColor: Theme.of(context).textTheme.headline6.color,
              textColor: Theme.of(context).appBarTheme.backgroundColor,
            );
            if (this.mounted) {
              setState(() {
                _isload = false;
              });
            }
          }
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("noInternet"),
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

  ///end ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        ToastContext().init(context);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate("changePassword"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        titleSpacing: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  width: width - 40.0,
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextField(
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 12.sp,
                              color: Colors.grey),
                          controller: _codeControl,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate("codeOfSMS"),
                            prefixIcon: Icon(Icons.code),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(width: 2, color: brandColor)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextField(
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 12.sp,
                              color: Colors.grey),
                          controller: _passwordControl,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate("newPassword"),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF666666),
                              size: defaultIconSize,
                            ),
                            suffixIcon: IconButton(
                              icon: _obscureText
                                  ? Icon(
                                      Icons.visibility_off,
                                      size: defaultIconSize,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.remove_red_eye,
                                      color: Color(0xFF666666),
                                      size: defaultIconSize,
                                    ),
                              onPressed: () {
                                _toggle();
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(width: 2, color: brandColor)),
                          ),
                          obscureText: _obscureText,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () {
                          my_login();
                        },
                        child: Container(
                          height: 45.0,
                          width: 190.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: brandColor,
                            elevation: 7.0,
                            child: GestureDetector(
                              child: Center(
                                child: !_isload
                                    ? Text(
                                        AppLocalizations.of(context)
                                            .translate("confirm"),
                                        style: TextStyle(
                                            fontFamily: usedFont,
                                            fontSize: 13.sp,
                                            color: Colors.white),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("homePage"),
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 13.sp,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
