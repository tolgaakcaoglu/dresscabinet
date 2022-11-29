import 'package:country_codes/country_codes.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class MemberInfo extends StatefulWidget {
  final Client client;
  final Function update;
  const MemberInfo({Key key, @required this.update, @required this.client})
      : super(key: key);

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  final String flag = CountryCodes.getDeviceLocale().countryCode.toLowerCase();
  final String phoneCode = CountryCodes.detailsForLocale().dialCode;

  TextEditingController displayNameConroller = TextEditingController();
  TextEditingController emailConroller = TextEditingController();
  TextEditingController phoneConroller = TextEditingController();

  String gender;
  String displayName;
  String email;
  String phone;

  bool onSms = false;
  bool onEmail = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      gender = widget.client.gender;
      onSms = widget.client.onSms;
      onEmail = widget.client.onEmail;
      displayName = widget.client.displayName;
      email = widget.client.email;
      phone = widget.client.phone;
      displayNameConroller =
          TextEditingController(text: widget.client.displayName);
      emailConroller = TextEditingController(text: widget.client.email);
      phoneConroller = TextEditingController(
          text: widget.client.phone.replaceAll(CountryCodes.dialCode(), ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ÜYELİK BİLGİLERİ')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ConstWidgets.textField(
                  isDark,
                  controller: displayNameConroller,
                  label: 'Adı Soyadı',
                  prefix: _icon(isDark, Ri.user_3_line),
                  onChang: (v) {
                    setState(() {
                      displayName = v;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  controller: emailConroller,
                  label: 'E-posta adresi',
                  hint: 'merhaba@dresscabinet.com',
                  type: TextInputType.emailAddress,
                  prefix: _icon(isDark, Ri.at_line),
                  enabled: false,
                  onChang: (v) {
                    setState(() {
                      email = v;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                ConstWidgets.textField(
                  isDark,
                  controller: phoneConroller,
                  label: 'Telefon Numarası',
                  prefix: _flagIcon(),
                  type: TextInputType.number,
                  onChang: (v) {
                    setState(() {
                      phone = v.replaceAll(' ', '');
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                SizedBox(
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
                Padding(
                  padding: const EdgeInsets.all(4.0).copyWith(top: 24.0),
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green,
                      child: const Text('Değişiklikleri Kaydet'),
                      onPressed: () {
                        UserFunc.updateUserData(widget.client.id,
                                displayName: displayName.trim().toUpperCase(),
                                phone: phoneConroller == null
                                    ? null
                                    : (CountryCodes.dialCode() +
                                        phone.replaceAll(
                                            CountryCodes.dialCode(), '')),
                                smsVerify: onSms ? 1 : 0,
                                emailVerify: onEmail ? 1 : 0,
                                gender: gender)
                            .then((body) {
                          widget.update();
                          showInfoCard(body == "1" ? true : false);
                        }).onError((error, stackTrace) =>
                                Fluttertoast.showToast(msg: 'Bir hata oluştu'));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showInfoCard(bool isSuccess) => showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(isSuccess ? 'Başarılı' : 'Başarısız'),
          content: Text(isSuccess
              ? 'Tüm değişiklikleriniz kaydedildi.'
              : 'Değişiklikler kaydedilirken bir hata oluştu'),
          actions: [
            CupertinoButton(
                child: const Text('Kapat'),
                onPressed: () => Navigator.pop(context))
          ],
        ),
      );

  CheckboxListTile _buildCheckTile(
          String caption, bool value, Function(bool) onChang) =>
      CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          activeColor: Colors.black,
          subtitle: Text(caption),
          value: value,
          onChanged: onChang);

  SizedBox _flagIcon() => SizedBox(
      width: 18,
      child:
          Image.asset('icons/flags/png/$flag.png', package: 'country_icons'));

  _icon(isDark, String icon) => Iconify(icon,
      color: isDark ? Colors.white70 : Colors.black54, size: 18.0);
}
