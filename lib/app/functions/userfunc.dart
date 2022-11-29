import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/addressmodal.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/districtmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/provincemodal.dart';
import 'package:dresscabinet/app/modals/transferinfomodal.dart';
import 'package:http/http.dart' as http;

class UserFunc {
  static Future<String> getUserIdWithEmail(String email) async {
    final List json = await JsonFunctions.getUsers();
    String userID = '';

    for (var map in json) {
      if (map['uye_email'] == email) {
        userID = map['uye_id'];
      }
    }

    return userID;
  }

  static Future<Map> getUserData(String id) async {
    final List json = await JsonFunctions.getUsers();
    Map user;

    for (var map in json) {
      if (map['uye_id'] == id) {
        user = map;
      }
    }

    return user;
  }

  static Future updateUserData(int id,
      {String displayName,
      String memberType,
      String phone,
      String email,
      int emailVerify,
      int smsVerify,
      int policyVerify,
      String gender}) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/guncelle');
    var response = await http.post(url, body: {
      'uye_id': id.toString(),
      if (gender != null) 'uye_cinsiyet': gender,
      if (displayName != null) 'uye_adi_soyadi': displayName,
      if (memberType != null) 'uye_tip': memberType,
      if (phone != null) 'uye_telefon': phone,
      if (email != null) 'uye_email': email,
      if (emailVerify != null) 'uye_email_izin': emailVerify.toString(),
      if (smsVerify != null) 'uye_sms_izin': smsVerify.toString(),
      if (policyVerify != null) 'uye_sozlesme_izin': policyVerify.toString(),
    });
    return response.body;
  }

  static Future passwordControl(String email, String password) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/login');
    var response = await http.post(url, body: {
      'email': email,
      'sifre': password,
    });

    return response.body;
  }

  static Future signupFunction(
      String displayName,
      String email,
      String password,
      String phone,
      bool onEmail,
      bool onSms,
      bool onPrivacy) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/sign-up');

    var response = await http.post(url, body: {
      'adi_soyadi': displayName,
      'email': email,
      'sifre': password,
      'telefon': phone,
      'kampanya_email_izin': onEmail ? "1" : "0",
      'kampanya_sms_izin': onSms ? "1" : "0",
      'sozlesme_izin': onPrivacy ? "1" : "0",
    });
    return response.body;
  }

  static Future addAlert(String userID, String prodID) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/fiyat-alarm/ekle');
    var response = await http.post(url, body: {
      'uye_id': userID,
      'urun_id': prodID,
    });
    return response.body;
  }

  static Future removeAlert(String userID, String prodID) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/fiyat-alarm/sil');
    var response = await http.post(url, body: {
      'uye_id': userID,
      'urun_id': prodID,
    });
    return response.body;
  }

  static Future changePassword(
      String userID, String currentPassword, String newPassword) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/sifre-guncelle');
    var response = await http.post(url, body: {
      'uye_id': userID,
      'eski_sifre': currentPassword,
      'yeni_sifre': newPassword,
      'yeni_sifre_tekrar': newPassword,
    });

    return response.body;
  }

  static Future addLike(int userId, int prodId) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/favori-ekle');
    var response = await http.post(url, body: {
      'uye_id': userId.toString(),
      'urun_id': prodId.toString(),
    });
    return response.body;
  }

  static Future removeLike(int userId, int prodId) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/favori-sil');
    var response = await http.post(url, body: {
      'uye_id': userId.toString(),
      'urun_id': prodId.toString(),
    });
    return response.body;
  }

  static Future addTicket(
      int userId, String subjectId, String title, String caption) async {
    var url = Uri.https('dresscabinet.com', 'api/destek-talepleri/olustur');
    var response = await http.post(url, body: {
      'uye_id': userId.toString(),
      'konu': subjectId,
      'baslik': title,
      'detay': caption,
    });

    return response.body;
  }

  static Future addAddress(Client client, Address address) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/adres-ekle');
    var response = await http.post(url, body: {
      'uye_id': client.id.toString(),
      'token': '',
      'adres_tipi': '1',
      'adres_basligi': address.title,
      'adres_adi_soyadi': client.displayName,
      'adres_tc_kimlik_no': '',
      'adres': address.address,
      'adres_ulke': address.country.toString(),
      'adres_il': address.province.toString(),
      'adres_ilce': address.district.toString(),
      'adres_posta_kodu': address.postalCode,
      'adres_email': client.email,
      'adres_telefon': client.phone,
      'adres_firma_adi': '',
      'adres_vergi_dairesi': '',
      'adres_vergi_no': '',
    });

    return response.body;
  }

  static Future removeAddress(String addressId) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/adres-sil');
    var response = await http.post(url, body: {
      'adres_id': addressId,
    });

    return response.body;
  }

  static Future addNewGiveback(Client client, Order order, String displayName,
      String iban, String caption, List<Map> urunler) async {
    var url = Uri.https('dresscabinet.com', 'api/iptal-iade-olustur');
    var response = await http.post(
      url,
      body: {
        'uye_id': client.id.toString(),
        'siparis_id': order.orderId.toString(),
        'iban_ad_soyad': displayName,
        'iban': iban,
        'not': caption,
        'urunler': jsonEncode(urunler),
      },
    );
    return response.body;
  }

  static Future sendTransferForm(int clientId, int orderId, String total,
      String caption, int bankId) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/havale-bildirim-formu');
    var response = await http.post(url, body: {
      'uye_id': clientId.toString(),
      'siparis_id': orderId.toString(),
      'banka_id': bankId.toString(),
      'tutar': total,
      'aciklama': caption,
    });

    return response.body;
  }

  static Future createNewOrder(
    Client client,
    Address deliveryAddress,
    Address billingAddress,
    String paymentType,
    List<Basket> products,
    String note,
    double shippingPay,
    bool rAddress,
    BankTransfer bank,
    Province province,
    District district,
    Province billingProvince,
    District billingDistrict,
  ) async {
    var url = Uri.https('dresscabinet.com', 'api/siparis-olustur');
    var response = await http.post(
      url,
      body: {
        'uye_id': client.id.toString(),
        'teslimat_adres_basligi': deliveryAddress.title,
        'teslimat_adi_soyadi': client.displayName,
        'teslimat_email': client.email,
        'teslimat_telefon': client.phone,
        'teslimat_ulke': '223',
        'teslimat_il_adi': province.name,
        'teslimat_ilce_adi': district.name,
        'teslimat_adres': deliveryAddress.address,
        'adres_ayni_bilgi': rAddress ? '1' : "0",
        if (!rAddress) 'fatura_adres_basligi': billingAddress.title,
        if (!rAddress) 'fatura_firma_adi': billingAddress.title,
        if (!rAddress) 'fatura_adi_soyadi': client.displayName,
        if (!rAddress) 'fatura_turu': '1',
        if (!rAddress) 'fatura_tc_kimlik_no': '',
        if (!rAddress) 'fatura_vergi_no': '',
        if (!rAddress) 'fatura_vergi_dairesi': '',
        if (!rAddress) 'fatura_ulke': '223',
        if (!rAddress) 'fatura_il_adi': billingProvince.name,
        if (!rAddress) 'fatura_ilce_adi': billingDistrict.name,
        if (!rAddress) 'fatura_adres': billingAddress.address,
        'siparis_no': (Random().nextInt(99999) + 10000).toString(),
        'siparis_aciklama': note,
        'payment_id': paymentType == 'credit_card' ? "1" : "2",
        if (paymentType == "transfer") 'havale_id': bank.id.toString(),
        'kupon_kodu': 'null',
        'kupon_tutar': 'null',
        'odeme_tipi_indirim_tutar': '0',
        'kargo_tutar': shippingPay.toStringAsFixed(2),
        'kargo_id': "1",
        'urunler': jsonEncode(products
            .map((e) => {
                  'urun_id': e.productId.toString(),
                  'adet': e.piece.toString(),
                  'sepet_indirim_tutar': '0',
                  'sepet_indirim_kural': null,
                  'uye_indirim_tutar': '0',
                  'uye_indirim_kural': null,
                  'urun_varyant': e.variant,
                  'urun_varyant_id': e.variant,
                })
            .toList()),
      },
    );
    return response.body;
  }
}
