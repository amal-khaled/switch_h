import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/providers/home_provider.dart';

class ContactSweet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ContactUsBottomAppBar(
        companyName: "Bluzone",
        textColor: brandColor,
        backgroundColor: Colors.white,
        email: 'bluezone.adv@gmail.com',
        textFont: usedFont,
      ),
      backgroundColor: Colors.white,
      body: ContactUs(
        textFont: usedFont,
        dividerColor: Colors.blueAccent[100],
        cardColor: Colors.white,
        textColor: Colors.grey,
        logo: AssetImage('assets/icons/logo.png'),
        email: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .contactEmail,
        companyName: "Sweet H",
        companyColor: Colors.grey,
        phoneNumber: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .contactPhone,
        website: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .link,
        facebookHandle: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .fbLink,
        instagram: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .instaLink,
        twitterHandle: Provider.of<HomeProvider>(context, listen: false)
            .settingList[0]
            .twLink,
        taglineColor: Colors.red,
      ),
    );
  }
}
