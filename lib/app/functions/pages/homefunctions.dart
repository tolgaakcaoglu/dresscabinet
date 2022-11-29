import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/showcasemodal.dart';

class HomeFunc {
  static Future getShowcases(List products) async {
    List json = await JsonFunctions.getShowcases();

    if (json != null) {
      List<Showcase> s = [];
      for (Map data in json) {
        List<Product> pr = getShowcaseProducts(products, data['urunler']);

        s.add(Showcase(
            caption: data['aciklama'],
            id: int.parse(data['sablon_id'].toString()),
            images: data['resimler'],
            name: data['vitrin_adi'],
            order: int.parse(data['sira'].toString()),
            productsID: data['urunler'],
            products: pr));
      }

      s.sort((a, b) => a.order.compareTo(b.order));

      return s;
    }
  }

  static List<Product> getShowcaseProducts(List products, List urunler) {
    List<Product> allProd = products;
    List<Product> newlist = [];
    for (Product product in allProd) {
      for (String urun in urunler) {
        if (urun == product.id.toString()) {
          newlist.add(product);
        }
      }
    }
    // if (mounted) setState(() => splash = false);
    return newlist;
  }
}
