import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/chat.dart';
import 'package:flutter_restaurant/order.dart';
import 'package:flutter_restaurant/payment.dart';
import 'package:flutter_restaurant/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List pages = [ProductPage(), OrderPage(), ChatPage(), PaymentPage()];

  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();

  Future createOrder() async {
    DocumentReference ref = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('orders')
        .add({
      "orderStatus": "OPEN",
      "tableId": "kGlMyXn4xIfPZSDJV5dh",
      "orderDate": new DateTime.now().millisecondsSinceEpoch
    });
    print(ref.id);

    await helper.setStorage('tableId', 'kGlMyXn4xIfPZSDJV5dh');
    await helper.setStorage('tableName', 'โต๊ะ 1');
    await helper.setStorage('orderId', ref.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Kmitl Foods',
              style: TextStyle(color: ThemeColors.kPrimaryColor),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.paste_outlined,
              color: ThemeColors.kPrimaryColor,
            ),
            onPressed: () {
              createOrder();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.home,
              color: ThemeColors.kPrimaryColor,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: ThemeColors.kPrimaryColor,
        unselectedItemColor: ThemeColors.kUnselectedItemColor,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'สั่งอาหาร'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), label: 'รายการที่สั่ง'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: 'ติดต่อพนักงาน'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'ชำระเงิน')
        ],
      ),
    );
  }
}
