class Variant {
  String title, value;
  int stock;
  double price;

  Variant({this.title, this.value, this.stock, this.price});

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        title: json['baslik'],
        value: json['deger'],
        stock: int.parse(json['stok'].toString()),
        price: double.parse(json['fiyat'].toString()),
      );
}
