import 'package:dresscabinet/app/functions/pages/categoryfunctions.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/categories/widgets/categorieswidget.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  final List all;
  final List main;
  final int firstIndex;
  final ConstSettings settings;
  final List<Product> products;
  const CategoriesScreen(
      {Key key,
      @required this.all,
      @required this.main,
      @required this.firstIndex,
      @required this.products,
      @required this.settings})
      : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List subCategories;
  int selectedCategoryIndex;
  Client client;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() {
    _getUser();
    _getSub();
    setState(() => selectedCategoryIndex = widget.firstIndex);
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

  _getSub() {
    List sub = CategoryFunc.getSubCategories(widget.all, selectedCategoryIndex);
    if (mounted) {
      setState(() {
        subCategories = sub;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const Center(child: CupertinoActivityIndicator())
        : Scaffold(
            appBar: CategoriesScreenAppBarWidget(
              settings: widget.settings,
              client: client,
              products: widget.products,
              mainCategories: widget.main,
              selectedCategoryIndex: selectedCategoryIndex,
              updateCategory: (v) {
                setState(() => selectedCategoryIndex = v);
                _getSub();
              },
            ),
            body: subCategories == null
                ? const CategoriesScreenListPlaceholders()
                : subCategories.isEmpty
                    ? CategoriesScreenEmptySublist(
                        settings: widget.settings,
                        client: client,
                        products: widget.products,
                        mainCategories: widget.main,
                        selectedCategoryIndex: selectedCategoryIndex)
                    : CategoriesScreenLists(
                        settings: widget.settings,
                        client: client,
                        subCategories: subCategories,
                        products: widget.products,
                      ),
          );
  }
}
