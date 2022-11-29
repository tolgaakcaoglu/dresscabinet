class Slide {
  String name, image, key;
  int order;

  Slide({this.order, this.name, this.image, this.key});

  factory Slide.fromJson(Map json) {
    return Slide(
      name: json['banner_adi'],
      image: json['banner_resim']['mobil'],
      order: int.parse(json['sira'].toString()) ?? 1,
      key: json['button']['link'],
    );
  }
}
