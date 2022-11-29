import 'package:dresscabinet/app/modals/variantsmodal.dart';
import 'package:dresscabinet/app/utils/utils.dart';

class Product {
  final int id, stock;
  final List variants, categories, affiliatedProducts, images, features;
  final String code, name, caption, currencyUnit;
  final double marketPrice, salePrice;
  final dynamic shippingTime;
  final bool isNew, isFreeShipping;

  Product({
    this.id,
    this.stock,
    this.categories,
    this.affiliatedProducts,
    this.images,
    this.features,
    this.variants,
    this.code,
    this.name,
    this.caption,
    this.currencyUnit,
    this.marketPrice,
    this.salePrice,
    this.shippingTime,
    this.isNew,
    this.isFreeShipping,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      categories: json['kategoriler']
          .map((cat) => int.parse(cat['id'].toString()))
          .toList(),
      affiliatedProducts: json['bagli_urunler'],
      code: json['urun_kodu'],
      name: json['urun_adi'],
      caption: ConstUtils.decode(json['aciklama']),
      isNew: json['yeni_urun'] == "TRUE",
      isFreeShipping: json["ucretsiz_kargo"] == "TRUE",
      marketPrice: double.parse(json['piyasa_fiyati'].toString()),
      salePrice: double.parse(json['satis_fiyati'].toString()),
      currencyUnit: json['para_birimi'],
      shippingTime: json['kargo_suresi'],
      stock: int.parse(json['stok'].toString()),
      images: json['resimler'],
      features: json['ozellikler'],
      variants: json['varyantlar']
          .map((variant) => Variant.fromJson(variant))
          .toList(),
    );
  }
}
