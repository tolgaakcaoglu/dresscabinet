import 'package:dresscabinet/app/database/basketdatabase.dart';
import 'package:dresscabinet/app/functions/addressfunc.dart';
import 'package:dresscabinet/app/functions/payment.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/addressmodal.dart';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/districtmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/provincemodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/transferinfomodal.dart';
import 'package:dresscabinet/app/screen/basket/payment/addressform.dart';
import 'package:dresscabinet/app/screen/basket/payment/creditcardform.dart';
import 'package:dresscabinet/app/screen/basket/payment/paymentrequest.dart';
import 'package:dresscabinet/app/screen/basket/payment/resultwidget.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryScreen extends StatefulWidget {
  final double totalPayment;
  final List<Basket> baskets;
  final List<Product> allProducts;
  final Client client;
  final Function update;
  final ConstSettings settings;
  const DeliveryScreen(
      {Key key,
      @required this.totalPayment,
      @required this.baskets,
      @required this.client,
      @required this.allProducts,
      @required this.update,
      @required this.settings})
      : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  List<Address> addresses;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Province _province;
  District _district;

  int stepCount = 0;
  bool billing = true;

  int deliveryAdressIndex;
  int billingAdressIndex;
  BankTransfer selectedBank;
  final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String paymentType = 'credit_card';
  bool infoPolicyChecked = false;
  bool cancelPolicyChecked = false;
  String tckn = '';

  String paymentHTML;

  @override
  void initState() {
    super.initState();

    setState(() {
      addresses = widget.client.deliveryAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: _counterWidget(isDark),
          leading: BackButton(onPressed: backButtonPress),
          actions: [
            stepCount == 2 && paymentType == 'credit_card'
                ? const SizedBox()
                : TextButton(
                    onPressed: () => stepCount == 0
                        ? step0nextButton()
                        : stepCount == 1
                            ? step1nextButton()
                            : step2nextButton(),
                    child: const Text('İlerle'),
                  ),
          ],
        ),
        body: IndexedStack(
          index: stepCount,
          children: [
            DeliveryAddressForm(
              district: _district,
              province: _province,
              allProducts: widget.allProducts,
              addresses: addresses ?? widget.client.deliveryAddress,
              nameController: nameController,
              addressController: addressController,
              postalCodeController: postalCodeController,
              noteController: noteController,
              deliveryAdressIndex: deliveryAdressIndex,
              billingAdressIndex: billingAdressIndex,
              billing: billing,
              changedDistrict: onChangedDistrict,
              changedProvince: onChangedProvince,
              onBillingAdress: onBillingAdress,
              saveNewAddress: saveNewAddress,
              setSelectedIndex: setSelectedIndex,
              baskets: widget.baskets,
            ),
            DeliveryCreditCardWidget(
              creditCardFormKey: creditCardFormKey,
              cardHolderName: cardHolderName,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              expiryDate: expiryDate,
              isCvvFocused: isCvvFocused,
              cancelPolicyChecked: cancelPolicyChecked,
              infoPolicyChecked: infoPolicyChecked,
              updateTckn: updateTckn,
              onCreditCardModelChange: onCreditCardModelChange,
              infoPolicyChanged: (v) => setState(() => infoPolicyChecked = v),
              cancelPolicyChanged: (v) =>
                  setState(() => cancelPolicyChecked = v),
              paymentType: (v) => setState(() => paymentType = v),
            ),
            DeliveryResultWidget(
              onPaymentStatus: (paymentRequest) {
                if (paymentRequest != null) {
                  if (paymentRequest == "success") _successPaymentCreateOrder();
                  Navigate.rnext(
                      context, PaymentRequestScreen(status: paymentRequest));
                }
              },
              paymentHTML: paymentHTML,
              bankUpdate: (b) => setState(() => selectedBank = b),
              paymentType: paymentType,
            ),
          ],
        ),
      ),
    );
  }

  onChangedDistrict(v) => setState(() => _district = v);

  onChangedProvince(v) {
    setState(() {
      _province = v;
      _district = null;
    });
  }

  updateTckn(tc) => setState(() => tckn = tc);

  void backButtonPress() {
    stepCount > 0
        ? setState(() {
            if (stepCount == 2) paymentHTML = null;
            stepCount = stepCount - 1;
          })
        : Navigate.back(context);
  }

  void onBillingAdress(v) => setState(() => billing = v);

  void setSelectedIndex(String type, int v) => setState(() =>
      type == 'delivery' ? deliveryAdressIndex = v : billingAdressIndex = v);

  saveNewAddress(Function func) async {
    if (nameController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        _district != null &&
        _province != null) {
      Address data = Address(
        address: addressController.text.trim(),
        province: _province.id,
        country: 223,
        district: _district.id,
        postalCode: postalCodeController.text.trim(),
        title: nameController.text.trim(),
      );

      Address adr = data;
      dynamic body = await UserFunc.addAddress(widget.client, adr);

      if (body == "1") {
        widget.update();
        func();
      } else {
        Fluttertoast.showToast(msg: body);
      }

      setState(() {
        addresses.add(adr);
        nameController.clear();
        addressController.clear();
        postalCodeController.clear();
        _district = null;
        _province = null;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Lütfen tüm alanları doldurun.',
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  step0nextButton() {
    if (deliveryAdressIndex != null) {
      if (!billing && billingAdressIndex == null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg:
                'Fatura adresi seçin veya "Fatura ile teslimat bilgilerim aynı" seçeneğini işaretleyin');
      } else {
        setState(() {
          stepCount = 1;
        });
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Lütfen teslimat adresini seçin');
    }
  }

  step1nextButton() async {
    if (infoPolicyChecked && cancelPolicyChecked) {
      if (paymentType == 'credit_card') {
        if (tckn.isNotEmpty) {
          if (creditCardFormKey.currentState.validate() &&
              cardHolderName.isNotEmpty) {
            updatePaymentHTML();

            if (mounted) {
              setState(() {
                stepCount = 2;
              });
            }
          } else {
            Fluttertoast.showToast(msg: 'Lütfen formu doldurun');
          }
        } else {
          Fluttertoast.showToast(msg: 'TC kimlik numaranızı girin');
        }
      } else if (paymentType == 'transfer') {
        setState(() {
          cardNumber = '';
          expiryDate = '';
          cardHolderName = '';
          cvvCode = '';
          tckn = '';
          stepCount = 2;
        });
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg:
            "Devam etmek için 'Mesafeli Satış Sözleşmesi'ni ve 'Cayma Hakkı Metni'ni kabul etmelisiniz.",
      );
    }
  }

  updatePaymentHTML() async {
    var payment = widget.totalPayment < widget.settings.freeShippingLimit
        ? widget.totalPayment + widget.settings.shippingPay
        : widget.totalPayment;
    paymentHTML = await Payment.sendPayment(
        widget.totalPayment,
        payment,
        cardHolderName,
        expiryDate,
        cardNumber,
        cvvCode,
        addresses[deliveryAdressIndex],
        widget.client,
        tckn,
        widget.baskets,
        widget.allProducts);

    if (mounted) {
      if (paymentHTML == null || paymentHTML == "error") {
        const PaymentRequestScreen(status: 'failure');
      }
      setState(() {});
    }
  }

  step2nextButton() async {
    if (paymentType == 'transfer') {
      if (selectedBank != null) {
        var body = await UserFunc.createNewOrder(
          widget.client,
          addresses[deliveryAdressIndex],
          billingAdressIndex == null ? null : addresses[billingAdressIndex],
          paymentType,
          widget.baskets,
          noteController.text.trim(),
          widget.totalPayment < widget.settings.freeShippingLimit
              ? widget.settings.shippingPay
              : 0,
          billing,
          selectedBank,
          await AddressFunc.getProvinceWithId(
              addresses[deliveryAdressIndex].id),
          await AddressFunc.getDistrictWithId(
              addresses[deliveryAdressIndex].id),
          billing
              ? null
              : await AddressFunc.getProvinceWithId(
                  addresses[billingAdressIndex].id),
          billing
              ? null
              : await AddressFunc.getDistrictWithId(
                  addresses[billingAdressIndex].id),
        );

        if (body == "1") {
          LocalDb.instance.deleteBasket();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Tebrikler'),
                content: const Text(
                    'Siparişiniz başarıyla oluşturuldu. Siparişlerim kısmından siparişlerinizi yönetebilirsiniz.'),
                actions: [
                  CupertinoButton(
                      child: const Text('Tamam'),
                      onPressed: () {
                        Navigate.rnext(context, const AilApp());
                      })
                ],
              );
            },
          );
        } else {
          Fluttertoast.showToast(msg: body.toString());
        }
      } else {
        Fluttertoast.showToast(msg: 'Lütfen ödeme yapacağınız bankayı seçin');
      }
    } else {}
  }

  _successPaymentCreateOrder() async {
    var body = await UserFunc.createNewOrder(
      widget.client,
      addresses[deliveryAdressIndex],
      billingAdressIndex == null ? null : addresses[billingAdressIndex],
      paymentType,
      widget.baskets,
      noteController.text.trim(),
      widget.totalPayment < widget.settings.freeShippingLimit
          ? widget.settings.shippingPay
          : 0,
      billing,
      selectedBank,
      await AddressFunc.getProvinceWithId(addresses[deliveryAdressIndex].id),
      await AddressFunc.getDistrictWithId(addresses[deliveryAdressIndex].id),
      billing
          ? null
          : await AddressFunc.getProvinceWithId(
              addresses[billingAdressIndex].id),
      billing
          ? null
          : await AddressFunc.getDistrictWithId(
              addresses[billingAdressIndex].id),
    );

    if (body == "1") {
      LocalDb.instance.deleteBasket();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Tebrikler'),
            content: const Text(
                'Siparişiniz başarıyla oluşturuldu. Siparişlerim kısmından siparişlerinizi yönetebilirsiniz.'),
            actions: [
              CupertinoButton(
                  child: const Text('Tamam'),
                  onPressed: () {
                    Navigate.rnext(context, const AilApp());
                  })
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(msg: body.toString());
    }
  }

  Widget _counterWidget(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _countCircle(isDark, 0),
        _counterSeperator(),
        _countCircle(isDark, 1),
        _counterSeperator(),
        _countCircle(isDark, 2),
      ],
    );
  }

  Opacity _counterSeperator() => const Opacity(
      opacity: 0.5, child: Text('>', style: TextStyle(fontSize: 14.0)));

  Container _countCircle(bool isDark, int index) {
    return Container(
      width: 24.0,
      height: 24.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? index == stepCount
                ? Colors.white
                : Colors.white10
            : index == stepCount
                ? Colors.black
                : Colors.white,
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: isDark
                ? index == stepCount
                    ? Colors.black
                    : Colors.white
                : index == stepCount
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}
