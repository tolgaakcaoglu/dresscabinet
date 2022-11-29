import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ConstUtils {
  static toast(String message) => Fluttertoast.cancel()
      .then((value) => Fluttertoast.showToast(msg: message));

  static String decode(String child) {
    RegExp exp = RegExp(r"<[^>]*>",
        multiLine: true, caseSensitive: false, dotAll: true, unicode: true);
    return child.replaceAll(exp, ' ').replaceAll('&nbsp;', ' ');
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  static const iosPhysics = ScrollPhysics(
      parent: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()));

  static String getDate(DateTime date) {
    var month = date.month;
    String mon = '';
    switch (month) {
      case 1:
        mon = 'Ocak';
        break;
      case 2:
        mon = 'Şubat';
        break;
      case 3:
        mon = 'Mart';
        break;
      case 4:
        mon = 'Nisan';
        break;
      case 5:
        mon = 'Mayıs';
        break;
      case 6:
        mon = 'Haziran';
        break;
      case 7:
        mon = 'Temmuz';
        break;
      case 8:
        mon = 'Ağustos';
        break;
      case 9:
        mon = 'Eylül';
        break;
      case 10:
        mon = 'Ekim';
        break;
      case 11:
        mon = 'Kasım';
        break;
      case 12:
        mon = 'Aralık';
        break;

      default:
    }
    var time =
        '${date.day} ${mon.replaceAll('i', 'İ').toUpperCase().toUpperCase()}';
    return time;
  }

  static String cleanText(String text) {
    String t1 = text.trim().toLowerCase().replaceAll('ğ', 'g');
    String t2 = t1.replaceAll('Ğ', 'G');
    String t3 = t2.replaceAll('ı', 'i');
    String t4 = t3.replaceAll('İ', 'I');
    String t5 = t4.replaceAll('ö', 'o');
    String t6 = t5.replaceAll('Ö', 'O');
    String t7 = t6.replaceAll('ü', 'u');
    String t8 = t7.replaceAll('Ü', 'U');
    String t9 = t8.replaceAll('ş', 's');
    String t10 = t9.replaceAll('Ş', 'S');
    String t11 = t10.replaceAll('ç', 'c');
    String t12 = t11.replaceAll('Ç', 'C');
    String t13 = t12.replaceAll('(', '');
    String t14 = t13.replaceAll(')', '');
    String t15 = t14.replaceAll(' ', '-');
    return t15;
  }

  static Future openLink({@required String url}) => _launchUrl(url);

  static Future _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  static Future openWhatsapp({@required String title}) => _launchWp(title);

  static Future _launchWp(String title) async {
    String url =
        "whatsapp://send?phone=905307619077&text=${Platform.isIOS ? Uri.parse(title) : title}";
    String encoded = Uri.encodeFull(url);
    Uri uri = Uri.parse(encoded);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  static Future recommendYourFriend({@required String productName}) =>
      _launchRecommendWp(productName);

  static Future _launchRecommendWp(String productName) async {
    String message = 'Baksana DressCabinet\'te şöyle bir şey buldum 😋';
    String link =
        'https://dresscabinet.com/tr/arama/?q=${Uri.parse(productName)}';
    String encoded =
        Platform.isIOS ? Uri.parse('$message $link') : '$message $link';

    await Share.share(encoded);
  }
}
