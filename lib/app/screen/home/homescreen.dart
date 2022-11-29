import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/showcasemodal.dart';
import 'package:dresscabinet/app/screen/home/widgets/bannerslider.dart';
import 'package:dresscabinet/app/screen/home/widgets/categorycard.dart';
import 'package:dresscabinet/app/screen/home/widgets/freeshippingtag.dart';
import 'package:dresscabinet/app/screen/home/widgets/showcase.dart';
import 'package:dresscabinet/app/screen/search/searchscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class HomeScreen extends StatefulWidget {
  final ConstSettings settings;
  final List<Product> products;
  final List<Showcase> showcases;
  final List allCategories;
  const HomeScreen(
      {Key key,
      @required this.products,
      @required this.showcases,
      @required this.allCategories,
      @required this.settings})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showBackToTopButton = false;
  ScrollController scrollController;
  bool splash = true;
  Client client;
  bool loaded = false;
  bool isAddedBasket = true;

  @override
  void initState() {
    super.initState();
    _getUser();
    scrollController = ScrollController()
      ..addListener(() => setState(() => scrollController.offset >= 400
          ? showBackToTopButton = true
          : showBackToTopButton = false));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _getUser() async {
    var u = ConstPreferences.getUserID();
    if (mounted) {
      Map user = await UserFunc.getUserData(u);
      if (mounted) {
        if (user != null) {
          setState(() {
            client = Client.build(user);
            loaded = true;
          });
        } else {
          setState(() {
            loaded = true;
          });
        }
      }
    }
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: isDark
            ? Colors.black
            : Theme.of(context).drawerTheme.backgroundColor,
        child: ListView(
          children: _buildCategories(isDark, widget.products, widget.settings),
        ),
      ),
      appBar: _buildAppbar(isDark),
      floatingActionButton: showBackToTopButton == false
          ? null
          : FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: isDark ? Colors.blueGrey : Colors.black,
              foregroundColor: Colors.white,
              onPressed: scrollToTop,
              child: const Iconify(Ri.arrow_up_line, color: Colors.white)),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            if (widget.settings.freeShippingLimit != 0)
              FreeShippingTag(settings: widget.settings),
            BannerSlider(
              settings: widget.settings,
              client: client,
              allCategories: widget.allCategories,
              products: widget.products,
            ),
            const SizedBox(height: 24.0),
            !loaded
                ? const Center(child: CupertinoActivityIndicator())
                : _buildCards(isDark)
          ],
        ),
      ),
    );
  }

  ListView _buildCards(bool isDark) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.showcases.length,
        itemBuilder: (context, index) =>
            widget.showcases[index].products.isNotEmpty
                ? ShowcaseWidget(
                    showcase: widget.showcases[index],
                    client: client,
                    settings: widget.settings,
                    allProducts: widget.products,
                  )
                : CategoryCard(
                    settings: widget.settings,
                    client: client,
                    products: widget.products,
                    all: widget.allCategories,
                    categories: widget.showcases[index].images));
  }

  List<Widget> _buildCategories(bool isDark, List<Product> prods, set) {
    List<Widget> list = [];
    for (Category item in widget.allCategories) {
      Widget widget = ListTile(
        shape: Border(
            bottom: BorderSide(
                width: 1, color: isDark ? Colors.white10 : Colors.black12)),
        title: Text(item.name.replaceAll('i', 'İ').toUpperCase()),
        onTap: () => Navigate.next(
          context,
          SearchScreen(
              settings: set, products: prods, category: item, client: client),
        ),
      );
      list.add(widget);
    }
    list.insert(0, _buildDrawerHeader(isDark));
    return list;
  }

  Widget _buildDrawerHeader(bool isDark) {
    return DrawerHeader(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: isDark ? Colors.white10 : Colors.black12))),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            width: MediaQuery.of(context).size.width * 0.4,
            child: Image.asset(isDark
                ? 'assets/images/logo_vert_dark.png'
                : 'assets/images/logo_vert_light.png')),
      ),
    );
  }

  AppBar _buildAppbar(bool isDark) {
    return AppBar(
      title: SizedBox(
        height: 18.0,
        child: Image.asset(
          isDark
              ? 'assets/images/logo_dark.png'
              : 'assets/images/logo_light.png',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigate.next(
            context,
            SearchScreen(
                settings: widget.settings,
                products: widget.products,
                client: client),
          ),
          icon: Iconify(
            Ri.search_2_line,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
