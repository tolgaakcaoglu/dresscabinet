import 'dart:math';
import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/search/searchscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class CategoriesScreenAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Client client;
  final int selectedCategoryIndex;
  final List mainCategories;
  final Function updateCategory;
  final List<Product> products;
  final ConstSettings settings;
  const CategoriesScreenAppBarWidget(
      {Key key,
      @required this.mainCategories,
      this.selectedCategoryIndex,
      this.updateCategory,
      @required this.products,
      @required this.client,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: AppBar(
        title: const Text('KATEGORİLER'),
        actions: [
          IconButton(
            onPressed: () => Navigate.next(
              context,
              SearchScreen(
                settings: settings,
                products: products,
                client: client,
              ),
            ),
            icon: Iconify(
              Ri.search_2_line,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
        bottom: _appBarBottom(context, isDark, updateCategory),
      ),
    );
  }

  PreferredSize _appBarBottom(
      BuildContext context, bool isDark, Function updateCategory) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: mainCategories == null
                ? const CategoriesScreenAppBarPlaceholders()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      direction: Axis.horizontal,
                      children: mainCategories.map((e) {
                        Category category = e;

                        return CategoriesScreenTabItem(
                          category: category,
                          selectedCategoryIndex: selectedCategoryIndex,
                          updateCategory: updateCategory,
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50.0);
}

class CategoriesScreenAppBarPlaceholders extends StatelessWidget {
  const CategoriesScreenAppBarPlaceholders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          _buildPlaceHolderItem(isDark),
          _buildPlaceHolderItem(isDark),
          _buildPlaceHolderItem(isDark),
          _buildPlaceHolderItem(isDark),
          _buildPlaceHolderItem(isDark),
        ],
      ),
    );
  }

  Container _buildPlaceHolderItem(bool isDark) {
    return Container(
      height: 34.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black12,
          borderRadius: BorderRadius.circular(4.0)),
      child: Center(
        child: AnimatedContainer(
          width: Random().nextDouble() * 150,
          height: 16.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }
}

class CategoriesScreenTabItem extends StatelessWidget {
  final Category category;
  final int selectedCategoryIndex;
  final Function updateCategory;
  const CategoriesScreenTabItem(
      {Key key,
      @required this.category,
      @required this.selectedCategoryIndex,
      this.updateCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: () => updateCategory(category.id),
      child: Container(
        height: 34.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: selectedCategoryIndex == category.id
              ? isDark
                  ? Colors.white10
                  : Colors.black12
              : Colors.transparent,
        ),
        child: Center(
          child: Text(
            category.name
                .replaceAll('i', 'İ')
                .replaceAll('-', '&')
                .toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class CategoriesScreenListPlaceholders extends StatelessWidget {
  const CategoriesScreenListPlaceholders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    List<Widget> placeHolderList(BuildContext context, bool isDark) {
      List<Widget> list = [];
      for (int i = 0; i < 10; i++) {
        list.add(_listPlaceholderItem(context, isDark));
      }
      return list;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: placeHolderList(context, isDark),
        ),
      ),
    );
  }

  Padding _listPlaceholderItem(BuildContext context, bool isDark) {
    Size screen = MediaQuery.of(context).size;
    double textWidth = Random().nextDouble() * screen.width / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: isDark ? Colors.white10 : Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        minVerticalPadding: 26.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: textWidth,
              height: 20.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesScreenEmptySublist extends StatelessWidget {
  final List mainCategories;
  final Client client;
  final int selectedCategoryIndex;
  final List<Product> products;
  final ConstSettings settings;
  const CategoriesScreenEmptySublist(
      {Key key,
      @required this.mainCategories,
      @required this.selectedCategoryIndex,
      @required this.products,
      @required this.client,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 32.0,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${mainCategories.where((c) => c.id == selectedCategoryIndex).first.name.replaceAll('i', 'İ').toUpperCase()}" kategorisine ait bir alt kategori bulunmuyor.',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.6,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoButton(
                color: CupertinoColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Bu kategoriye ait ürünlere göz at.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Category c;

                  for (Category cat in mainCategories) {
                    if (cat.id == selectedCategoryIndex) {
                      c = cat;
                    }
                  }

                  Navigate.next(
                      context,
                      SearchScreen(
                          settings: settings,
                          category: c,
                          client: client,
                          products: products));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoriesScreenLists extends StatelessWidget {
  final Client client;
  final List subCategories;
  final List<Product> products;
  final ConstSettings settings;
  const CategoriesScreenLists(
      {Key key,
      @required this.subCategories,
      @required this.products,
      @required this.client,
      @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return ListView(
      physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      children: subCategories.map((e) {
        Category cat = e;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: _item(context, isDark, cat),
        );
      }).toList(),
    );
  }

  ListTile _item(BuildContext context, bool isDark, Category cat) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      tileColor: isDark ? Colors.white10 : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(cat.name),
      trailing: const Iconify(Ri.arrow_right_s_line, color: Colors.blueGrey),
      onTap: () {
        Navigate.next(
          context,
          SearchScreen(
              settings: settings,
              category: cat,
              client: client,
              products: products),
        );
      },
    );
  }
}
