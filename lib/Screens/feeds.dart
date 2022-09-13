// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, must_be_immutable

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/colors.dart';
import 'package:shop_app/Constants/my_icons.dart';
import 'package:shop_app/Screens/cart/cart.dart';
import 'package:shop_app/Screens/wishlist/wishlist.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/favs_provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/Feeds';

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments;
    final productsProvider = Provider.of<Products>(context);
    List<Product> productsList = productsProvider.products;
    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
        actions: [
          Consumer<FavsProvider>(
            builder: (_, favs, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                favs.getFavsItem.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  MyIcons.wishkist,
                  color: ColorsConsts.favColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(WishlistScreen.routeName);
                },
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                cart.getCartItem.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  MyIcons.cart,
                  color: ColorsConsts.cartColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 5,
          childAspectRatio: 235 / 420,
          children: List.generate(
            productsList.length,
            (index) {
              return ChangeNotifierProvider.value(
                value: productsList[index],
                child: FeedProducts(),
              );
            },
          ),
        ),
      ),
    );
  }
}
