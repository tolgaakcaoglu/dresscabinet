import 'dart:convert';
import 'dart:math';

import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:http/http.dart' as http;

class Payment {
  static Future<String> sendPayment(
      totalPayment,
      payment,
      cardHolderName,
      expiryDate,
      cardNumber,
      cvvCode,
      address,
      client,
      tckn,
      baskets,
      allProducts) async {
    var url = Uri.https('dresscabinet.com', 'api/odeme');

    var res = await http.post(url, body: {
      'siparis_no': (Random().nextInt(99999) + 10000).toString(),
      'ara_toplam': totalPayment.toStringAsFixed(2),
      'genel_toplam': payment.toStringAsFixed(2),
      'taksit': '1',
      'kart_adi_soyadi': cardHolderName,
      'kart_ay': expiryDate.split('/').first,
      'kart_no': cardNumber.replaceAll(' ', ''),
      'kart_yil': '20${expiryDate.split('/').last}',
      'kart_cvc': cvvCode,
      'adres_id': address.id.toString(),
      'adres_adi_soyadi': client.displayName,
      'adres_email': client.email,
      'adres_telefon ': client.phone,
      'tc_kimlik_no': tckn,
      'adres': address.address,
      'il_adi': 'İstanbul',
      'products': jsonEncode(await _getProdsMap(baskets, allProducts)),
    });

    var action = res.body
        .split('action="')
        .last
        .split('"')
        .first
        .replaceAll('https://', '');
    var yKrediKey = res.body.split('value="')[1].split('"').first;
    var result = bankController(action) == 'yapiKredi'
        ? await _send(action, yKrediKey)
        : res.body;
    return result;
  }

  static String bankController(String action) {
    if (action == "goguvenliodeme.bkm.com.tr/troy/approve") {
      return 'yapiKredi';
    }

    return null;
  }

  static Future<String> _send(String act, String key) async {
    var urlRoot = act.split('/').first;
    var urlExt = act.replaceAll(urlRoot, '');
    Uri uri = Uri.https(urlRoot, urlExt);
    var body = await http.post(uri, body: {'goreq': key});

    String paymentHTML = body.body;

    return paymentHTML;
  }

  static Future<List<Map>> _getProdsMap(baskets, allProducts) async {
    List<Map> prdList = [];

    for (var e in baskets) {
      Category c = await _getCategory(e.productId, allProducts);
      prdList.add({
        'urun_id': e.productId.toString(),
        'urun_adi': e.productName,
        'adet': e.piece.toString(),
        'kategori_adi': c.name,
        'satis_fiyati': e.salePrice.toStringAsFixed(2),
      });
    }

    return prdList;
  }

  static Future<Category> _getCategory(int id, allProducts) async {
    Category category;
    Product prod = OrderFunc.getProd(allProducts, id);

    List list = await JsonFunctions.getCategories();
    for (var item in list) {
      Category cat = Category.fromJson(item);
      if (cat.id == prod.categories.last) {
        category = cat;
      }
    }
    return category;
  }
}
