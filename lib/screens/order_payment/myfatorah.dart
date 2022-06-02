// // ignore_for_file: deprecated_member_use

// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:my_fatoorah/my_fatoorah.dart';
// import 'package:sweet/constants.dart';
// import 'package:toast/toast.dart';

// import '../../local_data/boxes.dart';
// import '../../main.dart';
// import '../../providers/app_localizations.dart';

// class CreditCardScreen extends StatefulWidget {
//   double price;
//   String govern;
//   String city;
//   String address;
//   String phone;
//   double total;
//   double balance;
//   String name;

//   var net;
//   CreditCardScreen(this.address, this.balance, this.city, this.govern, this.net,
//       this.phone, this.price, this.total, this.name);

//   @override
//   State<CreditCardScreen> createState() => _CreditCardScreenState();
// }

// class _CreditCardScreenState extends State<CreditCardScreen> {
//   bool _load = false;
//   set_orders(invoiceId, type) async {
//     setState(() {
//       _load = true;
//     });
//     final tok = Boxes.getUserDataBox().get("userToken");
//     if (tok != null) {
//       try {
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           http.Response response =
//               await http.post(Uri.parse(APIUrl + "add_orders"), headers: {
//             "Accept": "application/json"
//           }, body: {
//             "phone": widget.phone,
//             "type": type.toString(),
//             "inovic_id": invoiceId.toString(),
//             "username": widget.name,
//             "name": widget.govern,
//             "city": widget.city,
//             "address": widget.address,
//             "token": tok,
//             "user_id": Boxes.getUserDataBox().get("userJsonData") == null
//                 ? "0"
//                 : jsonDecode(Boxes.getUserDataBox()
//                         .get("userJsonData")
//                         .toString())["id"]
//                     .toString(),
//             "price":
//                 double.parse(Boxes.getUserDataBox().get("userDeliveryPrice"))
//                     .toString(),
//             "total": double.parse(Boxes.getUserDataBox().get("totalInCart"))
//                 .toString(),
//             "balance": (widget.balance).toString(),
//           });

//           if (response.statusCode == 200) {
//             // print((widget.balance - remind).toString());

//             var res = json.decode(response.body);
//             if (res["state"] == "1") {
//               Boxes.getLocalCartItemsObjectBox().clear();
//               Boxes.getLocalCartItemsBox().clear();
//               Boxes.getUserDataBox().put("totalInCart", "0.0");
//               //success msg
//               Toast.show("successful payment", context);

//               Future.delayed(const Duration(seconds: 0), () {
//                 if (this.mounted) {
//                   setState(() {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()),
//                     );
//                   });
//                 }
//               });
//             } else {
//               // "مشكلة بالشبكة اثناء حفظ الطلب في حسابك تواصل مع احفظ رقم الفاتورة وتواصل مع خدمة  العملاء لحل المشكلة كود الفاتورة  ${invoiceId}",
//               Toast.show(
//                   "مشكلة بالشبكة اثناء حفظ الطلب في حسابك تواصل مع احفظ رقم الفاتورة وتواصل مع خدمة  العملاء لحل المشكلة كود الفاتورة$invoiceId",
//                   context);
//             }
//           }
//         } else {
//           Toast.show(
//               AppLocalizations.of(context).translate("noInternet"), context);
//         }
//       } on SocketException {
//         Toast.show(
//             AppLocalizations.of(context).translate("noInternet"), context);
//       }
//     } else {
//       Toast.show(
//           AppLocalizations.of(context).translate("reOpenTheApp"), context);
//     }
//     if (this.mounted) {
//       setState(() {
//         _load = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: brandColor,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           "Visa and Master Card",
//           style: TextStyle(color: Colors.black),
//         ),
//         titleSpacing: 0.0,
//       ),
//       body: MyFatoorah(
//         buildAppBar: (context) {
//           return AppBar(
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: brandColor,
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             backgroundColor: Colors.white,
//             title: Text(
//               "Visa and Master Card",
//               style: TextStyle(color: Colors.black),
//             ),
//             titleSpacing: 0.0,
//           );
//         },
//         onResult: (response) {
//           if (response.isSuccess) {
//             set_orders(response.paymentId, "knet");
//           }
//         },
//         request: MyfatoorahRequest(
//           successUrl:
//               "https://images-eu.ssl-images-amazon.com/images/G/31/img16/GiftCards/payurl1/440x300-2.jpg",
//           errorUrl:
//               "https://st3.depositphotos.com/3000465/33237/v/380/depositphotos_332373348-stock-illustration-declined-payment-credit-card-vector.jpg?forcejpeg=true",
//           currencyIso: Country.Kuwait,
//           invoiceAmount: widget.price,
//           language: ApiLanguage.Arabic,
//           token: mAPIKey,
//         ),
//       ),
//     );
//   }
// }
