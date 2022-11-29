import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:flutter/material.dart';

class FreeShippingTag extends StatelessWidget {
  final ConstSettings settings;
  const FreeShippingTag({Key key, @required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      color: Colors.blueGrey,
      child: Text(
        '${settings.freeShippingLimit.toStringAsFixed(0)}TL VE ÜZERİ KARGO ÜCRETSİZ',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
