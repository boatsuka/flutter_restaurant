import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/widgets/OrderItemWidget.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();
  String orderId;

  Future getOrderId() async {
    String _orderId = await helper.getStorage('orderId');
    setState(() {
      orderId = _orderId;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'โต๊ะ 1',
              style: TextStyle(color: Colors.pink, fontSize: 20),
            ),
          ),
          Text('รายการอาหารที่สั่ง'),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('restaurantDB')
                    .doc('s1KEI8hv3vt9UveKERtJ')
                    .collection('order-items')
                    .where('orderId', isEqualTo: orderId)
                    .orderBy('orderDate', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, int index) {
                        return OrderItemWidget(
                          document: snapshot.data.docs[index],
                        );
                      });
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Container(
          height: 45,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('เสร็จแล้ว'),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: ThemeColors.kServedColor, width: 5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('กำลังปรุง'),
                decoration: BoxDecoration(
                  border: Border(
                    left:
                        BorderSide(color: ThemeColors.kPrepareColor, width: 5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('ยกเลิก'),
                decoration: BoxDecoration(
                  border: Border(
                    left:
                        BorderSide(color: ThemeColors.kCanceledColor, width: 5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
