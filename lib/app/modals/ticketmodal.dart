class Ticket {
  final int clientId, success, id, subjectId, statusId;
  final String title;
  final DateTime created;
  final List<TicketMessage> messages;

  Ticket(
      {this.clientId,
      this.messages,
      this.success,
      this.id,
      this.subjectId,
      this.statusId,
      this.title,
      this.created});

  factory Ticket.build(Map json) {
    return Ticket(
        id: int.parse(json["talep_no"]),
        clientId: int.parse(json["uye_id"]),
        success: int.parse(json["onay"]),
        subjectId: int.parse(json["konu_id"]),
        statusId: int.parse(json["durum_id"]),
        title: json["baslik"],
        created: DateTime.parse(json["tarih"]),
        messages: _getMessages(json["cevaplar"]));
  }

  static List<TicketMessage> _getMessages(List mess) =>
      mess.map((e) => TicketMessage.build(e)).toList();
}

class TicketMessage {
  final String message;
  final DateTime created;

  TicketMessage({this.message, this.created});

  factory TicketMessage.build(Map json) {
    return TicketMessage(
      message: json["cevap"],
      created: DateTime.parse(json["cevap_tarihi"].toString()),
    );
  }
}
