import 'package:dresscabinet/app/database/basketdatabase.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/variantsmodal.dart';
import 'package:dresscabinet/app/screen/product/widgets/productscreenwidgets.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final int imageIndex;
  final Function likeTapped;
  final bool isLiked;
  final ConstSettings settings;
  final List<Product> allProducts;
  const ProductScreen(
      {Key key,
      this.product,
      this.imageIndex,
      @required this.likeTapped,
      @required this.isLiked,
      @required this.settings,
      @required this.allProducts})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product _product;
  int _selectedSize;
  int _selectedPiece = 1;
  List<Product> _colorVariants = [];
  List<Variant> _sizeVariants = [];
  bool showAddProductCard = false;
  ScrollController scrollController;
  Client client;
  bool _isLiked = false;
  bool isAddedBasket = false;
  List shippingBrands;

  @override
  void initState() {
    super.initState();
    _getUser();
    scrollController = ScrollController()
      ..addListener(() => setState(() => scrollController.offset >= 100
          ? showAddProductCard = true
          : showAddProductCard = false));

    setState(() {
      _product = widget.product;
      _isLiked = widget.isLiked;
      _sizeVariants = getVariants('beden');
      Variant v = _sizeVariants[0];
      if (v.stock < 1) _selectedPiece = 0;
    });
    getColorVariants();
    updateBasket();
    _shippingBrands();
  }

  _shippingBrands() async {
    var list = await JsonFunctions.getShippingBrands();
    if (mounted) {
      setState(() {
        shippingBrands = list;
      });
    }
  }

  void updateBasket() async {
    bool added = await LocalDb.instance.isAdded(widget.product.id);
    if (mounted) setState(() => isAddedBasket = added);
  }

  void _getUser() async {
    var u = ConstPreferences.getUserID();
    if (mounted) {
      Map user = await UserFunc.getUserData(u);
      if (mounted) {
        if (user != null) {
          setState(() {
            client = Client.build(user);
          });
        }
      }
    }
  }

  void getColorVariants() async {
    List<Product> list = [];
    List allColors = _product.affiliatedProducts;
    List products = await JsonFunctions.getProducts();

    if (products != null) {
      for (Map variant in allColors) {
        for (Map item in products) {
          Product i = Product.fromJson(item);
          if (i.id.toString() == variant['id']) {
            if (i.id != _product.id) list.add(i);
          }
        }
      }

      if (mounted) {
        setState(() {
          _colorVariants = list;
        });
      }
    }
  }

  getVariants(String variantType) {
    List<Variant> variants = [];
    List all = _product.variants.map((e) => e).toList();
    for (var v in all) {
      Variant variant = v;
      if (variant.title.toLowerCase() == variantType.toLowerCase()) {
        variants.add(variant);
      }
    }
    return variants;
  }

  updateLikeStatus() => setState(() => _isLiked = !_isLiked);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductScreenAppBar(
        isLiked: _isLiked,
        heartTapped: () {
          widget.likeTapped();
          updateLikeStatus();
        },
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductScreenImages(
                      product: _product, recentImage: widget.imageIndex),
                  ProductScreenTitle(title: _product.name),
                  ProductScreenCode(code: _product.code),
                  ProductScreenPrices(
                      salePrice: _product.salePrice,
                      marketPrice: _product.marketPrice,
                      currencyUnit: _product.currencyUnit),
                  const ProductScreenReviewStars(),
                  if (_product.caption.isNotEmpty)
                    ProductScreenCaptionWidget(product: _product),
                  const Divider(height: 40.0),
                  if (_sizeVariants.isNotEmpty)
                    ProductScreenSizeVariants(
                        variants: _sizeVariants,
                        selectedSize: _selectedSize,
                        selectedPiece: _selectedPiece,
                        setState: sizeOnTap),
                  if (_colorVariants.isNotEmpty)
                    ProductScreenColorVariants(
                        variants: _colorVariants,
                        refreshProduct: tappedColorVariant),
                  const Divider(height: 40.0),
                  ProductScreenPieceCounter(
                      selectedPiece: _selectedPiece,
                      selectedSize: _selectedSize,
                      sizeVariants: _sizeVariants,
                      tappedMinus: pieceCounterTapMinus,
                      tappedPlus: pieceCounterTapPlus),
                  const Divider(height: 40.0),
                  ProductScreenBodyTable(shippingBrans: shippingBrands),
                  ProductScreenSocialButtons(
                      product: _product, client: client, update: _getUser),
                  const ProductScreenShippingDate(),
                  const ProductScreenInfoCards(),
                  const SizedBox(height: 16.0),
                  ProductScreenRecommededProducts(
                    settings: widget.settings,
                    allProducts: widget.allProducts,
                    client: client,
                    product: _product,
                    newProductSelected: tappedRecommendedProduct,
                  ),
                  const SizedBox(height: 8.0),
                  //  ProductScreenCommentAccordion(product: _product),
                  ProductScreenPaymenetOptionsAccordion(product: _product),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: kToolbarHeight + 32),
                ],
              ),
            ),
          ),
          ProductScreenBottomBar(
              settings: widget.settings,
              allProducts: widget.allProducts,
              selectedSize: _selectedSize == null
                  ? null
                  : _sizeVariants[_selectedSize].value,
              update: () => updateBasket(),
              product: widget.product,
              isAdded: isAddedBasket,
              selectedPiece: _selectedPiece,
              showAddProductCard: showAddProductCard),
        ],
      ),
    );
  }

  tappedColorVariant(p) {
    setState(() {
      _selectedSize = null;
      _product = p;
      _sizeVariants = getVariants('beden');
      Variant v = _sizeVariants[0];
      if (v.stock < 1) _selectedPiece = 0;
    });
    getColorVariants();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  tappedRecommendedProduct(Product p) {
    setState(() {
      _selectedSize = null;
      _product = p;

      _selectedPiece = 1;
      _sizeVariants = getVariants('beden');
      Variant v = _sizeVariants[0];
      if (v.stock < 1) _selectedPiece = 0;
    });
    getColorVariants();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  sizeOnTap(e, Variant variant) {
    setState(() {
      _selectedSize = e.key;

      if (variant.stock < _selectedPiece) {
        _selectedPiece = variant.stock;
      }
      if (variant.stock > 0 && _selectedPiece == 0) {
        _selectedPiece = 1;
      }
    });
  }

  pieceCounterTapMinus() {
    if (_selectedPiece > 1) {
      setState(() => _selectedPiece = _selectedPiece - 1);
    }
  }

  pieceCounterTapPlus() {
    if (_selectedSize != null) {
      Variant variant = _sizeVariants[_selectedSize];
      if (_selectedPiece < variant.stock) {
        setState(() => _selectedPiece = _selectedPiece + 1);
      }
    }
  }
}
