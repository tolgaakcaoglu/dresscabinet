import 'package:dresscabinet/app/modals/addressmodal.dart';
import 'package:dresscabinet/app/modals/givebackmodal.dart';
import 'package:dresscabinet/app/modals/ticketmodal.dart';

import 'alertmodal.dart';
import 'ordermodal.dart';

class Client {
  final int id;
  final String memberType, displayName, phone, email, gender;
  final bool onEmail, onSms, onPolicy;
  final List<Order> orders;
  final List<ProductAlert> alerts;
  final List<Address> deliveryAddress, billingAddress;
  final List<GiveBack> givebacklist;
  final List favorites;
  final List<Ticket> tickets;

  Client({
    this.id,
    this.memberType,
    this.displayName,
    this.phone,
    this.gender,
    this.email,
    this.onEmail,
    this.onSms,
    this.onPolicy,
    this.orders,
    this.givebacklist,
    this.deliveryAddress,
    this.billingAddress,
    this.alerts,
    this.favorites,
    this.tickets,
  });

  factory Client.build(Map json) {
    return Client(
        id: int.parse(json["uye_id"].toString()),
        memberType: json["uye_tip"],
        displayName: json["uye_adi_soyadi"],
        phone: json["uye_telefon"],
        gender: json["uye_cinsiyet"] == "2" ? 'Kadın' : 'Erkek',
        email: json["uye_email"],
        onEmail: json["uye_email_izin"] == "1",
        onSms: json["uye_sms_izin"] == "1",
        onPolicy: json["uye_sozlesme_izin"] == "1",
        orders: toOrder(json["siparisler"]),
        alerts: toAlerts(json["fiyat_alarm"]),
        givebacklist: toGiveBack(json["iptal_iade"]),
        deliveryAddress: toAdress(json["adresler"]["teslimat"]),
        billingAddress: toAdress(json["adresler"]["fatura"]),
        favorites: json['favoriler'],
        tickets: toTickets(json["destek_talepleri"]));
  }
  static List<Ticket> toTickets(List json) =>
      json.map((ticket) => Ticket.build(ticket)).toList();

  static List<GiveBack> toGiveBack(List json) =>
      json.map((giveback) => GiveBack.build(giveback)).toList();

  static List<Address> toAdress(List json) =>
      json.map((order) => Address.build(order)).toList();

  static List<Order> toOrder(List json) =>
      json.map((order) => Order.build(order)).toList();

  static List<ProductAlert> toAlerts(List json) =>
      json.map((alert) => ProductAlert.build(alert)).toList();
}
