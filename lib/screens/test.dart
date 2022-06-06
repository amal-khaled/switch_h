// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:new_version/new_version.dart';

// class TestVersion extends StatefulWidget {
//   @override
//   _TestVersionState createState() => _TestVersionState();
// }

// class _TestVersionState extends State<TestVersion> {
//   @override
//   void initState() {
//     _checkVersion();
//     super.initState();
//   }

//   void _checkVersion() async {
//     final newVersion = NewVersion(
//       androidId: "com.bluezone.sweet",
//     );
//     newVersion.showAlertIfNecessary(context: context);
//     final status = await newVersion.getVersionStatus();
//     newVersion.showUpdateDialog(
//       context: context,
//       versionStatus: status,
//       dialogTitle: "UPDATE!!!",
//       dismissButtonText: "Skip",
//       dialogText: "Please update the app from " +
//           "${status.localVersion}" +
//           " to " +
//           "${status.storeVersion}",
//       dismissAction: () {
//         SystemNavigator.pop();
//       },
//       updateButtonText: "Lets update",
//     );

//     print("DEVICE : " + status.localVersion);
//     print("STORE : " + status.storeVersion);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Example App"),
//       ),
//     );
//   }
// }
