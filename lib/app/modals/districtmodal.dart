class District {
  final int id, countryId, provinceId;
  final String name;

  District({this.id, this.countryId, this.name, this.provinceId});

  factory District.build(Map json) {
    return District(
      id: int.parse(json['ilce_id']),
      countryId: int.parse(json['ulke_id_fk']),
      name: json['ilce_adi'],
      provinceId: int.parse(json['il_id_fk']),
    );
  }
}
