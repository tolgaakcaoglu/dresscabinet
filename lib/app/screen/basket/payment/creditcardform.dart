import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class DeliveryCreditCardWidget extends StatefulWidget {
  final String cardNumber, expiryDate, cardHolderName, cvvCode;
  final bool isCvvFocused, infoPolicyChecked, cancelPolicyChecked;
  final Function onCreditCardModelChange;
  final Key creditCardFormKey;
  final Function(String) paymentType, updateTckn;
  final Function(bool) infoPolicyChanged, cancelPolicyChanged;
  const DeliveryCreditCardWidget({
    Key key,
    @required this.cardNumber,
    @required this.expiryDate,
    @required this.cardHolderName,
    @required this.cvvCode,
    @required this.onCreditCardModelChange,
    @required this.isCvvFocused,
    @required this.creditCardFormKey,
    @required this.paymentType,
    @required this.infoPolicyChecked,
    @required this.cancelPolicyChecked,
    @required this.infoPolicyChanged,
    @required this.cancelPolicyChanged,
    @required this.updateTckn,
  }) : super(key: key);

  @override
  State<DeliveryCreditCardWidget> createState() =>
      DeliveryCreditCardWidgetState();
}

class DeliveryCreditCardWidgetState extends State<DeliveryCreditCardWidget> {
  Object isCreditCardPayment = 0;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _radiotile('Kredi kartı ile ödeme yap', 0),
          if (isCreditCardPayment == 0) _creditCardWidget(),
          if (isCreditCardPayment == 0) _creditCardForm(isDark),
          _radiotile('Havale ile ödeme yap', 1),
          const Divider(height: 32.0),
          _policyTile(),
        ],
      ),
    );
  }

  Padding _policyTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _checkbox(
              'Bilgilendirmeleri ve Mesafeli Satış Sözleşmesini okudum, kabul ediyorum.',
              widget.infoPolicyChecked,
              widget.infoPolicyChanged),
          _checkbox('Cayma Hakkını okudum, kabul ediyorum.',
              widget.cancelPolicyChecked, widget.cancelPolicyChanged),
        ],
      ),
    );
  }

  CheckboxListTile _checkbox(caption, val, onChange) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      activeColor: Colors.black,
      title: Opacity(
        opacity: 0.7,
        child: Text(caption, style: const TextStyle(fontSize: 12.0)),
      ),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      value: val,
      onChanged: onChange,
    );
  }

  CreditCardWidget _creditCardWidget() {
    return CreditCardWidget(
      cardNumber: widget.cardNumber,
      expiryDate: widget.expiryDate,
      cardHolderName: widget.cardHolderName.toUpperCase(),
      cvvCode: widget.cvvCode,
      bankName: ' ',
      showBackView: widget.isCvvFocused,
      isHolderNameVisible: true,
      cardBgColor: Colors.blueGrey,
      onCreditCardWidgetChange: (creditCardBrand) {},
    );
  }

  RadioListTile<Object> _radiotile(String title, int value) {
    return RadioListTile(
      title: Text(title),
      groupValue: isCreditCardPayment,
      value: value,
      activeColor: Colors.blue,
      onChanged: radioChangedVal,
    );
  }

  radioChangedVal(v) {
    setState(() => isCreditCardPayment = v);
    widget.paymentType(v == 0 ? 'credit_card' : 'transfer');
  }

  _creditCardForm(isDark) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ConstWidgets.textField(
            isDark,
            type: TextInputType.number,
            label: 'TC Kimlik Numarası',
            onChang: widget.updateTckn,
          ),
        ),
        CreditCardForm(
          formKey: widget.creditCardFormKey,
          obscureCvv: true,
          obscureNumber: true,
          cardNumber: widget.cardNumber,
          cvvCode: widget.cvvCode,
          cardHolderName: widget.cardHolderName,
          expiryDate: widget.expiryDate,
          themeColor: Colors.blue,
          textColor: isDark ? Colors.white : Colors.black,
          cardNumberDecoration: InputDecoration(
            labelText: 'Kart Numarası',
            hintText: 'XXXX XXXX XXXX XXXX',
            hintStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
          ),
          expiryDateDecoration: InputDecoration(
            hintStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            labelText: 'Geçerlilik Tarihi',
            hintText: 'XX/XX',
          ),
          cvvCodeDecoration: InputDecoration(
            hintStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            labelText: 'CVV',
            hintText: 'XXX',
          ),
          cardHolderDecoration: InputDecoration(
            hintStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            labelText: 'Kart Üzerindeki İsim',
          ),
          onCreditCardModelChange: widget.onCreditCardModelChange,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
