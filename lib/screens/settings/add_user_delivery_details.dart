import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:sweet/real_api/load_data.dart';
import 'package:sweet/screens/order_payment/payment.dart';
import 'package:toast/toast.dart';

class AddUserDeliveryDetails extends StatefulWidget {
  final bool isPayable;

  const AddUserDeliveryDetails(this.isPayable, {Key key}) : super(key: key);
  @override
  _AddUserDeliveryDetailsState createState() => _AddUserDeliveryDetailsState();
}

class _AddUserDeliveryDetailsState extends State<AddUserDeliveryDetails> {
  PropertyType userPropertyType;

  LoadData api;
  String userAddressData;
  Map<String, String> governToPriceMap = {};

  List<String> dates = [];
  Map<String, dynamic> deliveryTimesList = {};
  Map<String, List<dynamic>> deliveryDateToTimesMap = {};

  bool isCityLoading = false;
  bool isDatesLoading = false;
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController dateController = new TextEditingController();
  final TextEditingController timeController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  final TextEditingController regionController = new TextEditingController();
  final TextEditingController plotController = new TextEditingController();
  final TextEditingController streetController = new TextEditingController();
  final TextEditingController houseNumberController =
      new TextEditingController();
  final TextEditingController gaddaController = new TextEditingController();
  final TextEditingController buildingNumberController =
      new TextEditingController();
  final TextEditingController floorNumberController =
      new TextEditingController();
  final TextEditingController officeNumberController =
      new TextEditingController();
  final TextEditingController apartmentNumberController =
      new TextEditingController();
  final TextEditingController othersController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserInformation();
    api = new LoadData(context);
  }

  getUserInformation() {
    setState(() {
      if (Boxes.getUserDataBox().get("userPropertyType") != null) {
        userPropertyType =
            Boxes.getUserDataBox().get("userPropertyType") == "house"
                ? PropertyType.house
                : Boxes.getUserDataBox().get("userPropertyType") == "office"
                    ? PropertyType.office
                    : PropertyType.apartment; //todo oo
      } else {
        userPropertyType = PropertyType.house;
      }

      userNameController.text = Boxes.getUserDataBox().get("userName") ?? '';
      phoneController.text = Boxes.getUserDataBox().get("userPhone") ?? '';
      cityController.text = Boxes.getUserDataBox().get("userGovern") ?? '';
      regionController.text = Boxes.getUserDataBox().get("userRegion") ?? '';
      plotController.text = Boxes.getUserDataBox().get("userPlotNumber") ?? '';
      streetController.text =
          Boxes.getUserDataBox().get("userStreetName") ?? '';
      gaddaController.text = Boxes.getUserDataBox().get("userGaddaName") ?? '';
      apartmentNumberController.text =
          Boxes.getUserDataBox().get("userApartmentNumber") ?? '';
      officeNumberController.text =
          Boxes.getUserDataBox().get("userOfficeNumber") ?? '';
      buildingNumberController.text =
          Boxes.getUserDataBox().get("userBuildingNumber") ?? '';
      floorNumberController.text =
          Boxes.getUserDataBox().get("userFloorNumber") ?? '';
      houseNumberController.text =
          Boxes.getUserDataBox().get("userHouseNumber") ?? '';
      othersController.text = Boxes.getUserDataBox().get("userOtherData") ?? '';
    });
  }

  updateUserInfo() async {
    print('update');
    print(userPropertyType == PropertyType.office
        ? "office"
        : userPropertyType == PropertyType.apartment
            ? "apartment"
            : "house");
    await Boxes.getUserDataBox().put(
        "userPropertyType",
        userPropertyType == PropertyType.office
            ? "office"
            : userPropertyType == PropertyType.apartment
                ? "apartment"
                : "house"); //todo

    await Boxes.getUserDataBox().put("userName", userNameController.text);
    await Boxes.getUserDataBox().put("userPhone", phoneController.text);
    await Boxes.getUserDataBox().put("userGovern", cityController.text);
    await Boxes.getUserDataBox().put("userRegion", regionController.text);
    //await Boxes.getUserDataBox().put("userGovernID", optionItemSelected.governID.toString());
    await Boxes.getUserDataBox().put("userPlotNumber", plotController.text);
    await Boxes.getUserDataBox().put("userStreetName", streetController.text);
    await Boxes.getUserDataBox().put("userGaddaName", gaddaController.text);
    await Boxes.getUserDataBox()
        .put("userOfficeNumber", officeNumberController.text);
    await Boxes.getUserDataBox()
        .put("userBuildingNumber", buildingNumberController.text);
    await Boxes.getUserDataBox()
        .put("userFloorNumber", floorNumberController.text);
    await Boxes.getUserDataBox()
        .put("userApartmentNumber", apartmentNumberController.text);
    await Boxes.getUserDataBox()
        .put("userHouseNumber", houseNumberController.text);
    await Boxes.getUserDataBox().put("userOtherData", othersController.text);

    userAddressData =
        "${(userPropertyType == PropertyType.office ? AppLocalizations.of(context).translate("officeAddress") : userPropertyType == PropertyType.apartment ? AppLocalizations.of(context).translate("apartmentAddress") : AppLocalizations.of(context).translate("houseAddress")) + AppLocalizations.of(context).translate("city") + ": " + cityController.text + ", " + AppLocalizations.of(context).translate("region") + ": " + regionController.text + ", " + AppLocalizations.of(context).translate("plot") + ": " + plotController.text + ", " + AppLocalizations.of(context).translate("streetName") + ": " + streetController.text + ", " + AppLocalizations.of(context).translate("gadda") + ": " + gaddaController.text + ", " + AppLocalizations.of(context).translate("buildingNumber") + ": " + buildingNumberController.text + ", " + AppLocalizations.of(context).translate("floorNumber") + ": " + floorNumberController.text + ", " + AppLocalizations.of(context).translate("officeNumber") + ": " + officeNumberController.text + ", " + AppLocalizations.of(context).translate("apartmentNumber") + ": " + apartmentNumberController.text + ", " + AppLocalizations.of(context).translate("houseNumber") + ": " + houseNumberController.text + ", " + AppLocalizations.of(context).translate("otherNotes") + ": " + othersController.text}";
  }

  inputValidationCheck() {
    if (phoneController.text == "" ||
        userNameController.text == "" ||
        (dateController.text == "" && widget.isPayable) ||
        (timeController.text == "" && widget.isPayable) ||
        cityController.text == "" ||
        regionController.text == "" ||
        plotController.text == "" ||
        streetController.text == "" ||
        (houseNumberController.text == "" &&
            apartmentNumberController.text == "" &&
            officeNumberController.text == "") ||
        (userPropertyType == PropertyType.apartment &&
            buildingNumberController.text == "") ||
        (userPropertyType == PropertyType.office &&
            buildingNumberController.text == "") ||
        (userPropertyType == PropertyType.apartment &&
            floorNumberController.text == "") ||
        (userPropertyType == PropertyType.office &&
            floorNumberController.text == "")) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("completeTheData"),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
      return false;
    } else {
      return true;
    }
  }

/*  Map<String,List<String>> fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final date = data[1] as Map<String, List<dynamic>>;
    return date;
  }*/
  getDeliveryDates() async {
    setState(() {
      isDatesLoading = true;
      dates = [];
    });
    //  List<String> elements=[];
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = await api.getData(
            link: "https://sweeeth.com/api/v1/delivery-time",
            type: "list",
            call: "get");

        // print(data);
        //print("data");

        if (data != null) {
          List<dynamic> deliveryDateAndTimesList = [];

          deliveryDateAndTimesList = json.decode(json.encode(data['date']));
          deliveryTimesList = json.decode(json.encode(data['list_times']));

          for (int i = 0; i < deliveryDateAndTimesList.length; i++) {
            if (deliveryDateAndTimesList[i] != "") {
              dates.add(deliveryDateAndTimesList[i]);
              print(dates[i]);
              // deliveryDateToTimesMap[deliveryDateAndTimesList[i]] =
              //     deliveryDateAndTimesList[i + 1];
            }
          }

          //    final map = deliveryDateAndTimesList.asMap().map((key, value) => MapEntry(key, value)).values.toList();
          /*deliveryDateToTimesMap = json
              .decode(json.encode(data))
              .asMap()
              .map((key, value) => MapEntry(key, value))
              .values
              .toList();*/

/*          var map1 = Map.fromIterable(json.decode(json.encode(data)), key: (e) {
            return e.name;
          }, value: (e) => e.age);*/
          //print(map1);
          /*map.keys.forEach((key) {
            print(key);
          });*/
        }
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("noInternet"),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      }
    } on SocketException {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("noInternet"),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
    }
    setState(() {
      isDatesLoading = false;
    });
  }

  getGovern() async {
    setState(() {
      isCityLoading = true;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = await api.getData(
            link: APIUrl +
                "get_governs?token=" +
                Boxes.getUserDataBox().get("userToken"),
            type: "list",
            call: "get");

        if (data != null) {
          data.forEach((element) {
            governToPriceMap[getApiString(
                    context, element["name"], element["name_en"])] =
                element["price"].toString();
            /*Boxes.getApiGovernsObjectBox()
                .put(element["id"].toString(), Governs.fromJson(element));*/
          });

          print(governToPriceMap);
        }
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("noInternet"),
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          textColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      }
    } on SocketException {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("noInternet"),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
    }
    setState(() {
      isCityLoading = false;
    });
  }

  _showSingleChoiceDialog(
      BuildContext context,
      String title,
      Map<dynamic, dynamic> valuesMap,
      TextEditingController textEditingController) {
    return showDialog(
      context: context,
      builder: (context) {
        // final _singleNotifier = Provider.of<SingleNotifier>(context);
        return AlertDialog(
          backgroundColor: brandColor,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: usedFont,
              fontSize: 15.sp,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //children: governToPriceMap.keys
                children: valuesMap.keys
                    .map((e) => RadioListTile(
                          title: Text(
                            e.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: usedFont,
                              fontSize: 14.sp,
                            ),
                          ),
                          value: e.toString(),
                          groupValue: valuesMap[0].toString(),
                          selected: valuesMap[0].toString() == e.toString(),
                          onChanged: (value) {
                            textEditingController.text = value;
                            if (textEditingController == cityController) {
                              Boxes.getUserDataBox().put("userDeliveryPrice",
                                  governToPriceMap[value].toString());
                            } else if (textEditingController ==
                                dateController) {
                              setState(() {
                                timeController.clear();
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  _showSingleChoiceDialogdates(BuildContext context, String title,
      TextEditingController textEditingController) {
    return showDialog(
      context: context,
      builder: (context) {
        // final _singleNotifier = Provider.of<SingleNotifier>(context);
        return AlertDialog(
          backgroundColor: brandColor,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: usedFont,
              fontSize: 15.sp,
            ),
          ),
          content: SingleChildScrollView(
            primary: true,
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //children: governToPriceMap.keys
                children: List.generate(
                  dates.length,
                  (index) => RadioListTile(
                    title: Text(
                      dates[index].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: usedFont,
                        fontSize: 14.sp,
                      ),
                    ),
                    value: index,
                    groupValue: dates[index],
                    onChanged: (value) {
                      setState(() {
                        dates[index] = dates[value].toString();
                      });
                      textEditingController.text = dates[value];
                      if (textEditingController == cityController) {
                        Boxes.getUserDataBox().put("userDeliveryPrice",
                            governToPriceMap[value].toString());
                      } else if (textEditingController == dateController) {
                        setState(() {
                          timeController.clear();
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Material(
        child: Container(
          height: 13.h,
          width: 100.w,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("yourDataIsProtected"),
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: usedFont,
                          fontSize: defaultFontSize - 8,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
              SizedBox(
                height: 2,
              ),
              Container(
                width: double.infinity,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: titleColor,
                    ),
                    BoxShadow(
                      color: titleColor,
                    ),
                  ],
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: titleColor,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        widget.isPayable
                            ? AppLocalizations.of(context)
                                .translate("saveAndContinue")
                            : AppLocalizations.of(context).translate("save"),
                        style: TextStyle(
                            fontFamily: usedFont,
                            fontSize: 17.sp,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (inputValidationCheck()) {
                          await updateUserInfo();
                          if (widget.isPayable) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                        double.parse(Boxes.getUserDataBox()
                                            .get("totalInCart")),
                                        double.parse(Boxes.getUserDataBox()
                                            .get("userDeliveryPrice")),
                                        phoneController.text.toString(),
                                        Boxes.getUserDataBox()
                                            .get('userGovern'),
                                        " ",
                                        userAddressData,
                                        dateController.text.toString(),
                                        timeController.text.toString(),
                                        userNameController.text,
                                        0.0,
                                        "kuwait")));
                          } else {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                  .translate("saved"),
                              backgroundColor:
                                  Theme.of(context).textTheme.headline6.color,
                              textColor:
                                  Theme.of(context).appBarTheme.backgroundColor,
                            );
                          }
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          getAppBarUI(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.8,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      //getSearchBarUI(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                getButtonUI(PropertyType.house,
                                    userPropertyType == PropertyType.house),
                                const SizedBox(
                                  width: 16,
                                ),
                                getButtonUI(PropertyType.apartment,
                                    userPropertyType == PropertyType.apartment),
                                const SizedBox(
                                  width: 16,
                                ),
                                getButtonUI(PropertyType.office,
                                    userPropertyType == PropertyType.office),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 18, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: userNameController,
                                //obscureText: _obscureText,
                                showCursor: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "name is required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("userName"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.person,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontSize: defaultFontSize - 5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: phoneController,
                                //obscureText: _obscureText,
                                showCursor: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "phone number is required";
                                  } else {
                                    if (value.length < 8) {
                                      return "phone number is invalid";
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("phoneNumber"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.phone,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontSize: defaultFontSize - 5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),

                              Visibility(
                                visible: widget.isPayable,
                                child: TextField(
                                  onTap: () async {
                                    await getDeliveryDates();
                                    //  print(deliveryDateToTimesMap);
                                    _showSingleChoiceDialogdates(
                                        context,
                                        AppLocalizations.of(context)
                                            .translate("deliveryTime"),
                                        dateController);
                                  },
                                  controller: dateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("chooseDeliveryDate"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: isDatesLoading
                                        ? Container(
                                            width: 2.w,
                                            height: 2.h,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()))
                                        : Icon(
                                            Icons.date_range,
                                            color: titleColor,
                                            size: defaultIconSize,
                                          ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.isPayable,
                                child: SizedBox(
                                  height: 6,
                                ),
                              ),
                              Visibility(
                                visible: widget.isPayable,
                                child: TextField(
                                  onTap: () async {
                                    if (dateController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)
                                            .translate("chooseDateFirst"),
                                        backgroundColor: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                        textColor: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                      );
                                    } else {
                                      _showSingleTimeChoice(
                                          context,
                                          AppLocalizations.of(context)
                                              .translate("deliveryTime"),
                                          deliveryTimesList,
                                          timeController);
                                      // _showSingleChoiceDialog(
                                      //     context,
                                      //     AppLocalizations.of(context)
                                      //         .translate("deliveryTime"),
                                      //     deliveryTimesList,
                                      //     timeController);
                                    }
                                  },
                                  controller: timeController,
                                  readOnly: true,
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("deliveryTime"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.watch,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.isPayable,
                                child: SizedBox(
                                  height: 6,
                                ),
                              ),
                              TextField(
                                onTap: () async {
                                  await getGovern();
                                  _showSingleChoiceDialog(
                                      context,
                                      AppLocalizations.of(context)
                                          .translate("chooseYourCity"),
                                      governToPriceMap,
                                      cityController);
                                },
                                controller: cityController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("chooseYourCity"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: isCityLoading
                                      ? Container(
                                          width: 2.w,
                                          height: 2.h,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : IconButton(
                                          icon: Icon(
                                            Icons.location_city_rounded,
                                            color: titleColor,
                                            size: defaultIconSize,
                                          ),
                                          onPressed: () async {
                                            await getGovern();
                                            _showSingleChoiceDialog(
                                                context,
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        "chooseYourCity"),
                                                governToPriceMap,
                                                cityController);
                                          },
                                        ),
                                  fillColor: Colors.white,
                                ),
                              ),
                              //
                              SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: regionController,
                                //obscureText: _obscureText,
                                showCursor: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "region is required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("region"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.home_filled,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: plotController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "this field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                showCursor: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("plotNumber"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.home_filled,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: streetController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "street is required";
                                  } else {
                                    return null;
                                  }
                                },
                                showCursor: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("streetName"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.add_road,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: gaddaController,
                                showCursor: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "this field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate("gadda"),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: usedFont,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: defaultIconSize - 5,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.home_filled,
                                      color: titleColor,
                                      size: defaultIconSize,
                                    ),
                                    onPressed: () {},
                                  ),
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Visibility(
                                visible: userPropertyType == PropertyType.house,
                                child: TextFormField(
                                  controller: houseNumberController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "house number is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("houseNumber"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.home_filled,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    userPropertyType == PropertyType.apartment,
                                child: TextFormField(
                                  controller: apartmentNumberController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "apartment number is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("apartmentNumber"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                        color: titleColor,
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.apartment,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    userPropertyType == PropertyType.office,
                                child: TextFormField(
                                  controller: officeNumberController,
                                  //obscureText: _obscureText,
                                  showCursor: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "offfice number is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("officeNumber"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Visibility(
                                visible: userPropertyType ==
                                        PropertyType.apartment ||
                                    userPropertyType == PropertyType.office,
                                child: TextFormField(
                                  controller: buildingNumberController,
                                  showCursor: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "building number is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("buildingNumber"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.business_outlined,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: userPropertyType ==
                                        PropertyType.apartment ||
                                    userPropertyType == PropertyType.office,
                                child: SizedBox(
                                  height: 6,
                                ),
                              ),
                              Visibility(
                                visible: userPropertyType ==
                                        PropertyType.apartment ||
                                    userPropertyType == PropertyType.office,
                                child: TextFormField(
                                  controller: floorNumberController,
                                  showCursor: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "floor number is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("floorNumber"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: defaultIconSize - 5,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.home_filled,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: userPropertyType ==
                                        PropertyType.apartment ||
                                    userPropertyType == PropertyType.office,
                                child: SizedBox(
                                  height: 6,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: othersController,
                                  //obscureText: _obscureText,
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("otherNotes"),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: usedFont,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: const BorderSide(
                                          color: titleColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    filled: true,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: titleColor,
                                        size: defaultIconSize,
                                      ),
                                      onPressed: () {},
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getButtonUI(PropertyType categoryTypeData, bool isSelected) {
    String txt = '';
    IconData myIcon;
    PropertyType currentSelected = PropertyType.house;
    if (PropertyType.house == categoryTypeData) {
      txt = AppLocalizations.of(context).translate("house");
      myIcon = Icons.house_rounded;
      currentSelected = PropertyType.house;
    } else if (PropertyType.apartment == categoryTypeData) {
      txt = AppLocalizations.of(context).translate("apartment");
      myIcon = Icons.apartment_rounded;
      currentSelected = PropertyType.apartment;
    } else if (PropertyType.office == categoryTypeData) {
      txt = AppLocalizations.of(context).translate("office");
      myIcon = Icons.business_rounded;
      currentSelected = PropertyType.office;
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? titleColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: isSelected ? titleColor : titleColor.withOpacity(0.4),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              setState(() {
                buildingNumberController.text = "";
                floorNumberController.text = "";
                userPropertyType = currentSelected;
                //print(currentSelected);
                //print("sellected");
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        myIcon,
                        color: isSelected ? Colors.white : titleColor,
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Center(
                      child: Text(
                        txt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: usedFont,
                          fontSize: 13.sp,
                          letterSpacing: 0.25,
                          color: isSelected ? Colors.white : titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showSingleTimeChoice(
      BuildContext context,
      String title,
      Map<dynamic, dynamic> valuesMap,
      TextEditingController textEditingController) {
    List<dynamic> times = [];
    if (valuesMap.containsKey(dateController.text.toString())) {
      // times.add(valuesMap[dateController.text.toString()]);
      times.addAll(valuesMap[dateController.text.toString()]);
    }
    return showDialog(
      context: context,
      builder: (context) {
        // final _singleNotifier = Provider.of<SingleNotifier>(context);
        return AlertDialog(
          backgroundColor: brandColor,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: usedFont,
              fontSize: 15.sp,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //children: governToPriceMap.keys
                children: List.generate(
                    times.length,
                    (index) => RadioListTile(
                          title: Text(
                            times[index].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: usedFont,
                              fontSize: 14.sp,
                            ),
                          ),
                          value: index,
                          groupValue: times[index],
                          // selected: valuesMap[0].toString() == e.toString(),
                          onChanged: (value) {
                            setState(() {
                              times[index] = times[value];
                            });
                            textEditingController.text = times[value];
                            if (textEditingController == cityController) {
                              Boxes.getUserDataBox().put("userDeliveryPrice",
                                  governToPriceMap[value].toString());
                            } else if (textEditingController ==
                                dateController) {
                              setState(() {
                                timeController.clear();
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        )).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate("inputOrUpdate"),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: usedFont,
                    letterSpacing: 0.2,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate("yourDeliveryInformation"),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    fontFamily: usedFont,
                    letterSpacing: 0.27,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 0,
            child: InkWell(
              child: Container(
                width: 9.w,
                height: 3.8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(40),
                  // ),
                  border: Border.all(
                    width: 1,
                    color: brandColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.close),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum PropertyType {
  house,
  apartment,
  office,
}
