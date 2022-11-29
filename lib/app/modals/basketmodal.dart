import 'package:flutter/cupertino.dart';

const String basketTable = 'basket';

class BasketField {
  static const String productId = 'siparis_urun_id';
  static const String piece = 'urun_adet';
  static const String kdv = 'urun_kdv';
  static const String productName = 'urun_adi';
  static const String currencyUnit = 'urun_para_birimi';
  static const String note = 'urun_siparis_notu';
  static const String variant = 'urun_varyant';
  static const String brand = 'urun_marka_adi';
  static const String marketPrice = 'urun_piyasa_fiyati';
  static const String salePrice = 'urun_satis_fiyati';
  static const String basketDiscount = 'sepet_indirimi';
  static const String memberDiscount = 'uye_indirimi';
}

class Basket {
  final int productId, piece, kdv;
  final String productName, currencyUnit, note, variant, brand;
  final double marketPrice, salePrice;
  final BasketDiscount basketDiscount;
  final MemberDiscount memberDiscount;

  Basket({
    @required this.productId,
    @required this.piece,
    @required this.kdv,
    @required this.productName,
    @required this.currencyUnit,
    @required this.note,
    @required this.variant,
    @required this.brand,
    @required this.marketPrice,
    @required this.salePrice,
    @required this.basketDiscount,
    @required this.memberDiscount,
  });

  Basket copy({
    productId,
    piece,
    kdv,
    productName,
    currencyUnit,
    note,
    variant,
    brand,
    marketPrice,
    salePrice,
    basketDiscount,
    memberDiscount,
  }) =>
      Basket(
        productId: productId ?? this.productId,
        piece: piece ?? this.piece,
        kdv: kdv ?? this.kdv,
        productName: productName ?? this.productName,
        currencyUnit: currencyUnit ?? this.currencyUnit,
        note: note ?? this.note,
        variant: variant ?? this.variant,
        brand: brand ?? this.brand,
        marketPrice: marketPrice ?? this.marketPrice,
        salePrice: salePrice ?? this.salePrice,
        basketDiscount: basketDiscount ?? this.basketDiscount,
        memberDiscount: memberDiscount ?? this.memberDiscount,
      );

  Map<String, Object> toJson() => {
        BasketField.productId: productId,
        BasketField.productName: productName,
        BasketField.marketPrice: marketPrice,
        BasketField.salePrice: salePrice,
        BasketField.piece: piece,
        BasketField.basketDiscount: basketDiscount,
        BasketField.memberDiscount: memberDiscount,
        BasketField.kdv: kdv,
        BasketField.currencyUnit: currencyUnit,
        BasketField.note: note,
        BasketField.variant: variant,
        BasketField.brand: brand,
      };

  factory Basket.build(Map json) {
    return Basket(
      productId: int.parse(json['siparis_urun_id'].toString()),
      productName: json['urun_adi'],
      marketPrice: double.parse(json['urun_piyasa_fiyati'].toString()),
      salePrice: double.parse(json["urun_satis_fiyati"].toString()),
      piece: int.parse(json['urun_adet'].toString()),
      basketDiscount: json['sepet_indirimi'] != null
          ? BasketDiscount.build(json['sepet_indirimi'])
          : null,
      memberDiscount: json['uye_indirimi'] != null
          ? MemberDiscount.build(json['uye_indirimi'])
          : null,
      kdv: int.parse(json['urun_kdv'].toString()),
      currencyUnit: json['urun_para_birimi'],
      note: json['urun_siparis_notu'] ?? '',
      variant: json['urun_varyant'],
      brand: json['urun_marka_adi'],
    );
  }
}

class BasketDiscount {
  final String caption;
  final double price;

  BasketDiscount({this.caption, this.price});

  factory BasketDiscount.build(Map json) {
    return BasketDiscount(
      caption: json["kural"] ?? '',
      price: double.parse(json["fiyat"].toString()),
    );
  }
}

class MemberDiscount {
  final String caption;
  final double price;

  MemberDiscount({this.caption, this.price});

  factory MemberDiscount.build(Map json) {
    return MemberDiscount(
      caption: json["kural"] ?? '',
      price: double.parse(json["fiyat"].toString()),
    );
  }
}
