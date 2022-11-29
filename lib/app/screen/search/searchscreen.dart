import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/search/widgets/searchscreenwidget.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {Key key,
      @required this.products,
      this.category,
      @required this.client,
      @required this.settings})
      : super(key: key);

  final Client client;
  final List<Product> products;
  final Category category;
  final ConstSettings settings;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool showBackToTopButton = false;
  bool loading = false;

  String key = '';
  TextEditingController keyController = TextEditingController();

  String orderType;
  String selectedColor;
  int gridCount = 2;

  int viewingProductCount = 0;

  ScrollController scrollController;
  RefreshController refreshController = RefreshController();
  List<Product> allProds = [];
  List<Product> viewingProds = [];

  FixedExtentScrollController colorPickerController;
  FixedExtentScrollController orderByController;

  _loadViewingProds() {
    int oldCount = viewingProductCount;
    int allCount = allProds.length;
    int newCount = viewingProductCount + 20;
    viewingProductCount = allCount < newCount ? allCount : newCount;

    List<Product> newList = allProds.sublist(oldCount, viewingProductCount);

    for (Product prod in newList) {
      viewingProds.add(prod);
    }

    loading = false;

    setState(() {});
  }

  void _refresherOnLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (viewingProductCount == allProds.length) {
      refreshController.loadComplete();
      return;
    }

    if (mounted) {
      _loadViewingProds();
      refreshController.loadComplete();
    }
  }

  _loadSearchingProducts() {
    List<Product> findList = [];

    setState(() {
      allProds = [];
      viewingProds = [];
      viewingProductCount = 0;
      selectedColor = null;
      orderType = null;
    });

    String copyKey = ConstUtils.cleanText(keyController.text);

    for (Product prod in widget.products) {
      if (ConstUtils.cleanText(prod.name).contains(copyKey)) {
        findList.add(prod);
      }
    }

    allProds = findList;

    _refresherOnLoading();
    setState(() {});
  }

  void _colorizeProducts() {
    if (selectedColor != null) {
      List<Product> prods = [];
      for (Product prod in allProds) {
        List<String> keys = prod.name.split(' ');
        String color;
        if (prod.name.split(' ').last.substring(0, 1) != '(') {
          String c = '${keys[keys.length - 2]} ${keys.last}';
          color = c.substring(1, c.length - 1);
        } else {
          color = keys.last.substring(1, keys.last.length - 1);
        }

        if (color == selectedColor) {
          prods.add(prod);
        }
      }

      setState(() {
        viewingProds = prods;
        loading = false;
      });
    } else {
      viewingProds = allProds;
      setState(() {});
    }
  }

  _getCategoriesProduct() {
    setState(() {
      loading = true;
    });
    List<Product> list = [];

    for (Product prod in widget.products) {
      for (int catID in prod.categories) {
        if (catID == widget.category.id) {
          list.add(prod);
        }
      }
    }

    if (mounted) {
      setState(() {
        allProds = list;
      });

      _refresherOnLoading();
    }
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() => setState(() => scrollController.offset >= 400
          ? showBackToTopButton = true
          : showBackToTopButton = false));

    if (widget.category != null) _getCategoriesProduct();
  }

  @override
  void dispose() {
    if (colorPickerController != null) {
      colorPickerController.dispose();
    }
    if (orderByController != null) {
      orderByController.dispose();
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          floatingActionButton: showBackToTopButton == false
              ? null
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: isDark ? Colors.blueGrey : Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.arrow_upward),
                ),
          appBar: widget.category == null
              ? SearchScreenCatAppBar(
                  textFieldChanged: _textFieldChanged,
                  skey: key,
                  keyController: keyController,
                  deleteKeyController: _deleteKeyController)
              : AppBar(
                  title: Text(
                      widget.category.name.replaceAll('i', 'İ').toUpperCase())),
          body: loading
              ? const Center(child: CupertinoActivityIndicator())
              : key.trim().isNotEmpty || widget.category != null
                  ? allProds.isNotEmpty
                      ? SmartRefresher(
                          controller: refreshController,
                          enablePullUp: true,
                          enablePullDown: false,
                          scrollController: scrollController,
                          onLoading: _refresherOnLoading,
                          footer: const SmartResfresherCustomFooter(),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchScreenFilters(
                                  colorPickerController: colorPickerController,
                                  colors: _getFilterColors(),
                                  updateSelectedColor: _updateSelectedColor,
                                  updateOrderType: _updateOrderType,
                                  updateViewingCount: _updateGridCount,
                                  viewingCount: gridCount,
                                  orderByController: orderByController,
                                ),
                                SearchScreenProductCount(
                                    length: viewingProductCount),
                                if (orderType != null || selectedColor != null)
                                  SearchScreenAppliedFilters(
                                    orderName: _getOrderTypeNames(),
                                    cleanOrderbyFilter: _cleanOrderbyFilter,
                                    cleanColorFilter: _cleanColorFilter,
                                    orderType: orderType,
                                    selectedColor: selectedColor,
                                  ),
                                viewingProds.isNotEmpty
                                    ? SearchScreenViewProductWidget(
                                        settings: widget.settings,
                                        viewerCount: gridCount,
                                        client: widget.client,
                                        allProducts: widget.products,
                                        viewingProds: viewingProds,
                                      )
                                    : const SearchScreenKeyNotFound(),
                              ],
                            ),
                          ),
                        )
                      : const SearchScreenKeyNotFound()
                  : const SearchScreenNullKey()),
    );
  }

  void _updateSelectedColor(int value) {
    setState(() {
      colorPickerController = FixedExtentScrollController(initialItem: value);
      if (value != 0) {
        selectedColor = _getFilterColors()[value - 1];
      } else {
        selectedColor = null;
      }
    });

    _colorizeProducts();
  }

  List<String> _getFilterColors() {
    List<String> allColors = allProds.map((e) {
      List<String> keys = e.name.split(' ');

      if (e.name.split(' ').last.substring(0, 1) != '(') {
        int cLength = keys.length;
        var color = '${keys[cLength - 2]} ${keys.last}';

        return color.substring(1, color.length - 1);
      } else {
        return keys.last.substring(1, keys.last.length - 1);
      }
    }).toList();

    List<String> singleColors = [];

    for (String c in allColors) {
      if (singleColors.where((element) => c == element).isEmpty) {
        singleColors.add(c);
      }
    }

    singleColors.sort();

    return singleColors;
  }

  String _getOrderTypeNames() {
    if (orderType == 'cheapToExpensive') {
      return 'Fiyata göre (Artan)';
    } else if (orderType == 'expensiveToCheap') {
      return 'Fiyata göre (Azalan)';
    } else if (orderType == 'aToZ') {
      return 'Ürün adına göre (A>Z)';
    } else if (orderType == 'zToA') {
      return 'Ürün adına göre (Z<A)';
    } else {
      return 'Önerilen Sıralama';
    }
  }

  _orderByProducts() {
    if (orderType == 'cheapToExpensive') {
      allProds.sort((a, b) => a.salePrice.compareTo(b.salePrice));
    } else if (orderType == 'expensiveToCheap') {
      allProds.sort((a, b) => b.salePrice.compareTo(a.salePrice));
    } else if (orderType == 'aToZ') {
      allProds.sort((a, b) => a.name.compareTo(b.name));
    } else if (orderType == 'zToA') {
      allProds.sort((a, b) => b.name.compareTo(a.name));
    }

    setState(() {});
  }

  _updateOrderType(int value) {
    orderByController = FixedExtentScrollController(initialItem: value);
    if (value == 1) orderType = 'cheapToExpensive';
    if (value == 2) orderType = 'expensiveToCheap';
    if (value == 3) orderType = 'aToZ';
    if (value == 4) orderType = 'zToA';
    if (value == 0) orderType = null;

    setState(() {});

    _orderByProducts();
  }

  _updateGridCount(int c) {
    setState(() {
      gridCount = c;
    });
  }

  _cleanOrderbyFilter() {
    orderByController = null;
    orderType = null;
    setState(() {});
  }

  _cleanColorFilter() {
    setState(() {
      selectedColor = null;
      colorPickerController = null;
    });

    _colorizeProducts();
  }

  _textFieldChanged(String v) {
    key = v.trim();
    loading = true;
    setState(() {});

    _loadSearchingProducts();
  }

  _deleteKeyController() {
    keyController.clear();
    key = '';
    FocusScope.of(context).unfocus();
    setState(() {});
  }
}
