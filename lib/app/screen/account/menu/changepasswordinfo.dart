import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';

class ChangePasswordInfo extends StatefulWidget {
  final Client client;
  const ChangePasswordInfo({Key key, @required this.client}) : super(key: key);

  @override
  State<ChangePasswordInfo> createState() => _ChangePasswordInfoState();
}

class _ChangePasswordInfoState extends State<ChangePasswordInfo> {
  String currentEmail = 'testuser@dresscabinet.com';

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ŞİFRE')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ConstWidgets.textField(
                  isDark,
                  label: 'Eski şifre',
                  hint: '********',
                  controller: oldPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 4.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Yeni Şifre',
                  hint: '***********',
                  controller: newPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 4.0),
                ConstWidgets.textField(
                  isDark,
                  label: 'Yeni Şifre (Tekrar)',
                  hint: '***********',
                  controller: newPasswordRepeatController,
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
                        final String old = oldPasswordController.text.trim();
                        final String newP = newPasswordController.text.trim();
                        final String newPR =
                            newPasswordRepeatController.text.trim();
                        if (old.isEmpty || newP.isEmpty || newPR.isEmpty) {
                          _nullField();
                        } else {
                          UserFunc.changePassword(
                                  widget.client.id.toString(), old, newP)
                              .then((value) {
                            if (value == "1") {
                              setState(() {
                                oldPasswordController.clear();
                                newPasswordController.clear();
                                newPasswordRepeatController.clear();
                              });
                              succesCard();
                            } else {
                              setState(() {
                                oldPasswordController.clear();
                              });
                              _wrongPassword();
                            }
                          });
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
              'Lütfen şifrenizi değiştirmek için tüm alanları doldurun.'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () => Navigate.back(context),
            ),
          ],
        ),
      );

  _wrongPassword() => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Eski şifreniz yanlış!'),
            content: const Text('Lütfen şifrenizi kontrol edin.'),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              ),
            ],
          ));

  succesCard() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Tebrikler'),
          content: const Text('Şifrenizi başarıyla güncellediniz.'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () => Navigate.back(context),
            ),
          ],
        ),
      );
}
