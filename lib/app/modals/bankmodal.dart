import 'package:flutter/material.dart';

class Bank {
  final String title, image;
  final List options;
  final Color color;

  Bank({this.color, this.title, this.image, this.options});

  factory Bank.fromJson(Map<String, dynamic> data) {
    return Bank(
      color: Color(int.parse('0xFF${data['bank_color'].replaceAll('#', '')}')),
      image: data['image'],
      title: data['type'],
      options: data['installment'].map((e) => Percent.fromJson(e)).toList(),
    );
  }
}

class Percent {
  final int count;
  final double percent;

  Percent({this.count, this.percent});

  factory Percent.fromJson(Map data) {
    return Percent(
      count: int.parse(data['number'].toString()),
      percent: double.parse(data['rate'].toString()),
    );
  }
}
