class OrderStatus {
  final int id;
  final String status;

  OrderStatus({this.id, this.status});

  factory OrderStatus.build(Map json) {
    return OrderStatus(
      id: int.parse(json['siparis_durum_id'].toString()),
      status: json['siparis_durumu'],
    );
  }
}
