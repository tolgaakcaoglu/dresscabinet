import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/addressfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/addressmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/districtmodal.dart';
import 'package:dresscabinet/app/modals/provincemodal.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class AddressInfo extends StatefulWidget {
  final Client client;
  final Function update;
  const AddressInfo({Key key, @required this.client, @required this.update})
      : super(key: key);

  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  Province _province;
  District _district;
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

  Address _getAdress() => Address(
      country: 223,
      title: nameController.text.trim(),
      address: addressController.text.trim(),
      postalCode: postalCodeController.text.trim() ?? '',
      district: _district.id,
      province: _province.id);

  bool fielController() => nameController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          _district != null &&
          _province != null
      ? true
      : false;

  _clearForm() {
    setState(() {
      _district = null;
      _province = null;
      nameController.clear();
      addressController.clear();
      postalCodeController.clear();
    });
  }

  saveAddress(context) async {
    if (fielController()) {
      Address adr = _getAdress();
      dynamic body = await UserFunc.addAddress(widget.client, adr);

      if (body == "1") {
        setState(() {
          viewNewCard = false;
        });
        widget.update();
        _clearForm();

        _successCard(context);
      } else {
        Fluttertoast.showToast(msg: body);
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Lütfen tüm alanları doldurun.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: isDark ? Colors.green : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            setState(() {
              viewNewCard = !viewNewCard;
            });
          },
          label: Text(
            viewNewCard ? 'Eklemekten Vazgeç' : 'Yeni Adres Ekle',
            style: const TextStyle(letterSpacing: 0.8),
          ),
        ),
        appBar: AppBar(title: Text(viewNewCard ? 'Yeni Adres' : 'ADRES')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewNewCard) _addAddressWidget(isDark),
                widget.client.deliveryAddress.isEmpty &&
                        widget.client.billingAddress.isEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            (kToolbarHeight * 2),
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Image.asset('assets/images/delivery.png'),
                            ),
                            const SizedBox(height: 32.0),
                            const Opacity(
                                opacity: 0.7,
                                child: Text('Adres listeniz boş.')),
                          ],
                        )),
                      )
                    : Column(children: [
                        if (widget.client.deliveryAddress.isNotEmpty)
                          const Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('Teslimat Adreslerim'),
                            ),
                          ),
                        if (widget.client.deliveryAddress.isNotEmpty)
                          ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: (widget.client.deliveryAddress)
                                  .map((e) => AdressLineWidget(
                                      client: widget.client,
                                      address: e,
                                      update: widget.update))
                                  .toList()),
                        if (widget.client.deliveryAddress.isNotEmpty)
                          const SizedBox(height: 32.0),
                        if (widget.client.billingAddress.isNotEmpty)
                          const Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('Fatura Adreslerim'),
                            ),
                          ),
                        if (widget.client.billingAddress.isNotEmpty)
                          ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: widget.client.billingAddress
                                  .map((e) => AdressLineWidget(
                                      client: widget.client,
                                      address: e,
                                      update: widget.update))
                                  .toList()),
                      ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addAddressWidget(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstWidgets.textField(
            isDark,
            hint: 'Ev',
            label: 'Adres Adı',
            controller: nameController,
          ),
          ConstWidgets.textField(
            isDark,
            label: 'Adres',
            controller: addressController,
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
                              value: _province,
                              itemHeight: 56.0,
                              items: _getProvinceList(),
                              onChanged: (v) {
                                setState(() {
                                  _province = v;
                                  districts = null;
                                  _district = null;
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
                        value: _district,
                        itemHeight: 56.0,
                        items: districts == null ? [] : _getDisctricList(),
                        onChanged: (v) {
                          setState(() {
                            _district = v;
                          });
                        },
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
                    controller: postalCodeController),
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
                        saveAddress(context);
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
              onPressed: () => Navigator.of(context)
                ..pop()
                ..pop(),
            )
          ],
        ),
      );
}

class AdressLineWidget extends StatefulWidget {
  final Client client;
  final Address address;
  final Function update;
  const AdressLineWidget(
      {Key key,
      @required this.address,
      @required this.update,
      @required this.client})
      : super(key: key);

  @override
  State<AdressLineWidget> createState() => _AdressLineWidgetState();
}

class _AdressLineWidgetState extends State<AdressLineWidget> {
  District district;
  Province province;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _getProvince();
    _getDisctrict();
  }

  _getProvince() async {
    var pr = await AddressFunc.getProvinceWithId(widget.address.province);
    if (mounted) {
      setState(() {
        province = pr;
      });
    }
  }

  _getDisctrict() async {
    var ds = await AddressFunc.getDistrictWithId(widget.address.district);
    if (mounted) {
      setState(() {
        district = ds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          isThreeLine: true,
          contentPadding: const EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          tileColor: isDark ? Colors.white10 : Colors.white,
          title: Text(widget.address.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.address.address),
              const SizedBox(height: 2.0),
              Text(province == null || district == null
                  ? '${widget.address.district}/${widget.address.province} - ${widget.address.postalCode}'
                  : '${district.name}/${province.name}'),
            ],
          ),
          trailing: SizedBox(
            width: 24.0,
            height: 24.0,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _deleteItemCard(context, widget.address.id.toString());
              },
              icon: Iconify(
                Ri.delete_bin_7_line,
                color: isDark ? Colors.white54 : Colors.black45,
                size: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _deleteItem(id) async {
    dynamic body = await UserFunc.removeAddress(id);
    if (mounted) {
      if (body == "1") {
        setState(() {
          visible = false;
        });
        widget.update();
        Fluttertoast.showToast(msg: 'Adres silindi.');
      } else {
        Fluttertoast.showToast(msg: body);
      }
    }
  }

  _deleteItemCard(context, String addressId) => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Silinecek'),
          content:
              const Text('Adresi tamamen silmek istediğinize emin misiniz?'),
          actions: [
            CupertinoButton(
                child: const Text(
                  'Sil',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _deleteItem(addressId);
                  Navigator.pop(context);
                }),
            CupertinoButton(
              child: const Text('Vazgeç'),
              onPressed: () => Navigate.back(context),
            )
          ],
        ),
      );
}
