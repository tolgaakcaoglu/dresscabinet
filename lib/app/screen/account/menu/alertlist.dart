import 'package:cached_network_image/cached_network_image.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/alertmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/product/productscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class AdlertList extends StatefulWidget {
  final List<Product> allProducts;
  final Client client;
  final Function update;
  final ConstSettings settings;
  const AdlertList(
      {Key key,
      @required this.allProducts,
      @required this.client,
      @required this.update,
      @required this.settings})
      : super(key: key);

  @override
  State<AdlertList> createState() => _AdlertListState();
}

class _AdlertListState extends State<AdlertList> {
  List<Product> products;

  @override
  void initState() {
    super.initState();

    _getProduct();
  }

  void _getProduct() {
    List<Product> list = [];
    for (Product p in widget.allProducts) {
      for (ProductAlert alert in widget.client.alerts) {
        if (p.id == alert.productId) {
          list.add(p);
        }
      }
    }
    if (list == null) return;
    setState(() {
      products = list;
    });
  }

  _removeAlert(Product p) {
    products.remove(p);
    widget.update();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = Brightness.dark == brightness;
    return Scaffold(
      appBar: AppBar(title: const Text('ALARM LİSTESİ')),
      body: products == null
          ? ConstWidgets.loadingWidget(isDark)
          : products.isEmpty
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/images/mail_notification.png'),
                    ),
                    const SizedBox(height: 32.0),
                    const Opacity(
                        opacity: 0.7, child: Text('Alarm listeniz boş.')),
                  ],
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(4.0),
                  itemCount: products.length,
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemBuilder: (context, index) => defaultContainer(
                      context,
                      isDark,
                      ItemCard(
                          settings: widget.settings,
                          allProducts: widget.allProducts,
                          remove: _removeAlert,
                          product: products[index],
                          client: widget.client)),
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

class ItemCard extends StatefulWidget {
  const ItemCard(
      {Key key,
      @required this.product,
      @required this.client,
      @required this.remove,
      @required this.allProducts,
      @required this.settings})
      : super(key: key);

  final List<Product> allProducts;
  final ConstSettings settings;
  final Product product;
  final Client client;
  final Function remove;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isLiked = false;

  _likeController() {
    for (Map favori in widget.client.favorites) {
      if (favori["urun_id"] == widget.product.id.toString()) {
        setState(() {
          isLiked = true;
        });
      }
    }
  }

  _likeTapped() async {
    if (widget.client == null) {
      _nullClientError();
    } else {
      if (!isLiked) {
        dynamic body =
            await UserFunc.addLike(widget.client.id, widget.product.id);
        if (body == "1") {
          setState(() {
            isLiked = true;
          });
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: body);
        }
      } else {
        dynamic body =
            await UserFunc.removeLike(widget.client.id, widget.product.id);
        if (body == "1") {
          setState(() {
            isLiked = false;
          });
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: body);
        }
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Favoriden kalktı');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _likeController();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = Brightness.dark == brightness;

    return Row(
      children: [
        _buildImage(context),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 4.0),
              _buildPrices(),
              const SizedBox(height: 14.0),
              _viewProductButton(isDark, context),
            ],
          ),
        ),
        _removeFavoriteButton(isDark),
      ],
    );
  }

  Widget _removeFavoriteButton(bool isDark) {
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          UserFunc.removeAlert(
              widget.client.id.toString(), widget.product.id.toString());
          widget.remove(widget.product);
        },
        icon: Iconify(
          Ri.delete_bin_7_line,
          size: 22.0,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }

  SizedBox _viewProductButton(bool isDark, BuildContext context) {
    return SizedBox(
      height: 38.0,
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: isDark ? Colors.white10 : Colors.black,
        child: const Text(
          'Ürünü Gör',
          style: TextStyle(fontSize: 14.0),
        ),
        onPressed: () => Navigate.next(
            context,
            ProductScreen(
              settings: widget.settings,
              allProducts: widget.allProducts,
              isLiked: isLiked,
              likeTapped: _likeTapped,
              product: widget.product,
              imageIndex: 0,
            )),
      ),
    );
  }

  Row _buildPrices() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.salePrice.toString() + widget.product.currencyUnit,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      widget.product.name.replaceAll('i', 'İ').toUpperCase(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
    );
  }

  SizedBox _buildImage(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AspectRatio(
          aspectRatio: 3 / 4.5,
          child: widget.product.images.isNotEmpty
              ? Hero(
                  tag: widget.product.images.first['urun_resim'],
                  child: CachedNetworkImage(
                      imageUrl: widget.product.images.first['urun_resim']),
                )
              : Image.asset(
                  'assets/images/no_image.jpg',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  _nullClientError() => showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Maalesef!'),
          content: const Text('Favorilere eklemek için giriş yapmalısınız.'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
}
