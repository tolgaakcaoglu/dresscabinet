import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/constfunc.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCardWidget extends StatefulWidget {
  final Function onTap;
  final bool isSelected;
  final Order order;
  final List<Product> allProduct;
  const OrderCardWidget(
      {Key key,
      this.onTap,
      this.isSelected,
      @required this.order,
      @required this.allProduct})
      : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  List<String> prodImages;
  double totalPayment = 0;

  void updateDetail(total, images, mDiscount, bDiscount, undiscTotal) =>
      setState(() {
        totalPayment = total;
        prodImages = images;
      });

  @override
  void initState() {
    super.initState();

    OrderFunc.getProductDetail(widget.allProduct, widget.order, updateDetail);
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    double width = (MediaQuery.of(context).size.width / 2) - 32;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white54,
        borderRadius: BorderRadius.circular(8.0).copyWith(
          topRight: const Radius.circular(30.0),
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8.0).copyWith(
          topRight: const Radius.circular(30.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _image(context, width),
                _checkIcon(context, isDark, width),
              ],
            ),
            Container(
              width: width,
              margin: const EdgeInsets.only(left: 12.0, top: 2, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sip. No: ${widget.order.orderNo}',
                    style: const TextStyle(fontSize: 10.0),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.order.basket.length.toString()} ürün',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          '• ${ConstFunct.dateFormat(widget.order.orderDate)}',
                          style: const TextStyle(fontSize: 10.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    totalPayment.toStringAsFixed(2) +
                        widget.order.basket.first.currencyUnit,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _image(context, width) {
    return prodImages != null
        ? Stack(
            children: prodImages
                .asMap()
                .entries
                .map((e) => _buildImage(context, width, e.key, e.value))
                .toList(),
          )
        : SizedBox(
            width: width,
            child: const AspectRatio(
              aspectRatio: 3 / 4.5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
  }

  Opacity _buildImage(BuildContext context, width, int index, String image) {
    return Opacity(
      opacity: (index + 1) * 0.33,
      child: Padding(
        padding: EdgeInsets.only(
            left: double.parse((index * 6).toString()),
            top: double.parse((index * 6).toString())),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: width,
            child: AspectRatio(
              aspectRatio: 3 / 4.5,
              child: image == ''
                  ? Image.asset('assets/images/no_image.jpg', fit: BoxFit.cover)
                  : ConstWidgets.viewImage(image),
            ),
          ),
        ),
      ),
    );
  }

  Container _checkIcon(BuildContext context, bool isDark, width) {
    return Container(
      margin: const EdgeInsets.only(top: 22.0, left: 6.0),
      width: width,
      child: AspectRatio(
        aspectRatio: 3 / 4.5,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.black : Colors.white,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 120),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: (widget.isSelected ?? false) ? 24.0 : 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
