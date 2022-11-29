import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class BasketShippingTimeWidget extends StatelessWidget {
  const BasketShippingTimeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Opacity(
      opacity: 0.7,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(Ic.outline_shopping_cart_checkout,
              size: 16.0, color: isDark ? Colors.green : Colors.black87),
          const SizedBox(width: 4.0),
          const Text('Hızlı Gönderi: '),
          Text(
            ConstUtils.getDate(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day + 1)),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Text(' - '),
          Text(
            ConstUtils.getDate(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day + 3)),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
