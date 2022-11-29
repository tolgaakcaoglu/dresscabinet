import 'package:country_codes/country_codes.dart';
import 'package:dresscabinet/app/utils/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/dresscabinet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var window = WidgetsBinding.instance.window;
  var brightness = MediaQueryData.fromWindow(window).platformBrightness;
  var color = brightness == Brightness.dark ? Colors.black : Colors.white;
  var style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness,
      systemNavigationBarColor: color);

  SystemChrome.setSystemUIOverlayStyle(style);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await CountryCodes.init();
  await ConstPreferences.init();

  runApp(const AilApp());
}

class AilApp extends StatelessWidget {
  const AilApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dress Cabinet',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          },
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shadowColor: Colors.white12,
        ),
      ),
      theme: ThemeData.light().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          },
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shadowColor: Colors.black12,
        ),
      ),
      locale: const Locale('tr', ''),
      supportedLocales: const [Locale('tr', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const DressCabinet(),
    );
  }
}
