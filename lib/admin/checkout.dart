import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminCheckoutPage extends StatefulWidget {
  final DocumentSnapshot document;

  AdminCheckoutPage({@required this.document});

  @override
  _AdminCheckoutPageState createState() => _AdminCheckoutPageState();
}

class _AdminCheckoutPageState extends State<AdminCheckoutPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  int totalQty = 0;
  double netTotalPrice = 0;

  String orderId;
  String tableId;
  String tableName;

  List<DocumentSnapshot> items = [];

  Future closeOrder() async {
    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('orders')
        .doc(widget.document['orderId'])
        .update({'orderStatus': 'CLOSED'});

    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('tables')
        .doc(widget.document.id)
        .update({'orderId': null});

    Navigator.of(context).pop();
  }

  Future getOrders() async {
    QuerySnapshot query = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('order-items')
        .where('orderId', isEqualTo: widget.document['orderId'])
        .where('itemStatus', isEqualTo: 'SERVED')
        .get();

    int _totalQty = 0;
    double _netTotalPrice = 0;

    query.docs.forEach((doc) {
      Map document = doc.data();

      double totalPrice = document['price'] * document['qty'];

      if (document.containsKey('options')) {
        totalPrice += document['qty'] * document['options']['price'];
      }

      _totalQty += document['qty'];

      _netTotalPrice += totalPrice;
    });

    setState(() {
      netTotalPrice = _netTotalPrice;
      totalQty = _totalQty;
      items = query.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

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
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รายการอาหารที่สั่ง',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${items.length} รายการ x $totalQty ชิ้น',
                ),
              ],
            ),
          ),
          Expanded(
            child: items.length > 0
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      Map document = items[index].data();

                      double totalPrice = document['price'] * document['qty'];

                      if (document.containsKey('options')) {
                        totalPrice +=
                            document['qty'] * document['options']['price'];
                      }

                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[100], width: 1))),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              '${document['qty']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.pink,
                          ),
                          title: Text('${document['productName']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('หน่วยละ ${document['price']} บาท'),
                              document.containsKey('type') != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Chip(
                                        label: Text('${document['type']}'),
                                        backgroundColor: Color(0xffe5eaf0),
                                      ),
                                    )
                                  : Container(),
                              document.containsKey('options') != null
                                  ? Chip(
                                      label: Text(
                                          '${document['options']['name']}'),
                                      backgroundColor: Color(0xffe5eaf0),
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.orange,
                                        child: Text(
                                          '${document['options']['price']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          trailing: Text(
                            '$totalPrice',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('ไม่พบรายการ'),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 75,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xffe5eaf0),
            border: Border(
              top: BorderSide(color: ThemeColors.kPrimaryColor, width: 0.6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รวมเป็นเงิน'),
                  Text(
                    '$netTotalPrice บาท',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                child: Text('เก็บเงินลูกค้า'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: ThemeColors.kPrimaryColor,
                    minimumSize: Size(150, 50)),
                onPressed: () => closeOrder(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
