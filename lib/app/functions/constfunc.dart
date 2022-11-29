import 'package:intl/intl.dart';

class ConstFunct {
  static hideLastProduct(int length) {
    List<int> cn = [
      1,
      3,
      5,
      7,
      9,
      11,
      13,
      15,
      17,
      19,
      21,
      23,
      25,
      27,
      29,
      31,
      33,
      35,
      37,
      39,
      41,
      43,
      45,
      47,
      49
    ];

    bool status = cn.where((element) => element == length).isNotEmpty;
    return status;
  }

  static dateFormat(DateTime date) => DateFormat("dd.MM.yyyy").format(date);

  static String utfConvert(String text) {
    String copy = text;
    String replaced;

    String r1 = copy.replaceAll('&Ccedil;', 'Ç');
    String r2 = r1.replaceAll('&ccedil;', 'ç');
    String r3 = r2.replaceAll('&#350;', 'Ş');
    String r4 = r3.replaceAll('&#351;', 'ş');
    String r5 = r4.replaceAll('&#304;', 'İ');
    String r6 = r5.replaceAll('&#305;', 'ı');
    String r7 = r6.replaceAll('&Uuml;', 'Ü');
    String r8 = r7.replaceAll('&uuml;', 'ü');
    String r9 = r8.replaceAll('&Ouml;', 'Ö');
    String r10 = r9.replaceAll('&ouml;', 'ö');
    String r11 = r10.replaceAll('&#286;', 'Ğ');
    String r12 = r11.replaceAll('&#287;', 'ğ');

    replaced = r12;
    return replaced;
  }
}
