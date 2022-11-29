import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/constants/ordercard.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/transferinfomodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PayTrasferInfo extends StatefulWidget {
  final Client client;
  final List<Product> allProducts;
  const PayTrasferInfo(
      {Key key, @required this.client, @required this.allProducts})
      : super(key: key);

  @override
  State<PayTrasferInfo> createState() => _PayTrasferInfoState();
}

class _PayTrasferInfoState extends State<PayTrasferInfo> {
  Order _selectedOrder;
  TextEditingController totalPayController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  BankTransfer selectedBank;
  List<BankTransfer> bankList;
  List<DropdownMenuItem> dropitems;

  updateOrder(Order o) => setState(() => _selectedOrder = o);
  void sendButton() async {
    String total = totalPayController.text.trim().replaceAll(',', '.');
    String caption = captionController.text.trim();

    if (_selectedOrder != null &&
        selectedBank != null &&
        total.isNotEmpty &&
        caption.isNotEmpty) {
      int orderId = _selectedOrder.orderId;
      dynamic body = await UserFunc.sendTransferForm(
          widget.client.id, orderId, total, caption, selectedBank.id);

      if (body == "1") {
        showSuccess();
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: body);
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Lütfen gerekli alanları doldurun.');
    }
  }

  showSuccess() {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Gönderildi!'),
          content: const Text('Havale bildirim formunuz başarıyla gönderildi'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _getBanks() async {
    List<BankTransfer> bList = [];
    List list = await JsonFunctions.getTransferInfo();
    for (var item in list) {
      bList.add(BankTransfer.build(item));
    }

    if (mounted) {
      setState(() {
        bankList = bList;
      });

      _dropwdownItems();
    }
  }

  void _dropwdownItems() {
    List<DropdownMenuItem> items = [];

    for (BankTransfer bank in bankList) {
      items.add(DropdownMenuItem(
        value: bank,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(bank.bank),
        ),
      ));
    }

    if (mounted) {
      setState(() {
        dropitems = items;
      });
    }
  }

  @override
  void initState() {
    _getBanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('HAVALE FORMU')),
        body: widget.client.orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Image.asset('assets/images/giveback_asset.png'),
                    ),
                    const SizedBox(height: 32.0),
                    const Opacity(
                      opacity: 0.7,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Havale bildirimi yapılacak siparişiniz bulunmamaktadır.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCaption(),
                    _buildOrders(context),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonHideUnderline(
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDark ? Colors.white10 : Colors.white,
                              ),
                              child: DropdownButton(
                                value: selectedBank,
                                isExpanded: true,
                                hint: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('Banka seçin'),
                                ),
                                items: dropitems ?? [],
                                onChanged: (value) {
                                  setState(() {
                                    selectedBank = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ConstWidgets.textField(
                            isDark,
                            type: TextInputType.number,
                            controller: totalPayController,
                            hint: '149.99',
                            label: 'Sipariş Tutarı',
                          ),
                          const SizedBox(height: 8.0),
                          ConstWidgets.textField(
                            isDark,
                            controller: captionController,
                            hint: 'Notunuz varsa iletin',
                            label: 'Açıklama',
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(4.0).copyWith(top: 24.0),
                            child: SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green,
                                onPressed: sendButton,
                                child: const Text('Formu Gönder'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOrders(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
              child: const Opacity(
                  opacity: 0.7, child: Text('SİPARİŞİNİZİ SEÇİN'))),
          const SizedBox(height: 16.0),
          Wrap(
            runSpacing: 16.0,
            children: widget.client.orders
                .map(
                  (order) => OrderCardWidget(
                    allProduct: widget.allProducts,
                    order: order,
                    isSelected: _selectedOrder != null
                        ? _selectedOrder.orderId == order.orderId
                        : null,
                    onTap: () {
                      updateOrder(order);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Opacity(
        opacity: 0.7,
        child: Text(
          'Havale ile ödeme seçeneğini kullanıdığınız siparişlerinizde havale yaptıktan sonra bu formu doldurmanız gerekir. Bu form sipariş ödemesinin tamamlandığını bildirmek için kullanılır.',
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
