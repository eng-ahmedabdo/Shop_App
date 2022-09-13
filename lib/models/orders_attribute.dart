import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersAttr with ChangeNotifier {
  final String? orderId;
  final String? userId;
  final String? productId;
  final String? title;
  final String? quantity;
  final String? price;
  final String? imageUrl;
  final Timestamp? orderDate;

  OrdersAttr({
    this.orderId,
    this.userId,
    this.productId,
    this.title,
    this.quantity,
    this.price,
    this.imageUrl,
    this.orderDate,
  });
}
