class Category {
  int id, order, parentID;
  String name, caption;

  Category({this.id, this.order, this.parentID, this.name, this.caption});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: int.parse(json['id'].toString()),
        order: int.parse(json['sira'].toString()),
        parentID: int.parse(json['parent_id'].toString()),
        name: json['kategori'],
        caption: json['aciklama'],
      );
}
