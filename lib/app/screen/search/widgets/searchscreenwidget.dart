import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dresscabinet/app/constants/productcard.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreenCatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SearchScreenCatAppBar({
    Key key,
    @required this.textFieldChanged,
    @required this.skey,
    @required this.keyController,
    @required this.deleteKeyController,
  }) : super(key: key);
  final Function(String) textFieldChanged;
  final Function deleteKeyController;
  final String skey;
  final TextEditingController keyController;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return AppBar(title: _textField(isDark), actions: _appBarActions(isDark));
  }

  _textField(bool isDark) {
    return Stack(
      children: [
        if (skey.trim().isEmpty) _textFieldAnimationHint(isDark),
        TextField(
          autofocus: false,
          controller: keyController,
          maxLines: 1,
          scrollPadding: EdgeInsets.zero,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
          onChanged: textFieldChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),
        ),
      ],
    );
  }

  Padding _textFieldAnimationHint(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            'Hangi Ürünü Aramıştınız?',
            textStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions(bool isDark) {
    return [
      if (skey.trim().isNotEmpty)
        IconButton(
          icon: Iconify(
            Ri.close_fill,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => deleteKeyController(),
        ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchScreenNullKey extends StatelessWidget {
  const SearchScreenNullKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Image.asset('assets/images/null_search.png'),
          ),
          const SizedBox(height: 32.0),
          const Opacity(
            opacity: 0.7,
            child: Text('ARAMAYA BAŞLAYIN'),
          ),
        ],
      ),
    );
  }
}

class SearchScreenKeyNotFound extends StatelessWidget {
  const SearchScreenKeyNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Iconify(EmojioneMonotone.sad_but_relieved_face,
                  size: 32.0, color: isDark ? Colors.white70 : Colors.black87),
              const SizedBox(height: 16.0),
              const Text(
                'Aradığın şey hiçbir sonuç getirmedi. Farklı bir şeyler göstermeyi dene.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmartResfresherCustomFooter extends StatelessWidget {
  const SmartResfresherCustomFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Opacity(
              opacity: 0.5, child: Text("Gösterilecek bir şey kalmadı"));
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = const Text("yenilenemedi");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("daha fazla yükle");
        } else {
          body = const Text("gösterilecek bir şey kalmadı");
        }
        return SizedBox(height: 55.0, child: Center(child: body));
      },
    );
  }
}

class SearchScreenFilters extends StatelessWidget {
  final int viewingCount;
  final FixedExtentScrollController orderByController, colorPickerController;
  final Function(int) updateViewingCount, updateOrderType, updateSelectedColor;
  final List<String> colors;

  const SearchScreenFilters(
      {Key key,
      @required this.orderByController,
      @required this.viewingCount,
      @required this.updateViewingCount,
      @required this.updateOrderType,
      @required this.updateSelectedColor,
      @required this.colorPickerController,
      @required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0)
          .copyWith(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _filterMethodButton(
                  isDark, () => showOrderPopUp(context, isDark), 'SIRALA'),
              _filterMethodButton(
                  isDark, () => showColorsPopUp(context, isDark), 'RENKLER'),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _resizeButton(isDark, 1, Mdi.border_all_variant),
              _resizeButton(isDark, 2, Mdi.view_grid_outline),
            ],
          ),
        ],
      ),
    );
  }

  showColorsPopUp(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        colors.insert(0, 'Tümü');
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1,
                  diameterRatio: 1.4,
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  itemExtent: 50,
                  key: UniqueKey(),
                  scrollController: colorPickerController,
                  onSelectedItemChanged: updateSelectedColor,
                  children: colors.map((e) => Center(child: Text(e))).toList(),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: CupertinoButton(
                  onPressed: () {
                    Navigate.back(context);
                  },
                  child: const Text('SEÇ VE KAPAT'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showOrderPopUp(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1,
                  diameterRatio: 1.4,
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  itemExtent: 50,
                  key: UniqueKey(),
                  scrollController: orderByController,
                  onSelectedItemChanged: updateOrderType,
                  children: const [
                    Center(child: Text('Önerilen sıralama')),
                    Center(child: Text('Fiyata göre (Artan)')),
                    Center(child: Text('Fiyata göre (Azalan)')),
                    Center(child: Text('Ürün adına göre (A>Z)')),
                    Center(child: Text('Ürün adına göre (Z>A)')),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: CupertinoButton(
                  onPressed: () {
                    Navigate.back(context);
                  },
                  child: const Text('SEÇ VE KAPAT'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _resizeButton(bool isDark, int index, String icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 38.0,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        elevation: 0.0,
        onPressed: () => updateViewingCount(index),
        child: Iconify(
          icon,
          color: viewingCount == index
              ? isDark
                  ? Colors.white
                  : Colors.black
              : isDark
                  ? Colors.white54
                  : Colors.black54,
        ),
      ),
    );
  }

  Widget _filterMethodButton(bool isDark, Function ontap, String child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: isDark ? Colors.white10 : Colors.black12,
              ),
              borderRadius: BorderRadius.circular(4.0)),
          child: Text(
            child,
            style: TextStyle(
              fontSize: 12.0,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchScreenProductCount extends StatelessWidget {
  final int length;
  const SearchScreenProductCount({Key key, @required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
        child: Text('Toplam $length ürün gösteriliyor.'),
      ),
    );
  }
}

class SearchScreenAppliedFilters extends StatelessWidget {
  final Function cleanOrderbyFilter, cleanColorFilter;
  final String orderType, selectedColor, orderName;
  const SearchScreenAppliedFilters(
      {Key key,
      @required this.cleanOrderbyFilter,
      @required this.cleanColorFilter,
      @required this.orderType,
      @required this.selectedColor,
      @required this.orderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          if (orderType != null)
            Chip(
              onDeleted: cleanOrderbyFilter,
              deleteIcon: const Iconify(Ri.close_circle_line),
              label: Text(orderName),
            ),
          if (selectedColor != null)
            Chip(
              onDeleted: cleanColorFilter,
              deleteIcon: const Iconify(Ri.close_circle_line),
              label: Text(selectedColor),
            ),
        ],
      ),
    );
  }
}

class SearchScreenViewProductWidget extends StatelessWidget {
  final ConstSettings settings;
  final List<Product> allProducts, viewingProds;
  final int viewerCount;
  final Client client;
  const SearchScreenViewProductWidget(
      {Key key,
      @required this.settings,
      @required this.viewerCount,
      @required this.client,
      @required this.allProducts,
      @required this.viewingProds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Wrap(
            runSpacing: 8.0,
            spacing: 8.0,
            children: viewingProds
                .map((e) => ProductCard(
                    allProducts: allProducts,
                    settings: settings,
                    product: e,
                    axisCount: viewerCount,
                    client: client))
                .toList()));
  }
}
