import 'package:cached_network_image/cached_network_image.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/addressfunc.dart';
import 'package:dresscabinet/app/functions/orderfunc.dart';
import 'package:dresscabinet/app/modals/addressmodal.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/districtmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/provincemodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryAddressForm extends StatefulWidget {
  final List<Address> addresses;
  final int deliveryAdressIndex, billingAdressIndex;
  final bool billing;
  final TextEditingController nameController,
      addressController,
      postalCodeController,
      noteController;
  final Function(bool) onBillingAdress;
  final Function saveNewAddress, changedProvince, changedDistrict;
  final Function(String, int) setSelectedIndex;
  final List<Product> allProducts;
  final List<Basket> baskets;
  final District district;
  final Province province;
  const DeliveryAddressForm({
    Key key,
    @required this.addresses,
    @required this.nameController,
    @required this.addressController,
    @required this.postalCodeController,
    @required this.noteController,
    @required this.deliveryAdressIndex,
    @required this.billingAdressIndex,
    @required this.billing,
    @required this.onBillingAdress,
    @required this.saveNewAddress,
    @required this.setSelectedIndex,
    @required this.baskets,
    @required this.allProducts,
    @required this.district,
    @required this.province,
    @required this.changedProvince,
    @required this.changedDistrict,
  }) : super(key: key);

  @override
  State<DeliveryAddressForm> createState() => _DeliveryAddressFormState();
}

class _DeliveryAddressFormState extends State<DeliveryAddressForm> {
  List<Province> provinces;
  List<District> districts;
  bool viewNewCard = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() async {
    provinces = await AddressFunc.getProvinces();
    if (mounted) setState(() {});
  }

  _loadDistrict(id) async {
    districts = await AddressFunc.getDistricts(id);
    if (mounted) setState(() {});
  }

  List<DropdownMenuItem> _getDisctricList() {
    List<DropdownMenuItem> drop = [];

    for (District d in districts) {
      drop.add(
        DropdownMenuItem(
          value: d,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(d.name),
          ),
        ),
      );
    }

    return drop;
  }

  List<DropdownMenuItem> _getProvinceList() {
    List<DropdownMenuItem> drop = [];

    for (Province p in provinces) {
      drop.add(
        DropdownMenuItem(
          value: p,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(p.name),
          ),
        ),
      );
    }

    return drop;
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewNewCard) _addAddressWidget(isDark),
          _deliveryAddressWidget(context, isDark),
          _billingTile(),
          if (!widget.billing) _billingAddressWidget(context, isDark),
          _productList(context),
          _buildNote(isDark),
        ],
      ),
    );
  }

  _addAddressWidget(isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstWidgets.textField(
            isDark,
            hint: 'Ev',
            label: 'Adres Adı',
            controller: widget.nameController,
          ),
          ConstWidgets.textField(
            isDark,
            label: 'Adres',
            controller: widget.addressController,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isDark ? Colors.white10 : Colors.white,
                      ),
                      child: provinces == null
                          ? const Text('')
                          : DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(8.0),
                              dropdownColor:
                                  isDark ? Colors.black87 : Colors.white,
                              hint: const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text('İl Seçin'),
                              ),
                              value: widget.province,
                              itemHeight: 56.0,
                              items: _getProvinceList(),
                              onChanged: (v) {
                                widget.changedProvince(v);
                                setState(() {
                                  districts = null;
                                });
                                _loadDistrict(v.id);
                              },
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isDark ? Colors.white10 : Colors.white,
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(8.0),
                        dropdownColor: isDark ? Colors.black87 : Colors.white,
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text('İlçe Seçin'),
                        ),
                        value: widget.district,
                        itemHeight: 56.0,
                        items: districts == null ? [] : _getDisctricList(),
                        onChanged: widget.changedDistrict,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ConstWidgets.textField(isDark,
                    hint: '34404',
                    label: 'Posta Kodu (Opsiyonel)',
                    type: TextInputType.number,
                    controller: widget.postalCodeController),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green,
                      child: const Text('Kaydet'),
                      onPressed: () {
                        widget.saveNewAddress(() {
                          setState(() {
                            viewNewCard = false;
                          });
                          _successCard(context);
                        });
                      }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  _successCard(context) => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Başarılı!'),
          content: const Text('Yeni adresiniz başarıyla eklendi'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
  SizedBox _deliveryAddressWidget(BuildContext context, bool isDark) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Teslimat Adresi'),
          ),
          widget.addresses.isNotEmpty
              ? SingleChildScrollView(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        children: widget.addresses
                            .asMap()
                            .entries
                            .map((e) => _buildAddressCard(
                                context, e.value, e.key, isDark, 'delivery'))
                            .toList(),
                      ),
                      _addNewAdressButton(isDark),
                    ],
                  ),
                )
              : _addNewAdressButton(isDark),
        ],
      ),
    );
  }

  Padding _billingTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: CheckboxListTile(
        checkboxShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        activeColor: Colors.black,
        title: const Opacity(
          opacity: 0.7,
          child: Text(
            'Fatura bilgilerim, teslimat adres bilgilerim ile aynı',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        value: widget.billing,
        onChanged: widget.onBillingAdress,
      ),
    );
  }

  SizedBox _billingAddressWidget(BuildContext context, bool isDark) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Fatura Adresi'),
          ),
          widget.addresses.isNotEmpty
              ? SingleChildScrollView(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        children: widget.addresses
                            .asMap()
                            .entries
                            .map(
                              (e) => _buildAddressCard(
                                  context, e.value, e.key, isDark, 'billing'),
                            )
                            .toList(),
                      ),
                      _addNewAdressButton(isDark),
                    ],
                  ))
              : _addNewAdressButton(isDark),
        ],
      ),
    );
  }

  SizedBox _productList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child:
                  Text('Ürün Listesi (${widget.baskets.length.toString()})')),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              children: widget.baskets
                  .map((Basket e) => BasketDeliveryProductCardWidget(
                      allProducts: widget.allProducts, basket: e))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildNote(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: ConstWidgets.textField(
        isDark,
        controller: widget.noteController,
        hint: 'Belirtmek istediğiniz not varsa yazın',
        label: 'Sipariş Notu (Opsiyonel)',
      ),
    );
  }

  _addNewAdressButton(isDark) {
    return Container(
      width: 140,
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => setState(() => viewNewCard = !viewNewCard),
        borderRadius: BorderRadius.circular(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_home_outlined, size: 24.0),
              SizedBox(height: 16),
              Text('Yeni Adres')
            ],
          ),
        ),
      ),
    );
  }

  Container _buildAddressCard(BuildContext context, Address address, int index,
      bool isDark, String type) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: (type == 'delivery'
                      ? widget.deliveryAdressIndex
                      : widget.billingAdressIndex) ==
                  index
              ? isDark
                  ? Colors.green
                  : Colors.black
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () => widget.setSelectedIndex(type, index),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16.0),
              Text(address.address),
            ],
          ),
        ),
      ),
    );
  }
}

class BasketDeliveryProductCardWidget extends StatefulWidget {
  final List<Product> allProducts;
  final Basket basket;
  const BasketDeliveryProductCardWidget(
      {Key key, @required this.basket, @required this.allProducts})
      : super(key: key);

  @override
  State<BasketDeliveryProductCardWidget> createState() =>
      _BasketDeliveryProductCardWidgetState();
}

class _BasketDeliveryProductCardWidgetState
    extends State<BasketDeliveryProductCardWidget> {
  Product product;

  _getProd() {
    Product p = OrderFunc.getProd(widget.allProducts, widget.basket.productId);

    if (mounted) {
      setState(() {
        product = p;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: product == null || product.images.isEmpty
                  ? Image.asset('assets/images/no_image.jpg', fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: product.images.first['urun_resim'],
                      fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.basket.productName,
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4.0),
          Text(
            widget.basket.salePrice.toString() + widget.basket.currencyUnit,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
