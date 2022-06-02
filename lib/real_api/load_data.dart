import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class LoadData {
  BuildContext context;

  LoadData(BuildContext context) {
    this.context = context;
    ToastContext().init(context);

  }
  //HomeApi api = new HomeApi() ;
  bool _error = false;
  bool get error => _error;
  var data;
  var response;

  getData({link, type, call, Map args}) async {
    apiDateType(type);
    try {
      //get http
      if (call == null || call == "get") {
        response =
            await http.get(Uri.parse(link), headers: {"Accept": "application/json"});

//post http
      } else {
        response = await http.post(Uri.parse(link),
            headers: {"Accept": "application/json"}, body: args);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["state"] == "1") {
          data = json.decode(response.body)["data"];
        } else {
          _error = true;

          data = null;
          showToast("try again");
        }
      } else {
        _error = true;
        showToast("try again");
        data = null;
      }

      return data;
    } catch (e) {
      _error = true;

      showToast("connection error");

      return data;
    }
  }

  apiDateType(type) {
    if (type == null || type == "map") {
      data = {};
    } else {
      data = [];
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
