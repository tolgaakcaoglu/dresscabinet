import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/authentication.dart';
import 'package:dresscabinet/app/screen/signup/register.dart';
import 'package:dresscabinet/app/utils/navigate.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  _forgotPasword() async {
    if (email.trim().isNotEmpty) {
      var body = await Authentication.forgotPassword(email.trim());
      if (body == "1") {
        showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: const Text('Başarılı'),
                  content: const Text(
                      'Şifre yenileme bağlantısı e-posta adresinize gönderildi'),
                  actions: [
                    CupertinoButton(
                        child: const Text('Tamam'),
                        onPressed: () => Navigator.pop(context))
                  ],
                ));
      } else {
        Fluttertoast.showToast(msg: body);
      }
    } else {
      Fluttertoast.showToast(msg: 'Lütfen e-posta adresinizi yazın');
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Giriş yap')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextButton(
                    onPressed: _forgotPasword,
                    child: const Opacity(
                        opacity: 0.7, child: Text('Şifremi Unuttum'))),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(8.0),
                    color: isDark ? Colors.green : CupertinoColors.black,
                    onPressed: email.trim().isEmpty || password.trim().isEmpty
                        ? null
                        : () => Authentication.login(context, email, password),
                    child: const Text('Oturum Aç'),
                  ),
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(8.0),
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..push(Navigate.route(const RegisterScreen())),
                    child: const Text('Yeni Hesap Oluştur'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
