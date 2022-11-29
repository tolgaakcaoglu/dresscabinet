class GiveBackCause {
  final int id;
  final String cause;

  GiveBackCause({this.id, this.cause});

  factory GiveBackCause.build(Map json) {
    return GiveBackCause(
      id: int.parse(json["id"].toString()),
      cause: json["iptal_iade_neden"],
    );
  }
}

class GiveBackType {
  final int id;
  final String type;

  GiveBackType({this.id, this.type});

  factory GiveBackType.build(Map json) {
    return GiveBackType(
      id: int.parse(json["id"].toString()),
      type: json["iptal_iade_tip"],
    );
  }
}

class GiveBackStatus {
  final int id;
  final String status;

  GiveBackStatus({this.id, this.status});

  factory GiveBackStatus.build(Map json) {
    return GiveBackStatus(
      id: int.parse(json["id"].toString()),
      status: json["iptal_iade_durum"],
    );
  }
}
