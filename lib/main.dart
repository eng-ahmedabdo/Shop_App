// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, equal_keys_in_map

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Constants/theme_data.dart';
import 'package:shop_app/Screens/auth/forget_password.dart';
import 'package:shop_app/Screens/auth/login.dart';
import 'package:shop_app/Screens/auth/signup.dart';
import 'package:shop_app/Screens/bottom_bar.dart';
import 'package:shop_app/Screens/cart/cart.dart';
import 'package:shop_app/Screens/feeds.dart';
import 'package:shop_app/Screens/orders/order.dart';
import 'package:shop_app/Screens/upload_product.dart';
import 'package:shop_app/Screens/user_state.dart';
import 'package:shop_app/Screens/wishlist/wishlist.dart';
import 'package:shop_app/details_screen/brands_navigation_rail.dart';
import 'package:shop_app/details_screen/categories_feeds.dart';
import 'package:shop_app/details_screen/product_details.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/dark_theme.dart';
import 'package:shop_app/provider/favs_provider.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/provider/products.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }else if (snapshot.hasError){
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error occurred'),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(
              create: (_) => Products(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => FavsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersProvider(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeData, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shopping',
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                home: UserState(),
                //initialRoute: '/',
                routes: {
                  //   '/': (ctx) => LandingPage(),
                  BrandNavigationRailScreen.routeName: (ctx) =>
                      BrandNavigationRailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  FeedsScreen.routeName: (ctx) => FeedsScreen(),
                  WishlistScreen.routeName: (ctx) => WishlistScreen(),
                  ProductDetails.routeName: (ctx) => ProductDetails(),
                  CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                  SignUpScreen.routeName: (ctx) => SignUpScreen(),
                  BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                  UploadProductForm.routeName: (ctx) => UploadProductForm(),
                  ForgetPassword.routeName: (ctx) => ForgetPassword(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                },
              );
            },
          ),
        );
      }
    );
  }
}
