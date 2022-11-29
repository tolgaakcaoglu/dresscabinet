import 'package:dresscabinet/app/constants/ordercard.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/ordermodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/screen/account/menu/giveback/addgivebackorderproductlist.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddGiveBackTicketScreen extends StatefulWidget {
  final Client client;
  final Function update;
  final List<Product> allProducts;
  const AddGiveBackTicketScreen(
      {Key key,
      @required this.client,
      @required this.update,
      @required this.allProducts})
      : super(key: key);

  @override
  State<AddGiveBackTicketScreen> createState() =>
      _AddGiveBackTicketScreenState();
}

class _AddGiveBackTicketScreenState extends State<AddGiveBackTicketScreen> {
  Order _selectedOrder;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('İade Talebi Oluştur')),
      bottomNavigationBar: widget.client.orders.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56.0,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 56.0,
                    child: CupertinoButton(
                      color: isDark ? Colors.green : Colors.black,
                      onPressed: _selectedOrder == null
                          ? null
                          : () {
                              Navigate.next(
                                context,
                                AddGiveBackOrderProductList(
                                  client: widget.client,
                                  order: _selectedOrder,
                                  update: widget.update,
                                ),
                              );
                            },
                      child: const Text('Devam et'),
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: widget.client.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Image.asset('assets/images/giveback_asset.png'),
                  ),
                  const SizedBox(height: 32.0),
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      'İade edilecek bir siparişiniz bulunmamaktadır.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                      child: const Opacity(
                          opacity: 0.7, child: Text('SİPARİŞİNİZİ SEÇİN'))),
                  const SizedBox(height: 16.0),
                  Wrap(
                    runSpacing: 16.0,
                    children: widget.client.orders
                        .map(
                          (order) => OrderCardWidget(
                            allProduct: widget.allProducts,
                            order: order,
                            isSelected: _selectedOrder != null
                                ? _selectedOrder.orderId == order.orderId
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedOrder = order;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
