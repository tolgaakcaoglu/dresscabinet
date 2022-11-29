import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/search/searchscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final List categories;
  final List all;
  final Client client;
  final List<Product> products;
  final ConstSettings settings;
  const CategoryCard(
      {Key key,
      @required this.categories,
      @required this.all,
      @required this.products,
      @required this.client,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: categories.length ?? 4,
          itemBuilder: (context, index) => item(context, categories[index])),
    );
  }

  item(BuildContext context, Map item) {
    String url = item['link'];
    List parsedUrl = url.split('/');
    String regexCategory = parsedUrl[parsedUrl.length - 2];

    Category getCategory() {
      Category c;
      for (Category cat in all) {
        if (ConstUtils.cleanText(cat.name) ==
            ConstUtils.cleanText(regexCategory)) {
          c = cat;
        }
      }
      return c;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(item['resim']),
                  fit: BoxFit.cover,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: () {
                  Navigate.next(
                    context,
                    SearchScreen(
                        settings: settings,
                        category: getCategory(),
                        client: client,
                        products: products),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
