import 'package:flutter/material.dart';
import 'package:sweet/local_data/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants.dart';
import 'cart.dart';
import 'package:sizer/sizer.dart';

class CartIcon extends StatelessWidget {
  final Color color;
  CartIcon({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.getLocalCartItemsBox().listenable(),
      builder: (context, Box<int> localCartItemsListIDs, _) {
        final cartItemsCount = localCartItemsListIDs.keys.length;
        return InkWell(
          // behavior: HitTestBehavior.opaque,
          onTap: () {
            print("gkjk");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cart(),
                ));
          },
          child: Container(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                Container(),
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: ImageIcon(
                        AssetImage("assets/icons/cart.png"),
                        color: (color == null) ? brandColor : color,
                        size: 30,
                      ),
                      onPressed: () {
                         Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cart(),
                ));
                      },
                    ),
                    /*IconButton(
                      icon: Icon(Icons.shopping_cart,color: (color == null) ? brandColor : color,size: 30.sp,),
                    ),*/
                    cartItemsCount != 0
                        ? Positioned(
                            left: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                cartItemsCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 6.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
