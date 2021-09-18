import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';

class OrderRequestSplashPage extends StatefulWidget {
  final String companyId;
  final String orderId;

  const OrderRequestSplashPage(
      {@required this.companyId, @required this.orderId});

  @override
  _OrderRequestSplashPageState createState() => _OrderRequestSplashPageState();
}

class _OrderRequestSplashPageState extends State<OrderRequestSplashPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();

  Future checkOrder() async {
    DocumentSnapshot document = await dbRef
        .collection('restaurantDB')
        .doc(widget.companyId)
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (document.exists) {
      if (document['orderStatus'] == 'OPEN') {
        print('Order opened');

        DocumentSnapshot tablesDocument = await dbRef
            .collection('restaurantDB')
            .doc(widget.companyId)
            .collection('tables')
            .doc(document['tableId'])
            .get();

        String tableName = tablesDocument['tableName'];
        String orderId = widget.orderId;
        String tableId = document['tableId'];
        await helper.setStorage("tableId", tableId);
        await helper.setStorage("tableName", tableName);
        await helper.setStorage("orderId", orderId);

        Navigator.of(context).pushReplacementNamed('/');
      } else {
        print('Order closed');
      }
    } else {
      print('ไม่พบรายการออร์เดอร์');
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.companyId);
    print(widget.orderId);
    checkOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบ QR CODE'),
      ),
      body: Center(
        child: Text('กรุณารอซักครู่....'),
      ),
    );
  }
}
