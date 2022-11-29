import 'package:dresscabinet/app/modals/productmodal.dart';

class Showcase {
  int id, order;
  String name, caption;
  List productsID, images;
  List<Product> products;

  Showcase(
      {this.id,
      this.order,
      this.name,
      this.caption,
      this.productsID,
      this.images,
      this.products});

  factory Showcase.fromJson(Map<String, dynamic> json) => Showcase(
        id: int.parse(json['sablon_id'].toString()),
        order: int.parse(json['sira'].toString()),
        name: json['vitrin_adi'],
        caption: json['aciklama'],
        productsID: json['urunler'],
        images: json['resimler'],
        products: [],
      );
}
