import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/givebackmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/screen/account/menu/giveback/addgivebackticket.dart';
import 'package:dresscabinet/app/screen/account/menu/giveback/givebackdetail.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class GiveBackList extends StatelessWidget {
  final List<Product> allProducts;
  final Client client;
  final Function update;
  const GiveBackList(
      {Key key,
      @required this.allProducts,
      @required this.client,
      @required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('İADELER')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? Colors.blueGrey : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          Navigate.next(
            context,
            AddGiveBackTicketScreen(
              client: client,
              update: update,
              allProducts: allProducts,
            ),
          );
        },
        label: const Text('İade Oluştur', style: TextStyle(letterSpacing: 0.8)),
      ),
      body: client.givebacklist.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(4.0),
              itemCount: client.givebacklist.length,
              itemBuilder: (context, index) {
                GiveBack give = client.givebacklist[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    horizontalTitleGap: 8.0,
                    tileColor: isDark ? Colors.white10 : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    leading: Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? Colors.black
                              : Theme.of(context).scaffoldBackgroundColor),
                      child: Center(
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            '#${give.id.toString()} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 10.0),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      '${give.products.length.toString()} ürün',
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${ConstUtils.getDate(give.giveDate)} ${give.giveDate.year} tarihinde oluşturuldu.',
                    ),
                    onTap: () => Navigate.next(
                        context,
                        GiveBackDetail(
                          client: client,
                          give: give,
                          allProducts: allProducts,
                        )),
                  ),
                );
              },
            )
          : _null(isDark),
    );
  }

  Center _null(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(Ri.emotion_happy_fill,
              color: isDark ? Colors.white54 : Colors.black54),
          const SizedBox(height: 16.0),
          Text(
            'İade talebi oluşturmadınız.',
            style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
          ),
        ],
      ),
    );
  }
}
