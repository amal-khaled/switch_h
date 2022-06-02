import 'package:hive/hive.dart';
import 'package:sweet/real_api/real_products.dart';

class Boxes {
  static Box<int> getLocalCartItemsBox() => Hive.box<int>('localCartItems');
  static Box<ProductLive> getLocalCartItemsObjectBox() => Hive.box<ProductLive>('localCartItemsObject');
  static Box<String> getUserDataBox() => Hive.box<String>('userData');

 /* static Box<LocalUserData> getLocalUserTokenBox() => Hive.box<LocalUserData>('userToken');

  static Box<LocalUserData> getLoginStatusBox() =>
      Hive.box<LocalUserData>('loginStatus');

  static Box<LocalUserData> getUserLangBox() =>
      Hive.box<LocalUserData>('userLang');

  static Box<LocalUserData> getApiUserDataBox() =>
      Hive.box<LocalUserData>('apiUserData');

  static Box<LocalUserData> getUserNameBox() =>
      Hive.box<LocalUserData>('userName');

  static Box<LocalUserData> getUserPhoneBox() =>
      Hive.box<LocalUserData>('userPhone');

  static Box<LocalUserData> getUserGovernBox() =>
      Hive.box<LocalUserData>('userGovern');

  static Box<LocalUserData> getUserAddressBox() =>
      Hive.box<LocalUserData>('userAddress');

  static Box<LocalUserData> getUserDeliveryPriceBox() =>
      Hive.box<LocalUserData>('userDeliveryPrice');*/
}