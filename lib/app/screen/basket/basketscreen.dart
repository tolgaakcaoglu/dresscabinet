import 'package:dresscabinet/app/database/basketdatabase.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/basket/widgets/basketaddcouponwidget.dart';
import 'package:dresscabinet/app/screen/basket/widgets/basketpaymantcardwidget.dart';
import 'package:dresscabinet/app/screen/basket/widgets/basketshippingtimewidget.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/basketproducttilewidget.dart';

class BasketScreen extends StatefulWidget {
  final List<Product> allProducts;
  final ConstSettings settings;

  const BasketScreen(
      {Key key, @required this.allProducts, @required this.settings})
      : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  Client client;
  List<Basket> baskets;
  double totalDiscount = 0;
  double totalPay = 0;

  bool discountCouponAdded = false;
  double couponDiscount = 0;

  bool loaded = false;

  @override
  void initState() {
    super.initState();

    _initBasket();
    _getUser();
  }

  void _initBasket() async {
    baskets = await LocalDb.instance.readAllProducts();
    if (mounted) {
      loaded = true;
      setState(() {});

      getTotalDiscount();
      getTotalPayment();
    }
  }

  void getTotalDiscount() async {
    double ds = 0;

    for (Basket b in baskets) {
      if (b.basketDiscount != null) {
        if (b.basketDiscount.price != 0) {
          ds += b.basketDiscount.price * b.piece;
        }
      }
    }

    setState(() => totalDiscount = ds);
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

  void getTotalPayment() async {
    double pr = 0;
    for (Basket b in baskets) {
      pr += (b.salePrice * b.piece);
    }

    setState(() => totalPay = pr);
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('SEPETİM')),
        body: baskets == null
            ? const Center(child: CupertinoActivityIndicator())
            : baskets.isEmpty
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset('assets/images/basket_fields.png'),
                      ),
                      const SizedBox(height: 32.0),
                      const Opacity(
                          opacity: 0.7, child: Text('Sepetiniz boş.')),
                    ],
                  ))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: baskets.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (BuildContext context, int index) =>
                                  defaultContainer(
                                      context,
                                      isDark,
                                      ProductBasketTile(
                                          client: client,
                                          allProducts: widget.allProducts,
                                          update: _initBasket,
                                          basket: baskets[index]))),
                          defaultContainer(context, isDark,
                              const BasketShippingTimeWidget()),
                          defaultContainer(
                              context,
                              isDark,
                              BasketCouponAddWidget(
                                  discountCouponAdded: discountCouponAdded,
                                  addCouponButton: _addCouponTapped)),
                          defaultContainer(
                              context,
                              isDark,
                              BasketPaymentCardWidget(
                                update: _getUser,
                                allProducts: widget.allProducts,
                                client: client,
                                totalPayment: totalPay,
                                baskets: baskets,
                                discountCouponAdded: discountCouponAdded,
                                settings: widget.settings,
                              )),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  _addCouponTapped(TextEditingController coupon) {
    if (coupon.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Geçersiz kupon kodu');
    }

    //  setState(() {
    //     discountCouponAdded = true;
    //   });
    //   Fluttertoast.cancel();
    //   Fluttertoast.showToast(msg: 'Kupon eklendi');
  }

  Container defaultContainer(BuildContext context, bool isDark, Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0)
            ],
            borderRadius: BorderRadius.circular(8.0)),
        child: child);
  }
}
