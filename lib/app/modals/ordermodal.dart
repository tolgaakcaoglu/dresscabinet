import 'package:dresscabinet/app/modals/basketmodal.dart';

class Order {
  final int orderId, orderNo, orderStatusId;
  final List<Basket> basket;
  final DateTime orderDate;
  final String shippingBrand, paymentType;
  final double shippingPay;
  Order({
    this.orderStatusId,
    this.orderId,
    this.orderNo,
    this.basket,
    this.shippingBrand,
    this.paymentType,
    this.shippingPay,
    this.orderDate,
  });

  factory Order.build(Map json) {
    return Order(
      orderId: int.parse(json["siparis_id"].toString()),
      orderNo: int.parse(json["siparis_no"].toString()),
      basket: toBasket(json["urunler"]),
      orderDate: DateTime.parse(json['siparis_tarihi']),
      paymentType: json['odeme_tipi'],
      shippingBrand: json['kargo_firma_adi'],
      shippingPay: double.parse(json['kargo_tutar'].toString()),
      orderStatusId: int.parse(json['siparis_durum_id'].toString()),
    );
  }

  static List<Basket> toBasket(List json) =>
      json.map((basket) => Basket.build(basket)).toList();
}
