import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/widgets/OrderItemWidget.dart';

class AdminOrderItemPage extends StatefulWidget {
  final DocumentSnapshot document;

  AdminOrderItemPage({@required this.document});

  @override
  _AdminOrderItemPageState createState() => _AdminOrderItemPageState();
}

class _AdminOrderItemPageState extends State<AdminOrderItemPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('รายการอาหารที่สั่ง'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              '${widget.document['tableName']}',
              style: TextStyle(color: Colors.pink, fontSize: 20),
            ),
          ),
          Text('รายการอาหารที่สั่ง'),
          Divider(),
          Expanded(
              child: widget.document['orderId'] != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: dbRef
                          .collection('restaurantDB')
                          .doc('s1KEI8hv3vt9UveKERtJ')
                          .collection('order-items')
                          .where('orderId',
                              isEqualTo: widget.document['orderId'])
                          .orderBy('orderDate', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print('snapshot.error');
                          return Text('${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Text('Loading...');
                          default:
                            return snapshot.hasData
                                ? ListView(
                                    children: snapshot.data.docs.map((e) {
                                      return OrderItemWidget(document: e);
                                    }).toList(),
                                  )
                                : Center(child: Text('ไม่พบรายการ'));
                        }
                      })
                  : Container(
                      child: Center(
                        child: Text('ไม่พบรายการ'),
                      ),
                    ))
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
