import 'dart:async';

import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/main.dart';
import 'package:flutter/material.dart';

class PaymentRequestScreen extends StatefulWidget {
  final String status;
  const PaymentRequestScreen({Key key, @required this.status})
      : super(key: key);

  @override
  State<PaymentRequestScreen> createState() => _PaymentRequestScreenState();
}

class _PaymentRequestScreenState extends State<PaymentRequestScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigate.rnext(context, const AilApp());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widget.status == "success" ? _success() : _error()),
    );
  }

  Column _success() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/successful_order.png'),
        ),
        const SizedBox(height: 32.0),
        const Text(
          'Tebrikler! Siparişiniz Oluşturuldu.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Column _error() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.close_rounded, color: Colors.red),
        SizedBox(height: 32.0),
        Text(
          'Ödeme başarısız oldu',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
