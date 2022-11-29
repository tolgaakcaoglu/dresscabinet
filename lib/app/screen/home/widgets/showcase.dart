import 'package:dresscabinet/app/constants/productcard.dart';
import 'package:dresscabinet/app/functions/constfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/showcasemodal.dart';
import 'package:flutter/material.dart';

class ShowcaseWidget extends StatelessWidget {
  final Showcase showcase;
  final Client client;
  final List<Product> allProducts;
  final ConstSettings settings;
  const ShowcaseWidget(
      {Key key,
      this.showcase,
      @required this.client,
      @required this.allProducts,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        children: [
          Text(
            showcase.name..replaceAll('i', 'İ').toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 2.0),
          Opacity(
            opacity: 0.75,
            child: Text(
              showcase.caption.replaceAll('i', 'İ').toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
              runSpacing: 12.0,
              spacing: 12.0,
              children: showcase.products.asMap().entries.map((e) {
                return e.key + 1 == showcase.products.length &&
                        ConstFunct.hideLastProduct(showcase.products.length)
                    ? const SizedBox()
                    : ProductCard(
                        settings: settings,
                        allProducts: allProducts,
                        product: e.value,
                        client: client);
              }).toList()),
        ],
      ),
    );
  }
}
