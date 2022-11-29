import 'package:cached_network_image/cached_network_image.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/product/productscreen.dart';
import 'package:dresscabinet/app/screen/signup/login.dart';
import 'package:dresscabinet/app/screen/signup/register.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Product> allProducts;
  final ConstSettings settings;
  const FavoritesScreen(
      {Key key, @required this.allProducts, @required this.settings})
      : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> products;
  Client client;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _getUser();
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

          _getFavorites();
        } else {
          setState(() => loaded = true);
        }
      }
    }
  }

  _getFavorites() {
    List<Product> list = [];
    for (Map item in client.favorites) {
      list.add(
          OrderFunc.getProd(widget.allProducts, int.parse(item['urun_id'])));
    }
    if (mounted) {
      setState(() {
        products = list;
      });
    }
  }

  _removeLike(Product product) async {
    dynamic body = await UserFunc.removeLike(client.id, product.id);
    if (body == "1") {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Favorilerden kaldırıldı.');
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: body);
    }

    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = Brightness.dark == brightness;
    return !loaded
        ? const Scaffold(body: Center(child: CupertinoActivityIndicator()))
        : client == null
            ? _nullClientWidget(context, isDark)
            : Scaffold(
                appBar: AppBar(title: const Text('FAVORİLERİM')),
                body: products.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Image.asset(
                                  'assets/images/favorite_null.png')),
                          const SizedBox(height: 32.0),
                          const Opacity(
                              opacity: 0.7,
                              child: Text('Favorilerinize eklemediniz.'))
                        ],
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.all(4.0),
                        itemCount: products.length,
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemBuilder: (context, index) => defaultContainer(
                            context,
                            isDark,
                            ItemCard(
                              settings: widget.settings,
                              allProducts: widget.allProducts,
                              products: products,
                              index: index,
                              update: _removeLike,
                            )),
                      ),
              );
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

Scaffold _nullClientWidget(BuildContext context, bool isDark) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                'assets/images/login_asset.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32.0),
            Opacity(
              opacity: 0.7,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const Text(
                  'Hesap ayarlarınız yönetmek için lütfen giriş yapın',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            CupertinoButton(
              color: isDark ? Colors.green : Colors.black,
              child: const Text('Giriş yap'),
              onPressed: () => Navigate.next(context, const LoginScreen()),
            ),
            const SizedBox(height: 24.0),
            const Text('veya'),
            const SizedBox(height: 16.0),
            CupertinoButton(
              child: const Text('Yeni Hesap Oluştur'),
              onPressed: () => Navigate.next(context, const RegisterScreen()),
            ),
          ],
        ),
      ),
    ),
  );
}

class ItemCard extends StatelessWidget {
  final Function update;
  final List<Product> allProducts;
  final ConstSettings settings;
  const ItemCard(
      {Key key,
      @required this.products,
      @required this.index,
      @required this.update,
      @required this.allProducts,
      @required this.settings})
      : super(key: key);

  final List<Product> products;
  final int index;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = Brightness.dark == brightness;

    return Row(
      children: [
        _buildImage(context),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 4.0),
              _buildPrices(),
              const SizedBox(height: 14.0),
              _viewProductButton(isDark, context),
            ],
          ),
        ),
        _removeFavoriteButton(isDark),
      ],
    );
  }

  Column _removeFavoriteButton(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 26.0,
          height: 26.0,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              update(products[index]);
            },
            icon: Iconify(
              Ri.heart_2_fill,
              size: 24.0,
              color: isDark ? Colors.redAccent : Colors.red,
            ),
          ),
        ),
        const Opacity(
            opacity: 0.7,
            child: Text('kaldır', style: TextStyle(fontSize: 10.0))),
      ],
    );
  }

  SizedBox _viewProductButton(bool isDark, BuildContext context) {
    return SizedBox(
      height: 38.0,
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: isDark ? Colors.white10 : Colors.black,
        child: const Text(
          'Ürünü Gör',
          style: TextStyle(fontSize: 14.0),
        ),
        onPressed: () => Navigate.next(
            context,
            ProductScreen(
              settings: settings,
              allProducts: allProducts,
              isLiked: true,
              likeTapped: () {},
              product: products[index],
              imageIndex: 0,
            )),
      ),
    );
  }

  Row _buildPrices() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          products[index].salePrice.toString() + products[index].currencyUnit,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      products[index].name.replaceAll('i', 'İ').toUpperCase(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
    );
  }

  SizedBox _buildImage(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AspectRatio(
          aspectRatio: 3 / 4.5,
          child: products[index].images.isNotEmpty
              ? Hero(
                  tag: products[index].images.first['urun_resim'],
                  child: CachedNetworkImage(
                      imageUrl: products[index].images.first['urun_resim']),
                )
              : Image.asset(
                  'assets/images/no_image.jpg',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
