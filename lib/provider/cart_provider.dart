// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_attribute.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return {..._cartItems};
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price! * value.quantity!;
    });
    return total;
  }

  void addProductToCart (String productId, double price, String title, String imageUrl) {
    if(_cartItems.containsKey(productId)){
      _cartItems.update(productId, (existingCartItem) => CartAttr(
        id: existingCartItem.id,
        title: existingCartItem.title,
        productId: existingCartItem.productId,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity!+ 1,
        imageUrl: existingCartItem.imageUrl,
      ),);
    }else {

        _cartItems.putIfAbsent(productId ,() => CartAttr(
          id: DateTime.now().toString(),
          title: title,
          productId: productId,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),);
    }
    notifyListeners();
  }

  void reduceItemByOne(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(productId, (existingCartItem) =>
          CartAttr(
            id: existingCartItem.id,
            productId: existingCartItem.productId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity! - 1,
            imageUrl: existingCartItem.imageUrl,
          ),);
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _cartItems.remove(productId);
    notifyListeners();
  }
  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }
}
