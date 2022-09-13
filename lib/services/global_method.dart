// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class GlobalMethod{
  Future<void> showDialogg(String title, String subTitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/7951/7951590.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(title),
                ),
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }
  Future<void> authErrorHandle(String subTitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children:  [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/7951/7951590.png',
                  height: 40,
                  width: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text('Error occurred'),
                ),
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }
}