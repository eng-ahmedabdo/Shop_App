// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/my_icons.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/services/payment.dart';

import 'order_empty.dart';
import 'order_full.dart';

class OrderScreen extends StatefulWidget {
  //To be known 1) the amount must be an integer 2) the amount must not be double 3) the minimum amount should be less than 0.5 $
  static const routeName = '/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  void payWithCard({int? amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.message}');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    // print('orderProvider.getOrders length ${orderProvider.getOrders.length}');
    return FutureBuilder(
      future: orderProvider.fetchOrders(),
      builder: (context, snapshot) {
        return orderProvider.getOrders.isEmpty
            ? Scaffold(body: OrderEmpty())
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text('Orders (${orderProvider.getOrders.length})'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // globalMethods.showDialogg(
                        //     'Clear cart!',
                        //     'Your cart will be cleared!',
                        //     () => cartProvider.clearCart(),
                        //     context);
                      },
                      icon: Icon(MyIcons.trash),
                    )
                  ],
                ),
                body: Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: ListView.builder(
                    itemCount: orderProvider.getOrders.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: orderProvider.getOrders[index],
                        child: OrderFull(),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
