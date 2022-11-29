import 'package:dresscabinet/app/constants/ordercard.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/screen/account/menu/orders/orderdetailscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<Product> allProducts;
  final Client client;
  const OrderList({Key key, @required this.allProducts, @required this.client})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SİPARİŞLER')),
      body: client.orders.isEmpty
          ? const Center(
              child: Opacity(
                opacity: 0.7,
                child: Text('Geçmiş siparişiniz yok.'),
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
              physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
              child: Wrap(
                runSpacing: 16.0,
                children: client.orders
                    .map(
                      (order) => OrderCardWidget(
                        allProduct: allProducts,
                        order: order,
                        onTap: () => Navigate.next(
                          context,
                          OrderDetailScreen(
                            allProducts: allProducts,
                            order: order,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
