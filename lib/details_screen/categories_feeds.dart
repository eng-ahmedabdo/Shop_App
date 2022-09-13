// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/colors.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';

class CategoriesFeedsScreen extends StatelessWidget {
  static const routeName = '/CategoriesFeedsScreen';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    final productsList = productsProvider.findByCategory(categoryName);

    return Scaffold(
      body: productsList.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Feather.database,
                    size: 80,
                    color: ColorsConsts.favBadgeColor,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No products related to this category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            )
          : GridView.count(
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
    );
  }
}
