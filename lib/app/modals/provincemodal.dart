class Province {
  final int id, countryId;
  final String name;

  Province({this.id, this.countryId, this.name});

  factory Province.build(Map json) {
    return Province(
      id: int.parse(json['il_id']),
      countryId: int.parse(json['ulke_id_fk']),
      name: json['il_adi'],
    );
  }
}
