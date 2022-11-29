import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class BasketCouponAddWidget extends StatefulWidget {
  final bool discountCouponAdded;
  final Function(TextEditingController) addCouponButton;
  const BasketCouponAddWidget(
      {Key key,
      @required this.discountCouponAdded,
      @required this.addCouponButton})
      : super(key: key);

  @override
  State<BasketCouponAddWidget> createState() => _BasketCouponAddWidgetState();
}

class _BasketCouponAddWidgetState extends State<BasketCouponAddWidget> {
  TextEditingController coupon = TextEditingController();
  bool couponIsNull = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('İndirim Kodu',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
        const SizedBox(height: 8.0),
        widget.discountCouponAdded
            ? BasketCouponAddedWidget(coupon: coupon)
            : SizedBox(
                height: 60,
                child: Row(children: [_buildTextField(), _buildButton()])),
      ],
    );
  }

  CupertinoButton _buildButton() {
    return CupertinoButton(
      onPressed: couponIsNull ? null : () => widget.addCouponButton(coupon),
      child: Text(
        'KULLAN',
        style: TextStyle(
          color: couponIsNull ? Colors.grey : Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Expanded _buildTextField() {
    return Expanded(
      child: TextField(
        controller: coupon,
        onChanged: (text) {
          // TODO KUPON DATASI ?
          if (text.trim().isEmpty) {
            setState(() {
              couponIsNull = true;
            });
          } else if (text.trim().isNotEmpty && couponIsNull) {
            setState(() {
              couponIsNull = false;
            });
          }
        },
        decoration: const InputDecoration(
          hintText: 'Kodu Giriniz',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class BasketCouponAddedWidget extends StatelessWidget {
  const BasketCouponAddedWidget({Key key, @required this.coupon})
      : super(key: key);

  final TextEditingController coupon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Iconify(Ri.coupon_2_line, color: Colors.amber, size: 16.0),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: coupon.text.trim().toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.amber,
              ),
              children: const [
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey,
                  ),
                  text: ' KODUNU KULLANDINIZ.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
