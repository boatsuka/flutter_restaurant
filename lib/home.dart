import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/login.dart';
import 'package:flutter_restaurant/theme.dart';
// import 'package:flutter_restaurant/chat.dart';
import 'package:flutter_restaurant/order.dart';
import 'package:flutter_restaurant/payment.dart';
import 'package:flutter_restaurant/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String orderId;
  String tableId;
  String tableName;
  String companyId;
  int totalItems = 0;
  int selectedIndex = 0;
  Helper helper = new Helper();
  final dbRef = FirebaseFirestore.instance;
  // List pages = [ProductPage(onAddItem: () => getOrderTotalItems(),), OrderPage(), PaymentPage()];

  Future getInfo() async {
    String _companyId = await helper.getStorage('companyId');
    String _orderId = await helper.getStorage('orderId');
    String _tableId = await helper.getStorage('tableId');
    String _tableName = await helper.getStorage('tableName');

    setState(() {
      orderId = _orderId;
      tableId = _tableId;
      tableName = _tableName;
      companyId = _companyId;
    });
  }

  Future checkCompanyInfo() async {
    String _companyId = await helper.getStorage('companyId');

    if (_companyId == null) {
      Navigator.of(context).pushReplacementNamed('/not-found');
    } else {
      setState(() {
        companyId = _companyId;
      });

      getInfo();
      getOrderTotalItems();
    }
  }

  Future callEmployee() async {
    try {
      QuerySnapshot query = await dbRef
          .collection('restaurantDB')
          .doc(companyId)
          .collection('calls')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (query.docs.length > 0) {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('calls')
            .doc(query.docs[0].id)
            .update({
          "isOpened": false,
          "message": "????????????????????????????????????",
          "time": new DateTime.now().millisecondsSinceEpoch,
        });
        Fluttertoast.showToast(
            msg: "????????????????????????????????????",
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            webBgColor: "#00b09b",
            textColor: Colors.white,
            fontSize: 16);
      } else {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('calls')
            .add({
          "isOpened": false,
          "message": "????????????????????????????????????",
          "time": new DateTime.now().millisecondsSinceEpoch,
          "tableId": tableId,
          "tableName": tableName,
          "orderId": orderId
        });
        Fluttertoast.showToast(
            msg: "????????????????????????????????????",
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            webBgColor: "#00b09b",
            textColor: Colors.white,
            fontSize: 16);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "?????????????????????????????????????????? ????????????????????????????????????????????????????????????",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "#F75151",
          textColor: Colors.white,
          fontSize: 16);
    }
  }

  Future getOrderTotalItems() async {
    try {
      String orderId = await helper.getStorage('orderId');

      QuerySnapshot snapshot = await dbRef
          .collection('restaurantDB')
          .doc(companyId)
          .collection('order-items')
          .where('orderId', isEqualTo: orderId)
          .get();

      setState(() {
        totalItems = snapshot.docs.length;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "???????????????????????????????????????????????????????????????",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "#00b09b",
          textColor: Colors.white,
          fontSize: 16);
    }
  }

  @override
  void initState() {
    super.initState();
    checkCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Text(
      //         'Kmitl Foods',
      //         style: TextStyle(color: ThemeColors.kPrimaryColor),
      //       )
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.home,
      //         color: ThemeColors.kPrimaryColor,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context)
      //             .push(MaterialPageRoute(builder: (context) => LoginPage()));
      //       },
      //     ),
      //   ],
      //   backgroundColor: Colors.white,
      //   shadowColor: Colors.white,
      // ),
      appBar: AppBar(
        title: Center(
          child: Text(
            'SRMS',
            style: TextStyle(color: ThemeColors.kPrimaryColor),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: ThemeColors.kPrimaryColor,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.notifications,
              color: ThemeColors.kPrimaryColor,
            ),
          )
        ],
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: selectedIndex == 0
          ? ProductPage(onAddItem: () => getOrderTotalItems())
          : selectedIndex == 1
              ? OrderPage()
              : selectedIndex == 2
                  ? PaymentPage()
                  : ProductPage(onAddItem: () => getOrderTotalItems()),
      floatingActionButton: selectedIndex != 2
          ? FloatingActionButton(
              onPressed: () {
                callEmployee();
              },
              child: Icon(
                Icons.pan_tool_outlined,
                color: Colors.white,
              ),
              backgroundColor: ThemeColors.kPrepareColor,
            )
          : null,
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
              icon: Icon(Icons.shopping_cart), label: '???????????????????????????'),
          BottomNavigationBarItem(
            icon: Badge(
              shape: BadgeShape.circle,
              borderRadius: BorderRadius.circular(80),
              child: Icon(
                Icons.shopping_basket,
              ),
              badgeContent: Text(
                '$totalItems',
                style: TextStyle(color: Colors.white),
              ),
            ),
            label: '???????????????????????????????????????',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: '????????????????????????')
        ],
      ),
    );
  }
}
