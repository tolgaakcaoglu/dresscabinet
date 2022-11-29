import 'package:dresscabinet/app/functions/jsonfunc.dart';

class GiveBack {
  final int id;
  final String ibanDisplayName, ibanNo, caption;
  final DateTime giveDate;
  final List<GiveBackProduct> products;

  GiveBack(
      {this.id,
      this.ibanDisplayName,
      this.ibanNo,
      this.caption,
      this.giveDate,
      this.products});

  factory GiveBack.build(Map json) {
    return GiveBack(
      id: int.parse(json['siparis_id'].toString()),
      ibanDisplayName: json['iban']['adi_soyadi'],
      ibanNo: json['iban']['numara'],
      caption: json['aciklama'],
      giveDate: DateTime.parse(json['tarih'].toString()),
      products: getProducts(json['urunler']),
    );
  }

  static List<GiveBackProduct> getProducts(List json) =>
      json.map((prod) => GiveBackProduct.build(prod)).toList();
}

class GiveBackProduct {
  final int id;
  final Future<String> status;
  final String cause, type;

  GiveBackProduct({this.id, this.status, this.cause, this.type});

  factory GiveBackProduct.build(Map json) {
    return GiveBackProduct(
      id: int.parse(json['urun_id'].toString()),
      status: _getStatu(json['durum_id'].toString()),
      cause: json['urun_nedeni'],
      type: json['iade_talep_urun_tipi'],
    );
  }

  static Future<String> _getStatu(String id) async {
    if (id == "0") {
      return 'Beklemede';
    } else {
      List list = await JsonFunctions.getGiveBackStatus();
      String statu;

      for (Map json in list) {
        if (json['id'] == id) {
          statu = json["iptal_iade_durum"];
        }
      }

      return statu;
    }
  }
}
