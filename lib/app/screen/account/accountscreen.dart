import 'package:dresscabinet/app/functions/authentication.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/screen/account/menu/alertlist.dart';
import 'package:dresscabinet/app/screen/account/menu/paytransferinfo.dart';
import 'package:dresscabinet/app/screen/account/menu/ticketslist.dart';
import 'package:dresscabinet/app/screen/basket/basketscreen.dart';
import 'package:dresscabinet/app/screen/favorites/favoritescreen.dart';
import 'package:dresscabinet/app/screen/signup/login.dart';
import 'package:dresscabinet/app/screen/signup/register.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'menu/addressinfo.dart';
import 'menu/changeemailinfo.dart';
import 'menu/changepasswordinfo.dart';
import 'menu/couponlist.dart';
import 'menu/givebacklist.dart';
import 'menu/memberinfo.dart';
import 'menu/orderslist.dart';

class AccountScreen extends StatefulWidget {
  final List<Product> allProducts;
  final ConstSettings settings;
  const AccountScreen(
      {Key key, @required this.allProducts, @required this.settings})
      : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Client client;
  String userDisplayName;
  String userEmail;
  bool loaded = false;

  updateName(String newName) {
    _getUser();
  }

  updateEmail(String newEmail) {
    _getUser();
  }

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
            userDisplayName = client.displayName;
            userEmail = client.email;
            loaded = true;
          });
        } else {
          setState(() => loaded = true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return !loaded
        ? const Center(child: CupertinoActivityIndicator())
        : client == null
            ? _nullClientWidget(context, isDark)
            : Scaffold(
                appBar: AppBar(title: const Text('HESABIM')),
                body: SingleChildScrollView(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfoTile(isDark),
                        ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            _buildItem(
                                isDark,
                                'Üyelik Bilgilerim',
                                Ri.user_settings_line,
                                MemberInfo(update: _init, client: client)),
                            _buildItem(
                                isDark,
                                'Adres Bilgilerim',
                                Ri.map_pin_user_line,
                                AddressInfo(client: client, update: _init)),
                            _buildItem(
                                isDark,
                                'E-mail Değiştir',
                                Ri.user_received_2_line,
                                ChangeEmailInfo(client: client, update: _init)),
                            _buildItem(isDark, 'Şifre Değiştir', Ri.admin_line,
                                ChangePasswordInfo(client: client)),
                            _buildItem(
                                isDark,
                                'Alışveriş Sepeti',
                                Ri.shopping_basket_line,
                                BasketScreen(
                                  allProducts: widget.allProducts,
                                  settings: widget.settings,
                                )),
                            _buildItem(
                                isDark,
                                'Siparişlerim',
                                Ri.shopping_bag_2_line,
                                OrderList(
                                    allProducts: widget.allProducts,
                                    client: client)),
                            _buildItem(
                                isDark,
                                'İade Taleplerim',
                                Ri.creative_commons_sa_line,
                                GiveBackList(
                                    update: _init,
                                    allProducts: widget.allProducts,
                                    client: client)),
                            _buildItem(
                                isDark,
                                'Favorilerim',
                                Ri.heart_2_line,
                                FavoritesScreen(
                                    settings: widget.settings,
                                    allProducts: widget.allProducts)),
                            _buildItem(
                                isDark,
                                'Alarm Listesi',
                                Ri.alarm_warning_line,
                                AdlertList(
                                    settings: widget.settings,
                                    update: _init,
                                    allProducts: widget.allProducts,
                                    client: client)),
                            _buildItem(isDark, 'Kuponlarım', Ri.ticket_2_line,
                                const CouponList()),
                            _buildItem(
                                isDark,
                                'Destek Taleplerim',
                                Ri.account_pin_circle_line,
                                TicketList(
                                  client: client,
                                  update: _init,
                                )),
                            _buildItem(
                                isDark,
                                'Havale Bildirim Formu',
                                Ri.file_shield_2_line,
                                PayTrasferInfo(
                                    client: client,
                                    allProducts: widget.allProducts)),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                tileColor:
                                    isDark ? Colors.white10 : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                title: const Opacity(
                                    opacity: 0.9, child: Text('Çıkış yap')),
                                horizontalTitleGap: 8.0,
                                leading: Opacity(
                                    opacity: 0.7,
                                    child: Iconify(Ri.logout_circle_r_line,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black)),
                                onTap: () {
                                  Authentication.logout(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
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

  Padding _buildUserInfoTile(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text(userDisplayName),
        subtitle: Text(userEmail),
        horizontalTitleGap: 8.0,
        leading: Opacity(
          opacity: 0.7,
          child: Iconify(Carbon.user_avatar,
              color: isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  _buildItem(
    isDark,
    String title,
    String icon,
    Widget goPage,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        tileColor: isDark ? Colors.white10 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Opacity(opacity: 0.9, child: Text(title)),
        horizontalTitleGap: 8.0,
        leading: Opacity(
            opacity: 0.7,
            child: Iconify(icon, color: isDark ? Colors.white : Colors.black)),
        onTap: () => Navigate.next(context, goPage),
      ),
    );
  }
}
