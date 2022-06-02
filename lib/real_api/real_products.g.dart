// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductLiveAdapter extends TypeAdapter<ProductLive> {
  @override
  final int typeId = 0;

  @override
  ProductLive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductLive(
      productID: fields[0] as int,
      createdAt: fields[1] as String,
      updatedAt: fields[2] as String,
      productTitle: fields[3] as String,
      productDescription: fields[4] as String,
      productOriginalPrice: fields[5] as double,
      productPrice: fields[6] as double,
      productBrandID: fields[7] as int,
      productSubcategoryID: fields[8] as int,
      productCategoryID: fields[9] as String,
      productQuantity: fields[10] as int,
      productEnglishTitle: fields[11] as String,
      productEnglishDescription: fields[12] as String,
      productImageURL: fields[13] as String,
      discountPercentage: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductLive obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.productID)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.productTitle)
      ..writeByte(4)
      ..write(obj.productDescription)
      ..writeByte(5)
      ..write(obj.productOriginalPrice)
      ..writeByte(6)
      ..write(obj.productPrice)
      ..writeByte(7)
      ..write(obj.productBrandID)
      ..writeByte(8)
      ..write(obj.productSubcategoryID)
      ..writeByte(9)
      ..write(obj.productCategoryID)
      ..writeByte(10)
      ..write(obj.productQuantity)
      ..writeByte(11)
      ..write(obj.productEnglishTitle)
      ..writeByte(12)
      ..write(obj.productEnglishDescription)
      ..writeByte(13)
      ..write(obj.productImageURL)
      ..writeByte(14)
      ..write(obj.discountPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductLiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
