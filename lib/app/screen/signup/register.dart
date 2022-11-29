import 'package:country_codes/country_codes.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/authentication.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final String flag = CountryCodes.getDeviceLocale().countryCode.toLowerCase();
  String name = '';
  String email = '';
  String password = '';
  String passwordR = '';
  String phone = '';
  bool onEmail = false;
  bool onSms = false;
  bool onPolicy = false;
  String gender;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Hesap Oluştur')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ConstWidgets.textField(
                  isDark,
                  label: 'Ad Soyad',
                  onChang: (v) {
                    setState(() {
                      name = v.trim();
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  type: TextInputType.emailAddress,
                  hint: 'user@dress.com',
                  label: 'E-posta',
                  onChang: (v) {
                    setState(() {
                      email = v.trim();
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  obscureText: true,
                  label: 'Şifre',
                  onChang: (v) {
                    setState(() {
                      password = v.trim();
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  obscureText: true,
                  label: 'Şifre Tekrar',
                  onChang: (v) {
                    setState(() {
                      passwordR = v.trim();
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Telefon Numarası',
                  prefix: _flagIcon(),
                  type: TextInputType.number,
                  onChang: (v) {
                    setState(() {
                      phone = v.replaceAll(' ', '');
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: CupertinoSlidingSegmentedControl(
                      padding: const EdgeInsets.all(4.0),
                      groupValue: gender,
                      children: const {
                        'Erkek': Text('Erkek'),
                        'Kadın': Text('Kadın'),
                      },
                      onValueChanged: (v) {
                        setState(() {
                          gender = v;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildCheckTile(
                  'Kampanya, duyuru, bilgilendirmelerden e-posta ile haberdar olmak istiyorum.',
                  onEmail,
                  (v) {
                    setState(() {
                      onEmail = v;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                _buildCheckTile(
                  'Kampanya, duyuru, bilgilendirmelerden sms ile haberdar olmak istiyorum.',
                  onSms,
                  (v) {
                    setState(() {
                      onSms = v;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                _buildCheckTile(
                  'Üyelik koşullarını ve kişisel verilerimin korunmasını kabul ediyorum.',
                  onPolicy,
                  (v) {
                    setState(() {
                      onPolicy = v;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                      borderRadius: BorderRadius.circular(8.0),
                      color: CupertinoColors.activeGreen,
                      child: const Text('Oluştur'),
                      onPressed: () => Authentication.register(
                          context,
                          name,
                          email,
                          password,
                          passwordR,
                          (CountryCodes.dialCode() + phone),
                          onEmail,
                          onSms,
                          onPolicy,
                          gender)),
                ),
                const SizedBox(height: 32.0),
                CupertinoButton(
                  borderRadius: BorderRadius.circular(8.0),
                  onPressed: () => Navigator.of(context)
                    ..pop()
                    ..push(Navigate.route(const LoginScreen())),
                  child: const Text('Zaten hesabım var'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CheckboxListTile _buildCheckTile(
          String caption, bool value, Function(bool) onChang) =>
      CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        activeColor: Colors.black,
        subtitle: Text(caption),
        value: value,
        onChanged: onChang,
      );

  SizedBox _flagIcon() => SizedBox(
      width: 18,
      child:
          Image.asset('icons/flags/png/$flag.png', package: 'country_icons'));
}
