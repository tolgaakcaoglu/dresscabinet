import 'dart:convert';

import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/transferinfomodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class DeliveryResultWidget extends StatefulWidget {
  final String paymentType;
  final String paymentHTML;
  final Function(BankTransfer) bankUpdate;
  final Function(String) onPaymentStatus;

  const DeliveryResultWidget({
    Key key,
    @required this.paymentType,
    @required this.bankUpdate,
    @required this.paymentHTML,
    @required this.onPaymentStatus,
  }) : super(key: key);

  @override
  State<DeliveryResultWidget> createState() => _DeliveryResultWidgetState();
}

class _DeliveryResultWidgetState extends State<DeliveryResultWidget> {
  int selectedBank;
  List<BankTransfer> bankList;

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
    }
  }

  @override
  void initState() {
    super.initState();
    _getBanks();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return widget.paymentType == 'transfer'
        ? _transferInfoWidget(isDark)
        : widget.paymentHTML != null
            ? _viewBankScreen(context)
            : _waitingBankScreen(context, isDark);
  }

  Center _waitingBankScreen(BuildContext context, bool isDark) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 64.0,
        height: MediaQuery.of(context).size.width - 64.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white10 : Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: CircularProgressIndicator(strokeWidth: 1)),
              SizedBox(height: 32.0),
              Opacity(
                opacity: 0.7,
                child: Text(
                  'ÖDEMEYİ BİLGİSİ BEKLENİYOR..',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  WebView _viewBankScreen(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller.loadHtmlString(widget.paymentHTML);
      },
     
     
      onPageFinished: (url) async {
        if (url.contains("odemeKontrolIyzico")) {
          var uri = Uri.parse(url);
          var res = jsonDecode(await http.read(uri));
          bool isSuccess = res["status"] == "success";
          if (isSuccess) {
            widget.onPaymentStatus("success");
          } else {
            widget.onPaymentStatus("failure");
          }
        }
      },
    );
  }

  Center _transferInfoWidget(bool isDark) {
    return Center(
      child: bankList == null
          ? const CupertinoActivityIndicator()
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Banka Seçenekleri',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4.0),
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      'Havale ile ödeme yönetimini seçtiniz. Ödeme yapmak için aşağıdaki banka bilgilerini kullanabilirsiniz.',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: bankList.length,
                    itemBuilder: (BuildContext context, int index) {
                      BankTransfer bank = bankList[index];
                      return _bankTile(isDark, bank, index);
                    },
                  ),
                ],
              ),
            ),),
    );
  }

  _bankTile(bool isDark, BankTransfer bank, int index) {
    return InkWell(
      onTap: () {
        widget.bankUpdate(bank);
        Clipboard.setData(ClipboardData(text: bank.iban));
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Iban Panoya Kopyalandı');
        setState(() {
          selectedBank = index;
        });
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: index == selectedBank
                ? Colors.blue
                : isDark
                    ? Colors.white10
                    : Colors.white),
        width: MediaQuery.of(context).size.width - 32.0,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(bank.bank,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: index == selectedBank
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyText2.color)),
            const SizedBox(height: 8.0),
            Opacity(
                opacity: 0.7,
                child: Text(
                  bank.name,
                  style: TextStyle(
                      color: index == selectedBank
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyText2.color),
                )),
            const SizedBox(height: 8.0),
            Opacity(
                opacity: 0.7,
                child: Text(
                  bank.iban,
                  style: TextStyle(
                      color: index == selectedBank
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyText2.color),
                )),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.copy,
                      size: 18.0,
                      color: index == selectedBank
                          ? Colors.white
                          : isDark
                              ? Colors.white70
                              : Colors.black87),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: bank.iban));
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'Panoya Kopyalandı');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
