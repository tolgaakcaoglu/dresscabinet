class Address {
  final int id, country, district, province;
  final String title, address, postalCode;

  Address(
      {this.id,
      this.title,
      this.country,
      this.address,
      this.district,
      this.province,
      this.postalCode});

  factory Address.build(Map<String, dynamic> json) {
    return Address(
      id: int.parse(json['adres_id'].toString()),
      title: json['adres_basligi'],
      address: json['adres'],
      district: int.parse(json['adres_ilce'].toString()),
      province: int.parse(json['adres_il'].toString()),
      country: int.parse(json['adres_ulke'].toString()),
      postalCode: json['adres_posta_kodu'],
    );
  }
}
