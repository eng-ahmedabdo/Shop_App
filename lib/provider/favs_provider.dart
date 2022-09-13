// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shop_app/models/favs_attr.dart';

class FavsProvider with ChangeNotifier {
  Map<String, FavsAttr> _favsItems = {};

  Map<String, FavsAttr> get getFavsItem {
    return {..._favsItems};
  }

  void addAndRemoveFromFavs(
      String productId, double price, String title, String imageUrl) {
    if (_favsItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _favsItems.putIfAbsent(
        productId,
        () => FavsAttr(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _favsItems.remove(productId);
    notifyListeners();
  }

  void clearFavs() {
    _favsItems.clear();
    notifyListeners();
  }
}
