import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:dresscabinet/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication {
  static login(BuildContext context, String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var val = await UserFunc.passwordControl(email, password);
      if (val == "1") {
        String id = await UserFunc.getUserIdWithEmail(email);

        if (id != '') {
          ConstPreferences.setUserId(id)
              .whenComplete(() => Navigate.rnext(context, const AilApp()));
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Maalesef!'),
            content: Text(val),
            actions: [
              CupertinoDialogAction(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              )
            ],
          ),
        );
      }
    }
  }

  static register(
      BuildContext context,
      String displayName,
      String email,
      String password,
      String passwordR,
      String phone,
      bool onEmail,
      bool onSms,
      bool onPolicy,
      String gender) async {
    if (onPolicy) {
      if (displayName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          passwordR.isNotEmpty) {
        if (password == passwordR) {
          UserFunc.signupFunction(displayName, email, password, phone, onEmail,
                  onSms, onPolicy, gender)
              .then((value) => value == "1"
                  ? showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Hesabınız Oluşturuldu!'),
                        actions: [
                          CupertinoButton(
                            child: const Text('Giriş yap'),
                            onPressed: () => Navigator.of(context)
                              ..pop()
                              ..pop(),
                          )
                        ],
                      ),
                    )
                  : showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Bir hata oluştu'),
                        content: Text(value),
                        actions: [
                          CupertinoButton(
                            child: const Text('Tamam'),
                            onPressed: () => Navigate.back(context),
                          )
                        ],
                      ),
                    ));
        } else {
          Fluttertoast.showToast(msg: 'Girdiğiniz şifreler  uyuşmuyor.');
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Lütfen tüm alanları doldurun'),
            actions: [
              CupertinoButton(
                child: const Text('Tamam'),
                onPressed: () => Navigate.back(context),
              )
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Kaydolmak için şartları kabul etmeniz gerekir.'),
          actions: [
            CupertinoButton(
              child: const Text('Tamam'),
              onPressed: () => Navigate.back(context),
            )
          ],
        ),
      );
    }
  }

  static Future forgotPassword(String email) async {
    var url = Uri.https('dresscabinet.com', 'api/uyeler/sifremi-unuttum');
    var response = await http.post(
      url,
      body: {'email': email},
    );
    return response.body;
  }

  static logout(BuildContext context) {
    ConstPreferences.clearUserID()
        .whenComplete(() => Navigate.rnext(context, const AilApp()));
  }
}
