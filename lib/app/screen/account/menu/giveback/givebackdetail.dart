import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/constfunc.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/givebackmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GiveBackDetail extends StatefulWidget {
  final Client client;
  final GiveBack give;
  final List<Product> allProducts;
  const GiveBackDetail(
      {Key key,
      @required this.give,
      @required this.allProducts,
      @required this.client})
      : super(key: key);

  @override
  State<GiveBackDetail> createState() => _GiveBackDetailState();
}

class _GiveBackDetailState extends State<GiveBackDetail> {
  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('İADE DETAY')),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              defaultContainer(
                context,
                isDark,
                Opacity(
                  opacity: 0.7,
                  child: Row(
                    children: [
                      const Text('IBAN: '),
                      Text(
                        widget.give.ibanNo,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              defaultContainer(
                context,
                isDark,
                Opacity(
                  opacity: 0.7,
                  child: Row(
                    children: [
                      const Text('Adı Soyadı: '),
                      Text(
                        widget.give.ibanDisplayName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: widget.give.products.length,
                itemBuilder: (context, index) {
                  return defaultContainer(
                    context,
                    isDark,
                    GiveBackOrderDetailTile(
                      allProducts: widget.allProducts,
                      gProduct: widget.give.products[index],
                    ),
                  );
                },
              ),
              if (widget.give.caption.isNotEmpty)
                defaultContainer(
                    context,
                    isDark,
                    Opacity(
                        opacity: 0.7,
                        child: Text('Açıklama: ${widget.give.caption}'))),
              defaultContainer(
                context,
                isDark,
                Opacity(
                  opacity: 0.7,
                  child: Row(
                    children: [
                      const Text('İade Talep Tarihi: '),
                      Text(
                        ConstFunct.dateFormat(widget.give.giveDate),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
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
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }
}

class GiveBackOrderDetailTile extends StatefulWidget {
  const GiveBackOrderDetailTile(
      {Key key, @required this.gProduct, @required this.allProducts})
      : super(key: key);

  final GiveBackProduct gProduct;
  final List<Product> allProducts;

  @override
  State<GiveBackOrderDetailTile> createState() =>
      _GiveBackOrderDetailTileState();
}

class _GiveBackOrderDetailTileState extends State<GiveBackOrderDetailTile> {
  Product product;
  String status = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    Product p = OrderFunc.getProd(widget.allProducts, widget.gProduct.id);
    if (mounted) {
      setState(() {
        product = p;
      });
      _getDetail();
    }
  }

  _getDetail() async {
    String s = await widget.gProduct.status;

    if (mounted) {
      setState(() {
        status = s;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const AspectRatio(
            aspectRatio: 1 / 1,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: AspectRatio(
                  aspectRatio: 3 / 4.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: product.images.isNotEmpty
                        ? ConstWidgets.viewImage(
                            product.images.first['urun_resim'])
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
                    Text(product.name.toUpperCase(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0)),
                    const SizedBox(height: 12.0),
                    Opacity(opacity: 0.7, child: Text('Durum: $status')),
                    const SizedBox(height: 4.0),
                    Opacity(
                        opacity: 0.7,
                        child: Text('İade Nedeni: ${widget.gProduct.cause}')),
                    const SizedBox(height: 4.0),
                    Opacity(
                        opacity: 0.7,
                        child: Text('İade Tipi: ${widget.gProduct.type}')),
                  ],
                ),
              ),
            ],
          );
  }
}
