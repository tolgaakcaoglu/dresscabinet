import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/items/bottomnavigationitems.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/showcasemodal.dart';
import 'package:dresscabinet/app/screen/account/accountscreen.dart';
import 'package:dresscabinet/app/screen/basket/basketscreen.dart';
import 'package:dresscabinet/app/screen/categories/categoriesscreen.dart';
import 'package:dresscabinet/app/screen/favorites/favoritescreen.dart';
import 'package:dresscabinet/app/screen/home/homescreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'functions/pages/categoryfunctions.dart';
import 'functions/pages/homefunctions.dart';

class DressCabinet extends StatefulWidget {
  const DressCabinet({Key key}) : super(key: key);

  @override
  State<DressCabinet> createState() => _DressCabinetState();
}

class _DressCabinetState extends State<DressCabinet> {
  int pageIndex = 0;
  bool splash = true;
  List<Product> products;
  List<Showcase> showcases;
  List allCategories;
  List mainCategories;
  int firstCategoryIndex;
  ConstSettings settings;
  bool connectionError = false;

  void onTappedBottomItem(val) => setState(() => pageIndex = val);

  @override
  void initState() {
    super.initState();
    _connectionControl();
  }

  _init() {
    _products();
    _getSettings();
  }

  _connectionControl() async {
    bool status = await JsonFunctions.connectionController();
    if (status) {
      _init();
    } else {
      setState(() {
        connectionError = true;
      });
    }
  }

  void _products() async {
    List json = await JsonFunctions.getProducts();
    if (json != null) {
      List<Product> p = [];
      for (Map<String, dynamic> data in json) {
        p.add(Product.fromJson(data));
      }

      if (mounted) {
        setState(() {
          products = p;
        });
        _showcases(p);
      }
    }
  }

  _showcases(List prods) async {
    List s = await HomeFunc.getShowcases(prods);

    if (mounted) {
      setState(() {
        showcases = s;
      });

      _getAllCategories();
    }
  }

  _getAllCategories() async {
    List all = await CategoryFunc.getCategories();
    if (mounted) {
      setState(() {
        allCategories = all;
      });

      _getMainCategories(all);
    }
  }

  _getMainCategories(List all) {
    List main = CategoryFunc.getMainCategories(all);
    if (mounted) {
      setState(() {
        firstCategoryIndex = main.first.id;
        mainCategories = main;
        splash = false;
      });
    }
  }

  _getSettings() async {
    Map set = await JsonFunctions.getSettings();
    if (mounted) {
      setState(() {
        settings = ConstSettings.build(set);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;
    return connectionError
        ? _connectionError(isDark, context)
        : splash == true
            ? Scaffold(
                backgroundColor: isDark ? Colors.black : Colors.white,
                body: ConstWidgets.loadingWidget(isDark))
            : WillPopScope(
                onWillPop: () async {
                  if (pageIndex == 0) {
                    return true;
                  } else {
                    setState(() => pageIndex = 0);
                    return false;
                  }
                },
                child: Scaffold(
                  body: getPage(),
                  bottomNavigationBar: _buildBottomNavigationBar(isDark),
                ),
              );
  }

  Scaffold _connectionError(bool isDark, BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/404.png'),
              ),
              const Text(
                'Neler olduğunu anlamaya çalışıyorum..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16.0),
              const Opacity(
                opacity: 0.7,
                child: Text(
                  'Sana daha iyi bir kullanım sunabilmek adına, altyapıda düzenleme veya yenilikler yapılıyor olabilir.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32.0),
              CupertinoButton(
                color: CupertinoColors.systemPurple,
                child: const Text('yeniden dene'),
                onPressed: () => Navigate.rnext(context, const AilApp()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPage() {
    switch (pageIndex) {
      case 0:
        return HomeScreen(
            settings: settings,
            products: products,
            showcases: showcases,
            allCategories: allCategories);
        break;
      case 1:
        return CategoriesScreen(
            settings: settings,
            products: products,
            all: allCategories,
            main: mainCategories,
            firstIndex: firstCategoryIndex);
        break;
      case 2:
        return BasketScreen(allProducts: products, settings: settings);
        break;
      case 3:
        return FavoritesScreen(settings: settings, allProducts: products);
        break;
      case 4:
        return AccountScreen(allProducts: products, settings: settings);
        break;
      default:
        return HomeScreen(
            settings: settings,
            products: products,
            showcases: showcases,
            allCategories: allCategories);
    }
  }

  BottomNavigationBar _buildBottomNavigationBar(bool isDark) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 26.0,
      selectedFontSize: 13.0,
      unselectedFontSize: 13.0,
      elevation: 16.0,
      backgroundColor: isDark ? Colors.black : Colors.white,
      currentIndex: pageIndex,
      selectedItemColor: isDark ? Colors.white : Colors.black,
      unselectedItemColor: isDark ? Colors.white : Colors.black,
      onTap: onTappedBottomItem,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      items: bottomItems(isDark),
    );
  }

  BottomNavigationBarItem buildBottomItem(icon, activeIcon, label) =>
      BottomNavigationBarItem(
          icon: Iconify(icon), activeIcon: Iconify(activeIcon), label: label);
}
