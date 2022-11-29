import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/basket/payment/deliveryscreen.dart';
import 'package:dresscabinet/app/screen/signup/login.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasketPaymentCardWidget extends StatelessWidget {
  final bool discountCouponAdded;
  final List<Basket> baskets;
  final Client client;
  final double totalPayment;
  final List<Product> allProducts;
  final ConstSettings settings;
  final Function update;

  const BasketPaymentCardWidget(
      {Key key,
      @required this.discountCouponAdded,
      @required this.baskets,
      @required this.totalPayment,
      @required this.client,
      @required this.allProducts,
      @required this.update,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const Divider(height: 24.0),
        _buildBasketPrice(totalPayment),
        const SizedBox(height: 4.0),
        _buildShipping(context),
        const Divider(height: 24.0),
        if (discountCouponAdded) _couponPrice(),
        _buildTotalPrice(),
        _buildSubmitButton(context),
      ],
    );
  }

  Padding _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 46,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.green,
          onPressed: () => client == null
              ? Navigate.next(context, const LoginScreen())
              : Navigate.next(
                  context,
                  DeliveryScreen(
                    settings: settings,
                    update: update,
                    allProducts: allProducts,
                    client: client,
                    baskets: baskets,
                    totalPayment: totalPayment,
                  ),
                ),
          child: const Text('SEPETİ ONAYLA'),
        ),
      ),
    );
  }

  Row _buildTotalPrice() {
    final double total = totalPayment +
        (totalPayment < settings.freeShippingLimit ? settings.shippingPay : 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Opacity(
          opacity: 1,
          child: Text(
            'Toplam Tutar',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          total.toStringAsFixed(2) + baskets.first.currencyUnit,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22.0,
          ),
        ),
      ],
    );
  }

  Column _couponPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Kupon İndirimi'),
              Text(
                '-25TL',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 24.0),
      ],
    );
  }

  Widget _buildShipping(BuildContext context) {
    return Opacity(
      opacity: totalPayment >= settings.freeShippingLimit ? 1 : 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
              opacity: totalPayment >= settings.freeShippingLimit ? 0.7 : 1,
              child: const Text('Kargo Ücreti')),
          Text(
            totalPayment >= settings.freeShippingLimit
                ? 'Ücretsiz'
                : '${settings.shippingPay.toStringAsFixed(2)}TL',
            style: TextStyle(
              color: totalPayment >= settings.freeShippingLimit
                  ? Colors.green
                  : Theme.of(context).textTheme.bodyText2.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Opacity _buildBasketPrice(double totalPayment) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sepet Tutarı'),
          Text(
            totalPayment.toStringAsFixed(2) + baskets.first.currencyUnit,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Text _buildTitle() {
    return const Text(
      'Sipariş Özeti',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
