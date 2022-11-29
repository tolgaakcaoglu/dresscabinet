import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/orderstatusmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';

class OrderFunc {
  static Product getProd(List<Product> allProduct, int id) {
    Product product;
    for (Product prod in allProduct) {
      if (prod.id == id) {
        product = prod;
      }
    }
    return product;
  }

  static getProductDetail(List<Product> allProduct, Order order,
      Function(double, List<String>, double, double, double) update) {
    int length = order.basket.length;
    List<String> images = [];
    double total = 0;
    double memberDiscount = 0;
    double basketDiscount = 0;
    double totalUndiscount = 0;

    if (length >= 3) {
      for (Basket basket in order.basket) {
        images.add(
            getProd(allProduct, basket.productId).images.first['urun_resim'] ??
                '');
        total = total +
            (basket.salePrice -
                (basket.memberDiscount.price + basket.basketDiscount.price));
        totalUndiscount = totalUndiscount + basket.salePrice;
        memberDiscount = memberDiscount + basket.memberDiscount.price;
        basketDiscount = basketDiscount + basket.basketDiscount.price;
      }
    } else {
      var prod = getProd(allProduct, order.basket.first.productId);
      if (prod.images.length > 2) {
        for (var image in prod.images) {
          images.add(image['urun_resim'] ?? '');
        }
      } else {
        images.add(prod.images.first ?? '');
        images.add(prod.images.first ?? '');
        images.add(prod.images.first ?? '');
      }
      for (int i = 0; i < order.basket.length; i++) {
        Basket basket = order.basket[i];
        total = total +
            (basket.salePrice -
                (basket.memberDiscount.price + basket.basketDiscount.price));
        totalUndiscount = totalUndiscount + basket.salePrice;
        memberDiscount = memberDiscount + basket.memberDiscount.price;
        basketDiscount = basketDiscount + basket.basketDiscount.price;
      }
    }

    List<String> list = images.length > 3 ? images.sublist(0, 3) : images;

    if (list.isNotEmpty && total != 0) {
      update(total, list, memberDiscount, basketDiscount, totalUndiscount);
    }
  }

  static Future getOrderStatus(int orderid) async {
    String status;
    List list = await JsonFunctions.getOrderStatusList();
    for (Map item in list) {
      OrderStatus s = OrderStatus.build(item);
      if (s.id == orderid) {
        status = s.status;
      }
    }
    return status;
  }

  static getOrderWidthId(int orderId, Client client) {
    Order order;
    for (Order o in client.orders) {
      if (o.orderId == orderId) {
        order = o;
      }
    }
    return order;
  }
}
