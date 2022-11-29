import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';

class ChangeEmailInfo extends StatefulWidget {
  final Client client;
  final Function update;
  const ChangeEmailInfo({Key key, @required this.client, @required this.update})
      : super(key: key);

  @override
  State<ChangeEmailInfo> createState() => _ChangeEmailInfoState();
}

class _ChangeEmailInfoState extends State<ChangeEmailInfo> {
  String currentEmail = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController emailRepeatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      currentEmail = widget.client.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('EMAİL')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildCurrentEmail(context, isDark),
                const SizedBox(height: 24.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Yeni Email',
                  hint: 'merhaba@dresscabinet.com',
                  controller: emailController,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 4.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Yeni Email (Tekrar)',
                  hint: 'merhaba@dresscabinet.com',
                  controller: emailRepeatController,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 4.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Şifre',
                  hint: '***********',
                  controller: passwordController,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0).copyWith(top: 24.0),
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green,
                      child: const Text('Güncelle'),
                      onPressed: () {
                        final String e = emailController.text.trim();
                        final String eRep = emailRepeatController.text.trim();
                        final String p = passwordController.text.trim();
                        if (p.isEmpty || e.isEmpty || eRep.isEmpty) {
                          _nullField();
                        } else {
                          if (e == eRep) {
                            UserFunc.passwordControl(widget.client.email,
                                    passwordController.text.trim())
                                .then((body) {
                              if (body == "1") {
                                UserFunc.updateUserData(widget.client.id,
                                        email: e)
                                    .then((value) {
                                  widget.update();
                                  succesCard();
                                });
                              } else {
                                _wrongPassword(body);
                              }
                            });
                          } else {
                            _asyncEmail();
                          }
                        }
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

  _nullField() => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Maalesef!'),
            content: const Text(
                'Lütfen e-mail adresinizi güncellemek için tüm alanları doldurun.'),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              ),
            ],
          ));

  _asyncEmail() => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Eyvah!'),
            content: const Text('Girdiğiniz e-postalar birbiriyle eşleşmiyor.'),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              ),
            ],
          ));

  _wrongPassword(body) => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Maalesef!'),
            content: Text(body),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              ),
            ],
          ));

  succesCard() => showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Tebrikler'),
            content: const Text('E-mail adresinizi başarıyla güncellediniz.'),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
              ),
            ],
          ));

  _buildCurrentEmail(context, isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDark ? Colors.white10 : Colors.white,
      ),
      child: Opacity(
        opacity: 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kayıtlı Email Adresiniz',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 4.0),
            Text(
              currentEmail,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
