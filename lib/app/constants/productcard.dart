import 'package:carousel_slider/carousel_slider.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
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

class ProductCard extends StatefulWidget {
  final Product oldProduct;
  final int axisCount;
  final Product product;
  final Client client;
  final List<Product> allProducts;
  final ConstSettings settings;
  final Function(Product) onTapped;
  const ProductCard(
      {Key key,
      this.axisCount,
      @required this.product,
      this.onTapped,
      this.oldProduct,
      @required this.client,
      @required this.allProducts,
      @required this.settings})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Product product;
  int currectImageIndex = 0;
  bool isLiked = false;

  @override
  void initState() {
    setState(() {
      product = widget.product;
    });
    _likeController();

    super.initState();
  }

  _likeTapped() async {
    if (widget.client == null) {
      _nullClientError();
    } else {
      if (!isLiked) {
        dynamic body = await UserFunc.addLike(widget.client.id, product.id);
        if (body == "1") {
          setState(() {
            isLiked = true;
          });
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: body);
        }
      } else {
        dynamic body = await UserFunc.removeLike(widget.client.id, product.id);
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

  _likeController() {
    if (widget.client != null) {
      for (Map favori in widget.client.favorites) {
        if (favori["urun_id"] == widget.product.id.toString()) {
          setState(() {
            isLiked = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    double cardSize = (size.width / (widget.axisCount ?? 2)) - 16.0;
    return InkWell(
      onTap: () {
        if (widget.onTapped == null) {
          Navigate.nextdelay(
            context,
            ProductScreen(
              allProducts: widget.allProducts,
              settings: widget.settings,
              isLiked: isLiked,
              likeTapped: _likeTapped,
              product: product,
              imageIndex: currectImageIndex,
            ),
          );
        } else {
          widget.onTapped(product);
          setState(() {
            product = widget.oldProduct;
          });
        }
      },
      borderRadius: BorderRadius.circular(8.0),
      child: AnimatedContainer(
        width: cardSize,
        decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white70,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6.0),
            ]),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4.5,
              child: Stack(
                children: [
                  _buildImages(),
                  if (product.isFreeShipping || product.isNew) _buildTags(),
                  _buildFavoriteButton(product, isLiked),
                  _buildIndicator(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 8.0),
                  _buildPrices(),
                ],
              ),
            )
          ],
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

  Align _buildIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: product.images
            .asMap()
            .entries
            .map((e) => e.key >= 2
                ? const SizedBox()
                : Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: currectImageIndex == e.key
                          ? Colors.black87
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 2.0,
                    ),
                  ))
            .toList(),
      ),
    );
  }

  _buildTags() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (product.isNew)
            Container(
              margin: const EdgeInsets.only(bottom: 4.0),
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70,
              ),
              child: const Center(
                  child: Text(
                'Yeni\nÜRÜN',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500),
              )),
            ),
          if (product.isFreeShipping)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.withOpacity(0.8),
              ),
              child: const Center(
                  child: Text(
                'Ücretsiz\nKARGO',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500),
              )),
            ),
        ],
      ),
    );
  }

  Align _buildFavoriteButton(Product product, bool isLiked) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => _likeTapped(),
        icon: Iconify(Ri.heart_2_fill,
            color: isLiked ? Colors.red : Colors.white),
      ),
    );
  }

  Row _buildPrices() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.salePrice.toString() + product.currencyUnit,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (product.marketPrice != 0)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              product.marketPrice.toString() + product.currencyUnit,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      product.name.replaceAll('i', 'İ').toUpperCase(),
      style: const TextStyle(fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  AspectRatio _buildImages() {
    return AspectRatio(
      aspectRatio: 3 / 4.5,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: product.images.isNotEmpty
            ? CarouselSlider.builder(
                itemCount:
                    product.images.length > 2 ? 2 : product.images.length,
                itemBuilder: (context, index, realIndex) {
                  return Hero(
                    tag: product.images[index]['urun_resim'],
                    child: ConstWidgets.viewImage(
                      product.images[index]['urun_resim'],
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 3 / 4.5,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) =>
                      setState(() => currectImageIndex = index),
                  enableInfiniteScroll:
                      product.images.length == 1 ? false : true,
                ),
              )
            : Image.asset(
                'assets/images/no_image.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
