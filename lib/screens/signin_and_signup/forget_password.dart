// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/main.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:toast/toast.dart';

import 'change_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Initially password is obscure

  // Toggles the password show status

  bool _isLoading = false;
  final TextEditingController _phoneControl = new TextEditingController();

  //////////////login //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  my_activate() async {
    final tok = Boxes.getUserDataBox().get("userToken");

    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var tok = localStorage.getString('token');
    if (tok != null) {
      try {
        if (_phoneControl.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("completeTheData"),
            backgroundColor: Theme.of(context).textTheme.headline6.color,
            textColor: Theme.of(context).appBarTheme.backgroundColor,
          );
        } else {
          if (this.mounted) {
            setState(() {
              _isLoading = true;
            });
          }
          final response = await http.post(Uri.parse(APIUrl + "send_code"),
              headers: {"Accept": "application/json", "is_new": "1"},
              body: {"phone": _phoneControl.text, "token": tok.toString()});

          //var prif = SharedPreferences.getInstance();

          final data = jsonDecode(response.body);

          if (data["state"] == "1") {
            return Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ChangePassword();
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
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate('reOpenTheApp'),
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

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: shapeForAppBars(),
        iconTheme: IconThemeData(color: brandColor),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate("forgotYourPassword"),
          style: TextStyle(
              fontFamily: usedFont, fontSize: 17.sp, color: brandColor),
        ),
        titleSpacing: 0.0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("clickSendAndWaitMessage"),
                          style: TextStyle(
                              fontFamily: usedFont,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate("required_phone");
                              } else {
                                if (value.length != 8) {
                                  return AppLocalizations.of(context)
                                      .translate("invalid_phone");
                                } else {
                                  return null;
                                }
                              }
                            },
                            style: TextStyle(
                                fontFamily: usedFont,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            keyboardType: TextInputType.number,
                            controller: _phoneControl,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate("phoneNumber"),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: titleColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(width: 2, color: titleColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: titleColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(width: 2, color: titleColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  if (formKey.currentState.validate()) {
                                    my_activate();
                                  }
                                },
                                child: Container(
                                  height: 45.0,
                                  width: 190.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.redAccent,
                                    color: titleColor,
                                    elevation: 1.0,
                                    child: GestureDetector(
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("send"),
                                          style: TextStyle(
                                              fontFamily: usedFont,
                                              fontSize: 13.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                          child: Container(
                            height: 45.0,
                            width: 190.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(color: titleColor),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("homePage"),
                                style: TextStyle(
                                    fontFamily: usedFont,
                                    fontSize: 13.sp,
                                    color: Colors.black87),
                              ),
                            ),
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
      ),
    );
  }
}
