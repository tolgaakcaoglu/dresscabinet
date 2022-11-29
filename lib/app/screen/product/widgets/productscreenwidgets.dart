import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/constants/productcard.dart';
import 'package:dresscabinet/app/database/basketdatabase.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/bankmodal.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/variantsmodal.dart';
import 'package:dresscabinet/app/screen/basket/basketscreen.dart';
import 'package:dresscabinet/app/screen/signup/login.dart';
import 'package:dresscabinet/app/screen/view/viewphoto.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class ProductScreenAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function heartTapped;
  final bool isLiked;
  const ProductScreenAppBar(
      {Key key, @required this.heartTapped, @required this.isLiked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return AppBar(
      title: SizedBox(
        height: 18.0,
        child: Image.asset(isDark
            ? 'assets/images/logo_dark.png'
            : 'assets/images/logo_light.png'),
      ),
      actions: [
        IconButton(
          onPressed: heartTapped,
          icon: Iconify(
            isLiked ? Ri.heart_2_fill : Ri.heart_2_line,
            color: isLiked
                ? Colors.red
                : isDark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProductScreenImages extends StatefulWidget {
  final Product product;
  final int recentImage;
  const ProductScreenImages(
      {Key key, @required this.product, @required this.recentImage})
      : super(key: key);

  @override
  State<ProductScreenImages> createState() => _ProductScreenImagesState();
}

class _ProductScreenImagesState extends State<ProductScreenImages> {
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() => selectedImageIndex = widget.recentImage);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4.5,
      child: widget.product.images.isNotEmpty
          ? Stack(
              children: [
                _buildSlider(),
                if (widget.product.isFreeShipping || widget.product.isNew)
                  _buildTags(),
                _buildIndicator(),
              ],
            )
          : Image.asset(
              'assets/images/no_image.jpg',
              fit: BoxFit.cover,
            ),
    );
  }

  _buildTags() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.product.isNew)
            Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              width: 64,
              height: 64,
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
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              )),
            ),
          if (widget.product.isFreeShipping)
            Container(
              width: 64,
              height: 64,
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
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              )),
            ),
        ],
      ),
    );
  }

  CarouselSlider _buildSlider() {
    return CarouselSlider.builder(
      itemCount: widget.product.images.length,
      itemBuilder: (context, index, realIndex) => InkWell(
        onTap: () => Navigate.next(context,
            ViewPhoto(photo: widget.product.images[index]['urun_resim'])),
        child: Hero(
          tag: widget.product.images[index]['urun_resim'],
          child: ConstWidgets.viewImage(
            widget.product.images[index]['urun_resim'],
          ),
        ),
      ),
      options: CarouselOptions(
        initialPage: widget.recentImage,
        aspectRatio: 3 / 4.5,
        viewportFraction: 1,
        onPageChanged: (index, reason) =>
            setState(() => selectedImageIndex = index),
        enableInfiniteScroll: widget.product.images.length == 1 ? false : true,
        autoPlay: false,
      ),
    );
  }

  Align _buildIndicator() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.product.images
              .asMap()
              .entries
              .map(
                (e) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 16.0,
                  height: e.key == selectedImageIndex ? 16.0 : 4.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      e.key == selectedImageIndex ? 4.0 : 2.0,
                    ),
                    color: e.key == selectedImageIndex
                        ? Colors.black87
                        : Colors.black26,
                  ),
                  child: e.key == selectedImageIndex
                      ? Center(
                          child: Text(
                            (e.key + 1).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ProductScreenTitle extends StatelessWidget {
  final String title;
  const ProductScreenTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
      child: Text(
        title.replaceAll('i', 'İ').toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class ProductScreenCode extends StatelessWidget {
  final String code;
  const ProductScreenCode({Key key, @required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Opacity(opacity: 0.8, child: Text('Stok Kodu: ($code)')),
    );
  }
}

class ProductScreenPrices extends StatelessWidget {
  final double salePrice, marketPrice;
  final String currencyUnit;
  const ProductScreenPrices(
      {Key key,
      @required this.salePrice,
      @required this.marketPrice,
      @required this.currencyUnit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            salePrice.toString() + currencyUnit,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (marketPrice != 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                marketPrice.toString() + currencyUnit,
                style: TextStyle(
                  fontSize: 18.0,
                  decoration: TextDecoration.lineThrough,
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class ProductScreenReviewStars extends StatelessWidget {
  const ProductScreenReviewStars({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(children: _getStar(isDark)),
    );
  }

  List<Widget> _getStar(bool isDark) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(
        Iconify(Ri.star_fill, color: isDark ? Colors.amber : Colors.black),
      );
    }
    return stars;
  }
}

class ProductScreenCaptionWidget extends StatelessWidget {
  final Product product;
  const ProductScreenCaptionWidget({Key key, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Divider(height: 1.0),
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 4.0),
          child: const Opacity(
            opacity: 0.5,
            child: Text(
              'ÜRÜN HAKKINDA',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Opacity(
            opacity: 0.5,
            child: Text(product.caption),
          ),
        ),
      ],
    );
  }
}

class ProductScreenColorVariants extends StatelessWidget {
  final List<Product> variants;
  final Function refreshProduct;
  const ProductScreenColorVariants(
      {Key key, @required this.variants, @required this.refreshProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('RENK'),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            height: 120.0,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: ConstUtils.iosPhysics,
              scrollDirection: Axis.horizontal,
              children: variants.map((e) {
                Product variant = e;
                return AspectRatio(
                  aspectRatio: 3 / 4.5,
                  child: Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        refreshProduct(e);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: variant.images.isNotEmpty
                            ? ConstWidgets.viewImage(
                                variant.images.first['urun_resim'])
                            : Image.asset('assets/images/no_image.jpg'),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductScreenSizeVariants extends StatelessWidget {
  final List<Variant> variants;
  final int selectedSize, selectedPiece;
  final Function setState;
  const ProductScreenSizeVariants(
      {Key key,
      @required this.variants,
      @required this.selectedSize,
      @required this.selectedPiece,
      @required this.setState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BEDEN'),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: variants.asMap().entries.map((e) {
                Variant variant = e.value;
                return Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  height: 42.0,
                  constraints: const BoxConstraints(minWidth: 42.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: variant.stock < 1
                          ? isDark
                              ? Colors.white12
                              : Colors.black.withOpacity(0.05)
                          : _getColor(isDark),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    color: selectedSize == e.key
                        ? variant.stock < 1
                            ? isDark
                                ? Colors.white10
                                : Colors.black.withOpacity(0.05)
                            : _getColor(isDark)
                        : Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (variant.stock < 1) {
                        ConstUtils.toast(
                          '${variant.value.toUpperCase()} bedeni tükendi',
                        );
                      } else {
                        setState(e, variant);
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          variant.value.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: variant.stock < 1
                                ? selectedSize == e.key
                                    ? Colors.white
                                    : Colors.grey
                                : selectedSize == e.key
                                    ? isDark
                                        ? Colors.black
                                        : Colors.white
                                    : _getColor(isDark),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  _getColor(bool isDark) => isDark ? Colors.white : Colors.black;
}

class ProductScreenPieceCounter extends StatelessWidget {
  final int selectedPiece, selectedSize;
  final Function tappedMinus, tappedPlus;
  final List<Variant> sizeVariants;

  const ProductScreenPieceCounter({
    Key key,
    @required this.selectedPiece,
    @required this.selectedSize,
    @required this.sizeVariants,
    @required this.tappedMinus,
    @required this.tappedPlus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 42.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconButton(isDark, Ri.subtract_line, tappedMinus),
                _buildCount(isDark),
                _iconButton(isDark, Ri.add_line, tappedPlus),
              ],
            ),
          ),
          if (selectedSize != null && sizeVariants[selectedSize].stock <= 5)
            _buildCriticalStock(),
        ],
      ),
    );
  }

  Container _buildCount(bool isDark) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      child: Text(
        selectedPiece.toString(),
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _iconButton(bool isDark, String icon, Function onTap) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        width: 42.0,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          icon: Iconify(
            icon,
            color: isDark ? Colors.white54 : Colors.black54,
            size: 16.0,
          ),
        ),
      );

  Widget _buildCriticalStock() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 42.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: sizeVariants[selectedSize].stock < 1
              ? Colors.red
              : Colors.deepOrange,
        ),
        child: Center(
          child: sizeVariants[selectedSize].stock <= 0
              ? const Text(
                  'STOKTA YOK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      const TextSpan(text: 'SON '),
                      TextSpan(
                        text: sizeVariants[selectedSize].stock.toString(),
                      ),
                      const TextSpan(text: ' ADET')
                    ],
                  ),
                ),
        ),
      );
}

class ProductScreenBodyTable extends StatelessWidget {
  final List shippingBrans;
  const ProductScreenBodyTable({Key key, @required this.shippingBrans})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    viewBodySizes() {
      row(r1, r2, r3, r4, r5) => TableRow(children: [
            rowItem(r1),
            rowItem(r2),
            rowItem(r3),
            rowItem(r4),
            rowItem(r5)
          ]);

      return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Text(
                      'Bayan Grubu Beden Ölçüleri(cm.)',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Table(
                    border: TableBorder.all(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isDark ? Colors.white10 : Colors.black12),
                    children: [
                      row('Beden', 'Göğüs', 'Bel', 'Basen', 'İç Boy'),
                      row('24-34-XS', '82', '66', '90', '86'),
                      row('26-36-S', '86', '70', '94', '86'),
                      row('28-38-M', '90', '74', '98', '86'),
                      row('30-40-L', '94', '78', '102', '86'),
                      row('32-42-XL', '99', '83', '107', '86'),
                      row('34-44-XXL', '104', '88', '112', '86'),
                      row('36-46-3XL', '109', '93', '117', '86'),
                      row('38-48-4XL', '114', '98', '112', '86'),
                      row('40-50-5XL', '119', '103', '127', '86'),
                    ],
                  ),
                ],
              ),
            )),
      );
    }

    return Container(
      height: 42.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          _tableButton(context, Ri.umbrella_line, 'BEDEN TABLOSU',
              () => viewBodySizes(), isDark),
          _tableButton(context, Ri.rocket_line, 'TESLİMAT BİLGİLERİ', () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Kargo Firmaları',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24.0),
                        ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: shippingBrans
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(e["kargo_firma_adi"]),
                                    ))
                                .toList()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, isDark),
        ],
      ),
    );
  }

  Padding rowItem(r1) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(r1, textScaleFactor: 0.8)),
    );
  }

  Widget _tableButton(
    BuildContext context,
    String icon,
    String tableName,
    Function onTap,
    bool isDark,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: (MediaQuery.of(context).size.width - 40) / 2,
        height: 42.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: isDark ? Colors.white : Colors.black),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(
                  icon,
                  size: 14.0,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 4.0),
                Text(
                  tableName,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ProductScreenSocialButtons extends StatelessWidget {
  final Client client;
  final Function update;
  final Product product;
  const ProductScreenSocialButtons(
      {Key key,
      @required this.product,
      @required this.client,
      @required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;
    Size size = MediaQuery.of(context).size;
    double cardWidth = (size.width - 64.0) / 3;

    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
      child: Wrap(
        spacing: 16.0,
        children: [
          _buildCard(
            cardWidth,
            isDark,
            Ri.whatsapp_line,
            'Whatsapp\nHattı',
            () => ConstUtils.openWhatsapp(
              title:
                  '${product.name} ile ilgili sizinle iletişime geçmek istiyorum. [Ürün kodu: ${product.code}]',
            ),
          ),
          _buildCard(
            cardWidth,
            isDark,
            Ri.arrow_down_circle_line,
            'Fiyat Düşünce\nHaber Ver',
            () {
              if (client == null) {
                showDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Oturum Aç'),
                    content: const Text(
                        'Ürünün fiyatı düştüğünde haber almak için oturum açmalısınız.'),
                    actions: [
                      CupertinoButton(
                        child: const Text('Giriş Yap'),
                        onPressed: () => Navigator.of(context)
                          ..pop()
                          ..push(Navigate.route(const LoginScreen())),
                      )
                    ],
                  ),
                );
              } else {
                if (client.alerts
                    .where((alert) => alert.productId == product.id)
                    .isEmpty) {
                  UserFunc.addAlert(client.id.toString(), product.id.toString())
                      .then((body) {
                    if (body == "1") {
                      update();
                      showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Başarılı'),
                          content: const Text('Ürün alarm  listenize eklendi.'),
                          actions: [
                            CupertinoButton(
                              child: const Text('Tamam'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ),
                      );
                    }
                  });
                } else {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                      msg: 'Ürün zaten alarm listenizde mevcut');
                }
              }
            },
          ),
          _buildCard(
            cardWidth,
            isDark,
            Ri.user_5_line,
            'Arkadaşlarına\nTavsiye Et',
            () => ConstUtils.recommendYourFriend(productName: product.name),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double cardWidth, bool isDark, String icon, String title,
      Function onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(
                  icon,
                  color: isDark ? Colors.white : Colors.blueGrey.shade600,
                  size: 42.0,
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductScreenShippingDate extends StatelessWidget {
  const ProductScreenShippingDate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          const Iconify(Ri.timer_flash_line, size: 48.0, color: Colors.green),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TAHMİNİ TESLİMAT ZAMANI',
                style: TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  _dateText(
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day + 4,
                    ),
                  ),
                  const Text(' - '),
                  _dateText(
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day + 7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text _dateText(DateTime date) => Text(ConstUtils.getDate(date),
      style: const TextStyle(fontWeight: FontWeight.w500));
}

class ProductScreenInfoCards extends StatelessWidget {
  const ProductScreenInfoCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return GridView(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      children: [
        _buildCard(
          context,
          'KREDİ KARTINA TAKSİT SEÇENEKLERİ',
          'credit_card.svg',
          isDark,
        ),
        _buildCard(
          context,
          'KAPIDA NAKİT ÖDEME SEÇENEĞİ',
          'home.svg',
          isDark,
        ),
        _buildCard(
          context,
          '300₺ ÜSTÜ SİPARİŞLER ÜCRETSİZ KARGO',
          'shipping.svg',
          isDark,
        ),
        _buildCard(
          context,
          '1-3 İŞ GÜNÜ İÇERİSİNDE TESLİMAT',
          'box.svg',
          isDark,
        ),
      ],
    );
  }

  Container _buildCard(
      BuildContext context, String caption, String icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.0,
                height: 48.0,
                child: SvgPicture.asset('assets/icons/$icon',
                    color: isDark ? Colors.white : Colors.blueGrey.shade600,
                    semanticsLabel: 'A red up arrow'),
              ),
              const SizedBox(height: 16.0),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  height: 1.6,
                  color: isDark ? Colors.white : Colors.blueGrey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductScreenPaymenetOptionsAccordion extends StatefulWidget {
  final Product product;
  const ProductScreenPaymenetOptionsAccordion({Key key, @required this.product})
      : super(key: key);

  @override
  State<ProductScreenPaymenetOptionsAccordion> createState() =>
      _ProductScreenPaymenetOptionsAccordionState();
}

class _ProductScreenPaymenetOptionsAccordionState
    extends State<ProductScreenPaymenetOptionsAccordion> {
  List<Bank> banks;

  void _getBanks() async {
    List json = await JsonFunctions.getBankOptions();
    if (mounted) {
      if (json != null) {
        List<Bank> b = [];
        for (Map<String, dynamic> data in json) {
          b.add(Bank.fromJson(data));
        }

        setState(() {
          banks = b;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _getBanks();
  }

  @override
  Widget build(BuildContext context) {
    return banks != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpansionTile(
              title: const Text('Taksit Seçenekleri'),
              children: banks
                  .asMap()
                  .entries
                  .map((e) => _listtile(banks[e.key]))
                  .toList(),
            ),
          )
        : const SizedBox();
  }

  Widget _listtile(Bank bank) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 32.0,
            maxHeight: 60.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: CachedNetworkImage(imageUrl: bank.image),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(color: Colors.green),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.green),
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildText('TAKSİT', color: Colors.white),
                  ),
                ),
                _buildText('AYLIK', color: Colors.white),
                _buildText('TOPLAM', color: Colors.white),
              ],
            ),
          ],
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(color: Colors.blueGrey),
          children: bank.options
              .map((row) =>
                  paymentOptionsTableRow(row, widget.product.salePrice))
              .toList(),
        ),
      ],
    );
  }

  TableRow paymentOptionsTableRow(Percent percent, double price) {
    double yuzdeFiyat = (price / 100) * percent.percent;
    double total = price + yuzdeFiyat;
    return TableRow(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildText(percent.count.toString()),
          ),
        ),
        _buildText((total / percent.count).toStringAsFixed(2) +
            widget.product.currencyUnit),
        _buildText(total.toStringAsFixed(2) + widget.product.currencyUnit),
      ],
    );
  }

  Center _buildText(String text, {Color color}) => Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: color ?? Theme.of(context).textTheme.bodyText2.color),
        ),
      );
}

class ProductScreenCommentAccordion extends StatelessWidget {
  final Product product;
  const ProductScreenCommentAccordion({Key key, this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ExpansionTile(
        subtitle: const Opacity(
          opacity: 0.7,
          child: Text('✍️ \${widget.comments.length} adet yorum',
              style: TextStyle(fontSize: 12.0)),
        ),
        title: const Text('Yorumlar'),
        children: [
          ListTile(
            isThreeLine: true,
            leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/no_image.jpg')),
            title: const Text('\${widget.comment.content}'),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('\${widget.user.name}'),
                Text('\${widget.comment.created}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductScreenBottomBar extends StatelessWidget {
  final bool showAddProductCard, isAdded;
  final Product product;
  final int selectedPiece;
  final Function update;
  final String selectedSize;
  final ConstSettings settings;
  final List<Product> allProducts;
  const ProductScreenBottomBar(
      {Key key,
      @required this.showAddProductCard,
      @required this.product,
      @required this.isAdded,
      @required this.selectedPiece,
      @required this.update,
      @required this.selectedSize,
      @required this.settings,
      @required this.allProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 150),
        width: showAddProductCard
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width - 64,
        child: AnimatedOpacity(
          curve: Curves.easeOut,
          opacity: showAddProductCard ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: showAddProductCard,
            child: Container(
              height: kToolbarHeight,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: isDark ? Colors.grey.shade900 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8.0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            '${product.salePrice.toString()}${product.currencyUnit} * ${selectedPiece.toString()} ADET',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (product.salePrice * selectedPiece)
                                      .toStringAsFixed(2) +
                                  product.currencyUnit,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3 + 16,
                    height: kToolbarHeight,
                    child: CupertinoButton(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: Colors.green,
                      disabledColor: Colors.grey,
                      onPressed:
                          selectedSize == null || selectedPiece < 1 || isAdded
                              ? null
                              : () {
                                  Basket basket = Basket(
                                    basketDiscount: null,
                                    brand: '',
                                    currencyUnit: product.currencyUnit,
                                    kdv: 0,
                                    marketPrice: product.marketPrice,
                                    memberDiscount: null,
                                    note: '',
                                    piece: selectedPiece,
                                    productId: product.id,
                                    productName: product.name,
                                    salePrice: product.salePrice,
                                    variant: selectedSize,
                                  );
                                  LocalDb.instance.create(basket);

                                  update();

                                  showPop(context);
                                },
                      child: Text(
                        isAdded ? 'SEPETE EKLENDİ' : 'SEPETE EKLE',
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showPop(BuildContext context) {
    return showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.1),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Ürün sepetinize eklendi',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      const Text('Ürünü şimdi sepetinizde görebilirsiniz.'),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              color: Colors.amber,
                              child: const Text(
                                'Sepete git',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () => Navigate.next(
                                context,
                                BasketScreen(
                                  allProducts: allProducts,
                                  settings: settings,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text(
                                'Devam et',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () => Navigate.back(context),
                            ),
                          ),
                        ],
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
}

class ProductScreenRecommededProducts extends StatefulWidget {
  final Client client;
  final Product product;
  final List<Product> allProducts;
  final ConstSettings settings;
  final Function(Product) newProductSelected;
  const ProductScreenRecommededProducts(
      {Key key,
      @required this.product,
      @required this.newProductSelected,
      @required this.client,
      @required this.allProducts,
      @required this.settings})
      : super(key: key);

  @override
  State<ProductScreenRecommededProducts> createState() =>
      _ProductScreenRecommededProductsState();
}

class _ProductScreenRecommededProductsState
    extends State<ProductScreenRecommededProducts> {
  List<Product> recommendedProducts;

  @override
  void initState() {
    super.initState();

    _getOtherProducts();
  }

  @override
  Widget build(BuildContext context) {
    return widget.product.categories[0] != null &&
            widget.product.categories.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Opacity(
                    opacity: 0.7, child: Text('BUNLAR İLGİNİ ÇEKEBİLİR 😍')),
              ),
              SizedBox(
                height: 354.0,
                width: MediaQuery.of(context).size.width,
                child: recommendedProducts == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 16.0,
                          children:
                              recommendedProducts.asMap().entries.map((e) {
                            return ProductCard(
                              allProducts: widget.allProducts,
                              settings: widget.settings,
                              client: widget.client,
                              oldProduct: widget.product,
                              product: e.value,
                              onTapped: widget.newProductSelected,
                            );
                          }).toList(),
                        ),
                      ),
              )
            ],
          )
        : const SizedBox();
  }

  void _getOtherProducts() async {
    List json = await JsonFunctions.getProducts();
    List<Product> p = [];
    if (json != null) {
      for (Map<String, dynamic> data in json) {
        Product d = Product.fromJson(data);
        if (d.id != widget.product.id) {
          if (widget.product.categories[0] == d.categories[0]) {
            p.add(Product.fromJson(data));
          }
        }
      }
    }

    p.shuffle();

    if (mounted) {
      setState(() {
        recommendedProducts = p.sublist(0, p.length < 20 ? p.length : 20);
      });
    }
  }
}
