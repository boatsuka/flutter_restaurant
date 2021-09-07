import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/chat.dart';
import 'package:flutter_restaurant/order.dart';
import 'package:flutter_restaurant/payment.dart';
import 'package:flutter_restaurant/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List pages = [ProductPage(), OrderPage(), ChatPage(), PaymentPage()];

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
              Icons.home,
              color: ThemeColors.kPrimaryColor,
            ),
            onPressed: () {},
          )
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
