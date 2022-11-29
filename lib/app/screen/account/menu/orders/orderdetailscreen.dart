import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ri.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<Product> allProducts;
  final Order order;
  const OrderDetailScreen(
      {Key key, @required this.allProducts, @required this.order})
      : super(key: key);

  @override
  State<OrderDetailScreen> createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  double totalPayment = 0;
  double totalPaymentUndiscount = 0;
  double memberDiscount = 0;
  double basketDiscount = 0;
  String orderStatus;

  void updateDetail(total, images, mDiscount, bDiscount, undiscTotal) {
    setState(() {
      totalPayment = total;
      memberDiscount = mDiscount;
      basketDiscount = bDiscount;
      totalPaymentUndiscount = undiscTotal;
    });
  }

  _orderStatus() async {
    String s = await OrderFunc.getOrderStatus(widget.order.orderStatusId);
    if (mounted) {
      setState(() {
        orderStatus = s;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    OrderFunc.getProductDetail(widget.allProducts, widget.order, updateDetail);
    _orderStatus();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('SİPARİŞ DETAY')),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              defaultContainer(
                  context,
                  isDark,
                  OrderInfoTile(
                    icon: Ri.shopping_bag_2_fill,
                    label: 'Sipariş No: ',
                    text: widget.order.orderNo.toString(),
                  )),
              defaultContainer(
                  context,
                  isDark,
                  OrderInfoTile(
                    icon: Ri.alarm_line,
                    label: 'Sipariş Durumu: ',
                    text: orderStatus ?? widget.order.orderStatusId.toString(),
                  )),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.order.basket.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = OrderFunc.getProd(widget.allProducts,
                        widget.order.basket[index].productId);
                    return defaultContainer(
                        context,
                        isDark,
                        OrderProductTile(
                            basket: widget.order.basket[index],
                            product: product));
                  }),
              defaultContainer(
                  context,
                  isDark,
                  OrderInfoTile(
                    icon: Ic.outline_shopping_cart_checkout,
                    label: 'Sipariş Oluşturma Tarihi: ',
                    text:
                        '${ConstUtils.getDate(widget.order.orderDate)} ${widget.order.orderDate.year}',
                  )),
              defaultContainer(
                  context,
                  isDark,
                  OrderInfoTile(
                    icon: Ri.money_dollar_circle_line,
                    label: 'Ödeme Tipi: ',
                    text: widget.order.paymentType,
                  )),
              defaultContainer(
                context,
                isDark,
                OrderPaymentCardWidget(
                  order: widget.order,
                  discountCouponAdded: false,
                  totalPay: totalPayment,
                  basketDiscount: basketDiscount,
                  memberDiscount: memberDiscount,
                  totalPaymentUndiscount: totalPaymentUndiscount,
                ),
              ),
              defaultContainer(
                  context,
                  isDark,
                  OrderInfoTile(
                    icon: Ri.barcode_box_line,
                    label: 'Kargo Firması: ',
                    text: widget.order.shippingBrand,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Container defaultContainer(BuildContext context, bool isDark, Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0)
            ],
            borderRadius: BorderRadius.circular(8.0)),
        child: child);
  }
}

class OrderProductTile extends StatelessWidget {
  const OrderProductTile(
      {Key key, @required this.basket, @required this.product})
      : super(key: key);

  final Basket basket;
  final Product product;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: AspectRatio(
            aspectRatio: 3 / 4.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: product.images.isNotEmpty
                  ? ConstWidgets.viewImage(product.images.first['urun_resim'])
                  : Image.asset(
                      'assets/images/no_image.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                basket.productName.replaceAll('i', 'İ').toUpperCase(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  basket.marketPrice == 0
                      ? Text(
                          basket.salePrice.toString() + basket.currencyUnit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        )
                      : Text(
                          basket.marketPrice.toString() + basket.currencyUnit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        ),
                  const SizedBox(width: 8.0),
                  if (basket.marketPrice != 0)
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        basket.salePrice.toString() + product.currencyUnit,
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Iconify(Ri.shopping_bag_2_line,
                      size: 15.0,
                      color: isDark ? Colors.white54 : Colors.black54),
                  const SizedBox(width: 4.0),
                  Text('${basket.piece.toString()} ADET',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: isDark ? Colors.white54 : Colors.black54)),
                ],
              ),
              const SizedBox(height: 12.0),
              Opacity(
                opacity: 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      constraints:
                          const BoxConstraints(minWidth: 24.0, minHeight: 24.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              width: 1,
                              color: isDark ? Colors.white70 : Colors.black87)),
                      child: Center(child: Text(basket.variant)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderInfoTile extends StatelessWidget {
  final String icon, label, text;
  const OrderInfoTile({Key key, this.icon, this.label, this.text})
      : super(key: key);

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
          if (icon != null)
            Iconify(icon,
                size: 16.0, color: isDark ? Colors.green : Colors.black87),
          const SizedBox(width: 4.0),
          if (label != null) Text(label),
          if (text != null)
            Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class OrderPaymentCardWidget extends StatelessWidget {
  final Order order;
  final bool discountCouponAdded;
  final double totalPay, memberDiscount, basketDiscount, totalPaymentUndiscount;

  const OrderPaymentCardWidget(
      {Key key,
      @required this.discountCouponAdded,
      @required this.totalPay,
      @required this.memberDiscount,
      @required this.basketDiscount,
      @required this.totalPaymentUndiscount,
      @required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const Divider(height: 24.0),
        _buildBasketPrice(
            totalPaymentUndiscount, order.basket.first.currencyUnit),
        const SizedBox(height: 4.0),
        _buildShipping(context, order),
        const Divider(height: 24.0),
        if (memberDiscount != 0)
          _couponPrice(
              'Üye İndirimi', memberDiscount, order.basket.first.currencyUnit),
        if (basketDiscount != 0)
          _couponPrice('Sepet İndirimi', basketDiscount,
              order.basket.first.currencyUnit),
        if (discountCouponAdded)
          _couponPrice('Kupon İndirimi', 25, order.basket.first.currencyUnit),
        _buildTotalPrice(totalPay, order.basket.first.currencyUnit),
      ],
    );
  }

  Row _buildTotalPrice(double totalPay, String currencyUnit) {
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
          totalPay.toStringAsFixed(2) + currencyUnit,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22.0),
        ),
      ],
    );
  }

  Column _couponPrice(String title, double price, String currencyUnit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                '-${price.toStringAsFixed(2) + currencyUnit}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const Divider(height: 24.0),
      ],
    );
  }

  Row _buildShipping(BuildContext context, Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Opacity(opacity: 0.7, child: Text('Kargo Ücreti')),
        Text(
          order.shippingPay == 0.0
              ? 'Ücretsiz'
              : order.shippingPay.toStringAsFixed(2) +
                  order.basket.first.currencyUnit,
          style: TextStyle(
            color: totalPay >= 300
                ? Colors.green
                : Theme.of(context).textTheme.bodyText2.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Opacity _buildBasketPrice(
      double totalPaymentUndiscount, String currentcyUnit) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sepet Tutarı'),
          Text(
            totalPaymentUndiscount.toStringAsFixed(2) + currentcyUnit,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Text _buildTitle() {
    return const Text(
      'Sipariş Özeti',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    );
  }
}
