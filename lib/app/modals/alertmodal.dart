class ProductAlert {
  final int productId;
  final double firstPrice;

  ProductAlert({this.productId, this.firstPrice});

  factory ProductAlert.build(Map json) {
    return ProductAlert(
      productId: int.parse(json['urun_id'].toString()),
      firstPrice: double.parse(json['ilk_fiyat'].toString()),
    );
  }
}
