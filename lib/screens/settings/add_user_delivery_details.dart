import 'package:flutter/material.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:sweet/screens/settings/add_edit_address.dart';
import 'package:sweet/widgets/cutome_dropdown.dart';
import 'package:toast/toast.dart';

import '../../local_data/boxes.dart';
import '../order_payment/payment.dart';

class AddUserDeliveryDetails extends StatefulWidget {
  final bool isPayable;

  const AddUserDeliveryDetails(this.isPayable, {Key key}) : super(key: key);
  @override
  _AddUserDeliveryDetailsState createState() => _AddUserDeliveryDetailsState();
}

class _AddUserDeliveryDetailsState extends State<AddUserDeliveryDetails> {
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
                      if (CustomDropDown.chosenValue != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                                double.parse(
                                    Boxes.getUserDataBox().get("totalInCart")),
                                double.parse(Boxes.getUserDataBox()
                                        .get("userDeliveryPrice")) ??
                                    "",
                                phoneController.text.toString() ?? "",
                                Boxes.getUserDataBox().get('userGovern'),
                                " ",
                                CustomDropDown.chosenValue,
                                dateController.text.toString() ?? "",
                                timeController.text.toString() ?? "",
                                userNameController.text ?? "",
                                0.0,
                                "kuwait"),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          getAppBarUI(),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context).translate("address"),
                    style: TextStyle(
                      fontFamily: usedFont,
                      color: titleColor,
                    ),
                  ),
                  TextSpan(text: "  "),
                  TextSpan(
                    text:
                        "( ${(AppLocalizations.of(context).translate("select_address"))} )",
                    style: TextStyle(
                      fontFamily: usedFont,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          (widget.isPayable)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: CustomDropDown(
                      text: AppLocalizations.of(context).translate("address"),
                      items: [
                        "address test 1",
                        "address test 2",
                        "address test 3",
                        "address test 4",
                        "address test 5",
                        "address test 6",
                        "address test 7",
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 2.h,
          ),
          Center(
            child: Container(
              width: double.infinity,
              height: 8.h,
              margin: EdgeInsets.symmetric(
                horizontal: 2.w,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOrEditUserAddress(
                              isPayable: widget.isPayable,
                            ))),
                child: Text(
                  AppLocalizations.of(context).translate("add_address"),
                  style: TextStyle(
                      fontFamily: usedFont,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
                ),
              ),
            ),
          ),
        ],
      ),
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
