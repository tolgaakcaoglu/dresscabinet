import 'package:cached_network_image/cached_network_image.dart';
import 'package:dresscabinet/app/database/basketdatabase.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class ProductBasketTile extends StatefulWidget {
  const ProductBasketTile(
      {Key key,
      @required this.basket,
      @required this.update,
      @required this.allProducts,
      @required this.client})
      : super(key: key);

  final List<Product> allProducts;
  final Basket basket;
  final Function update;
  final Client client;

  @override
  State<ProductBasketTile> createState() => _ProductBasketTileState();
}

class _ProductBasketTileState extends State<ProductBasketTile> {
  Product product;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    var p = OrderFunc.getProd(widget.allProducts, widget.basket.productId);
    if (mounted) {
      setState(() {
        product = p;
      });
    }
  }

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
              child: product == null || product.images.isEmpty
                  ? Image.asset(
                      'assets/images/no_image.jpg',
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: product.images.first['urun_resim'],
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
                widget.basket.productName.replaceAll('i', 'İ').toUpperCase(),
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
                  widget.basket.marketPrice == 0
                      ? Text(
                          widget.basket.salePrice.toString() +
                              widget.basket.currencyUnit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        )
                      : Text(
                          widget.basket.marketPrice.toString() +
                              widget.basket.currencyUnit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        ),
                  const SizedBox(width: 8.0),
                  if (widget.basket.marketPrice != 0)
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        widget.basket.salePrice.toString() +
                            widget.basket.currencyUnit,
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Opacity(
                opacity: 0.7,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 24.0, minHeight: 24.0),
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              width: 1,
                              color: isDark ? Colors.white70 : Colors.black87)),
                      child: Center(child: Text(widget.basket.variant)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            LocalDb.instance.remove(widget.basket.productId);
                            widget.update();
                          },
                          icon: Iconify(
                            Ri.delete_bin_7_line,
                            size: 18.0,
                            color: isDark ? Colors.white70 : Colors.black87,
                          )),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (widget.basket.piece > 1) {
                                Basket b = widget.basket
                                    .copy(piece: widget.basket.piece - 1);

                                LocalDb.instance.update(b);
                                widget.update();
                              }
                            },
                            icon: const Icon(Icons.remove, size: 16.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          widget.basket.piece.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (product.stock > widget.basket.piece) {
                                Basket b = widget.basket
                                    .copy(piece: widget.basket.piece + 1);

                                LocalDb.instance.update(b);
                                widget.update();
                              }
                            },
                            icon: const Icon(Icons.add, size: 16.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
