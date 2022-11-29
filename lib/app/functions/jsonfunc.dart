import 'dart:convert';
import 'package:dresscabinet/app/functions/constfunc.dart';
import 'package:http/http.dart' as http;

class JsonFunctions {
  static Future<bool> connectionController() async {
    try {
      // Lisans süresi doldu. Yönetici ile irtibata geçiniz.
      var url = Uri.https('dresscabinet.com', 'api');
      var res = await http.post(url);
      if (res.statusCode == 200) {
        if (ConstFunct.utfConvert(res.body) ==
            'Lisans süresi doldu. Yönetici ile irtibata geçiniz.') {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List> getProducts() async {
    var url = Uri.https('dresscabinet.com', 'api/urunler');
    var res = await http.post(url);
    final json = jsonDecode(ConstFunct.utfConvert(res.body));
    return json;
  }

  static Future<List> getSlides() async {
    var url = Uri.https('dresscabinet.com', 'api/bannerlar');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getShowcases() async {
    var url = Uri.https('dresscabinet.com', 'api/vitrinler');
    var res = await http.post(url);
    final json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getBankOptions() async {
    var url = Uri.https('dresscabinet.com', 'api/banka-taksit-oranlari');
    var res = await http.post(url);
    final json = jsonDecode(ConstFunct.utfConvert(res.body));
    return json;
  }

  static Future<List> getCategories() async {
    var url = Uri.https('dresscabinet.com', 'api/kategoriler');
    var res = await http.post(url);
    final json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getUsers() async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getOrderStatusList() async {
    var url = Uri.https('dresscabinet.com', 'api/siparis-durumlari');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getCountriesList() async {
    var url = Uri.https('dresscabinet.com', 'api/ulkeler');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getProvincesList() async {
    var url = Uri.https('dresscabinet.com', 'api/iller');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getDistrictList() async {
    var url = Uri.https('dresscabinet.com', 'api/ilceler');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getShippingBrands() async {
    var url = Uri.https('dresscabinet.com', 'api/kargolar');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getPaymentMethods() async {
    var url = Uri.https('dresscabinet.com', 'api/odeme-yontemleri');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getClientTypes() async {
    var url = Uri.https('dresscabinet.com', 'api/uye-gruplari');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getGiveBackCauses() async {
    var url = Uri.https('dresscabinet.com', 'api/iptal-iade-nedenleri');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getGiveBackStatus() async {
    var url = Uri.https('dresscabinet.com', 'api/iptal-iade-durumlari');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getGiveBackTypes() async {
    var url = Uri.https('dresscabinet.com', 'api/iptal-iade-tipleri');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getTicketSubjects() async {
    var url = Uri.https('dresscabinet.com', 'api/destek-talepleri/konular');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<List> getTicketStatuses() async {
    var url = Uri.https('dresscabinet.com', 'api/destek-talepleri/durumlar');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }

  static Future<Map> getSettings() async {
    var url = Uri.https('dresscabinet.com', 'api/ayarlar');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json.first;
  }

  static Future<List> getTransferInfo() async {
    var url = Uri.https('dresscabinet.com', 'api/havale-bilgileri');
    var res = await http.post(url);
    final List json = jsonDecode(ConstFunct.utfConvert(res.body));

    return json;
  }
}
