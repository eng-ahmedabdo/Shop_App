// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/my_icons.dart';
import 'package:shop_app/Screens/wishlist/wishlist_empty.dart';
import 'package:shop_app/Screens/wishlist/wishlist_full.dart';
import 'package:shop_app/provider/favs_provider.dart';
import 'package:shop_app/services/global_method.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethod globalMethod = GlobalMethod();

    final favsProvider = Provider.of<FavsProvider>(context);
    return favsProvider.getFavsItem.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Text('Wishlist (${favsProvider.getFavsItem.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethod.showDialogg(
                      'Clear wishlist!',
                      'Your wishlist will be cleared!',
                          () => favsProvider.clearFavs(),
                      context,
                    );
                    //cartProvider.clearCart();
                  },
                  icon: Icon(MyIcons.trash),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: favsProvider.getFavsItem.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                  value: favsProvider.getFavsItem.values.toList()[index],
                  child: WishlistFull(
                    productId: favsProvider.getFavsItem.keys.toList()[index],
                  ),
                );
              },
            ),
          );
  }
}
