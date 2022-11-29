import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CouponList extends StatelessWidget {
  const CouponList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Brightness brightness = MediaQuery.of(context).platformBrightness;
    // bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('KUPONLAR')),
      body: const Center(child: Text('Kuponunuz bulunmamaktadır.')),
      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(4.0),
      //   physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       _buildCurrentCoupons(isDark),
      //       const SizedBox(height: 32.0),
      //       _buildUsedCoupons(isDark),
      //     ],
      //   ),
      // ),
    );
  }

  buildCurrentCoupons(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Opacity(opacity: 0.7, child: Text('Geçerli Kuponlar')),
        ),
        const SizedBox(height: 4.0),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                tileColor: Colors.amber,
                title: Text(
                  'c4w8n'.toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: const Text(
                  'Geçerlilik süresi: 21.12.2022',
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
                trailing: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.copy,
                      size: 18.0,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "c4w8n"));
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'Panoya Kopyalandı');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildUsedCoupons(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Opacity(
              opacity: 0.7,
              child: Text('Kullanılan veya Süresi Biten Kuponlar')),
        ),
        const SizedBox(height: 4.0),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                tileColor: isDark ? Colors.white10 : Colors.white,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('c4w8n'.toUpperCase()),
                  ],
                ),
                subtitle: const Text(
                  '12 gün önce süresi bitti',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                tileColor: isDark ? Colors.white10 : Colors.white,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('f33nqs'.toUpperCase()),
                  ],
                ),
                subtitle: const Text(
                  '24 gün önce kullanıldı',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
