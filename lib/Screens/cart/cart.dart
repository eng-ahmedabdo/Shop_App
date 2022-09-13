// ignore_for_file: prefer_const_constructors, prefer_is_not_empty, deprecated_member_use, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/colors.dart';
import 'package:shop_app/Constants/my_icons.dart';
import 'package:shop_app/Screens/cart/cart_empty.dart';
import 'package:shop_app/Screens/cart/cart_full.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/services/global_method.dart';
import 'package:shop_app/services/payment.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  var response;

  Future<void> payWithCard({int? amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.success}');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }
  GlobalMethod globalMethod = GlobalMethod();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.getCartItem.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              title: Text('Cart (${cartProvider.getCartItem.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethod.showDialogg(
                      'Clear cart!',
                      'Your cart will be cleared!',
                      () => cartProvider.clearCart(),
                      context,
                    );
                    //cartProvider.clearCart();
                  },
                  icon: Icon(MyIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItem.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItem.values.toList()[index],
                      child: CartFull(
                        productId:
                            cartProvider.getCartItem.keys.toList()[index],
                        // id: cartProvider.getCartItem.values.toList()[index].id!,
                        // productId: cartProvider.getCartItem.keys.toList()[index],
                        // price: cartProvider.getCartItem.values.toList()[index].price!,
                        // title: cartProvider.getCartItem.values.toList()[index].title!,
                        // imageUrl: cartProvider.getCartItem.values.toList()[index].imageUrl!,
                        // quantity: cartProvider.getCartItem.values.toList()[index].quantity!,
                      ),
                    );
                  }),
            ),
          );
  }

  Widget checkoutSection(BuildContext ctx, double subTotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    var uuid = Uuid();
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        ColorsConsts.gradiendLStart,
                        ColorsConsts.gradiendLEnd,
                      ],
                      stops: [0.0, 0.7],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        double amountInCents = subTotal * 1000;
                        int integerAmount = (amountInCents / 10).ceil();
                        await payWithCard(amount: integerAmount);
                        if (response.success == true) {
                          User user = auth.currentUser!;
                          final _uid = user.uid;
                          cartProvider.getCartItem
                              .forEach((key, orderValue) async {
                            final orderId = uuid.v4();
                            try {
                              await FirebaseFirestore.instance
                                  .collection("order")
                                  .doc(orderId)
                                  .set({
                                'orderId': orderId,
                                'userId': _uid,
                                'productId': orderValue.productId,
                                'title': orderValue.title,
                                'price':
                                    orderValue.price! * orderValue.quantity!,
                                'imageUrl': orderValue.imageUrl,
                                'quantity': orderValue.quantity,
                                'orderDate': Timestamp.now(),
                              });
                            } catch (error) {
                              print(error);
                            }
                          });
                        }else {
                          globalMethod.authErrorHandle("Please enter your true information", context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Checkout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(ctx).textSelectionColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Total:',
                style: TextStyle(
                    color: Theme.of(ctx).textSelectionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'US ${subTotal.toStringAsFixed(3)}',
                //textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
