import 'package:flutter/material.dart';
import 'package:sweet/constants.dart';
import 'package:sweet/screens/settings/add_user_delivery_details.dart';

class AddressBody extends StatefulWidget {
  const AddressBody({Key key}) : super(key: key);

  @override
  State<AddressBody> createState() => _AddressBodyState();
}

class _AddressBodyState extends State<AddressBody> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
        shrinkWrap: true,
        primary: true,
        itemBuilder: (context, index) => Column(
              children: [
                SizedBox(
                  height: h * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: titleColor,
                        ),
                        SizedBox(
                          width: w * 0.01,
                        ),
                        SizedBox(
                          width: w * 0.5,
                          child: Text(
                            "الفراونيه , شارع الاستاد عمارة 4 الدور الاول , شقه رقم 32",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddUserDeliveryDetails(false))),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: 5);
  }
}
