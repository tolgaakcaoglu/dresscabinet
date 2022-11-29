import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/utilsmodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddGiveBackOrderProductList extends StatefulWidget {
  final Order order;
  final Function update;
  final Client client;
  const AddGiveBackOrderProductList(
      {Key key,
      @required this.order,
      @required this.update,
      @required this.client})
      : super(key: key);

  @override
  State<AddGiveBackOrderProductList> createState() =>
      _AddGiveBackOrderProductListState();
}

class _AddGiveBackOrderProductListState
    extends State<AddGiveBackOrderProductList> {
  List<Basket> selectedBaskets = [];
  TextEditingController displayName = TextEditingController();
  TextEditingController iban = TextEditingController();
  TextEditingController caption = TextEditingController();
  List<GiveBackCause> causes;
  List<GiveBackType> types;
  List<DropdownMenuItem> causesList;
  List<DropdownMenuItem> typesList;
  GiveBackCause _selectedCause;
  GiveBackType _selectedType;

  _getCauses() async {
    List list = await JsonFunctions.getGiveBackCauses();
    List<GiveBackCause> c = [];
    if (mounted) {
      for (Map item in list) {
        c.add(GiveBackCause.build(item));
      }

      setState(() => causes = c);

      _getStyles();
    }
  }

  _getStyles() async {
    List list = await JsonFunctions.getGiveBackTypes();
    List<GiveBackType> c = [];
    if (mounted) {
      for (Map item in list) {
        c.add(GiveBackType.build(item));
      }

      setState(() => types = c);

      _getDropdownItems();
    }
  }

  _getDropdownItems() {
    List<DropdownMenuItem> cList = [];
    List<DropdownMenuItem> tList = [];
    for (var c in causes) {
      cList.add(DropdownMenuItem(
          value: c,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(c.cause),
          )));
    }
    for (var t in types) {
      tList.add(DropdownMenuItem(
          value: t,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(t.type),
          )));
    }
    if (mounted) {
      setState(() {
        causesList = cList;
        typesList = tList;
      });
    }
  }

  _init() {
    _getCauses();
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('İade Edilecek Ürünler')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.7,
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 4),
                child: const Text('ÜRÜNLERİ SEÇİN'),
              ),
            ),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(4.0),
              itemCount: widget.order.basket.length,
              itemBuilder: (context, index) {
                Basket basket = widget.order.basket[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    tileColor: isDark ? Colors.white10 : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    title: Text(basket.productName),
                    subtitle: Text(basket.salePrice.toStringAsFixed(2) +
                        basket.currencyUnit),
                    trailing: Icon(
                      Icons.check_circle,
                      color: selectedBaskets
                              .where((element) =>
                                  element.productId == basket.productId)
                              .isEmpty
                          ? Colors.transparent
                          : Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        selectedBaskets
                                .where((element) =>
                                    element.productId == basket.productId)
                                .isEmpty
                            ? selectedBaskets.add(basket)
                            : selectedBaskets.remove(basket);
                      });
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isDark ? Colors.white10 : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedCause,
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text('İade Nedeni'),
                          ),
                          items: causesList ?? [],
                          onChanged: (value) {
                            setState(() {
                              _selectedCause = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isDark ? Colors.white10 : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedType,
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text('İade Tipi'),
                          ),
                          items: typesList ?? [],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Opacity(
                    opacity: 0.7,
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('İADE BİLGİLERİ')),
                  ),
                  const SizedBox(height: 8.0),
                  ConstWidgets.textField(isDark,
                      controller: displayName, label: 'Iban Adı Soyadı'),
                  const SizedBox(height: 8.0),
                  ConstWidgets.textField(isDark,
                      controller: iban, label: 'IBAN'),
                  const SizedBox(height: 8.0),
                  ConstWidgets.textField(isDark,
                      controller: caption, label: 'Açıklama'),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 56.0,
                  child: CupertinoButton(
                    color: isDark ? Colors.green : Colors.black,
                    onPressed: selectedBaskets.isEmpty
                        ? null
                        : () {
                            if (_fieldController()) {
                              _sendGive();
                            } else {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                  msg: 'Lütfen tüm alanları doldurun');
                            }
                          },
                    child: const Text('Talep Oluştur'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _sendGive() {
    UserFunc.addNewGiveback(
            widget.client,
            widget.order,
            displayName.text.trim(),
            iban.text.trim(),
            caption.text.trim(),
            selectedBaskets
                .map((e) => {
                      'urun_id': e.productId.toString(),
                      'siparis_urun_id': e.productId.toString(),
                      'iptal_iade_nedeni': _selectedCause.cause,
                      'iptal_iade_tipi': _selectedType.type
                    })
                .toList())
        .then((body) {
      if (body == "1") {
        _successAlert();
      } else {
        Fluttertoast.showToast(msg: body);
      }
    });
  }

  _successAlert() => showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Başarılı!'),
          content: const Text(
              'İade talebiniz oluşturuldu. İadelerim kısmından iadenizin durumunu görüntüleyebilirsiniz.'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () {
                widget.update();
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pop()
                  ..pop();
              },
            ),
          ],
        ),
      );

  bool _fieldController() => displayName.text.trim().isEmpty ||
          iban.text.trim().isEmpty ||
          caption.text.trim().isEmpty
      ? false
      : true;
}
