import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  int totalQty = 0;
  double netTotalPrice = 0;

  String orderId;
  String tableId;
  String tableName;
  String companyId;

  List<DocumentSnapshot> items = [];

  Future checkCompanyInfo() async {
    String _companyId = await helper.getStorage('companyId');

    setState(() {
      companyId = _companyId;
    });
  }

  Future getInfo() async {
    String _orderId = await helper.getStorage('orderId');
    String _tableId = await helper.getStorage('tableId');
    String _tableName = await helper.getStorage('tableName');

    setState(() {
      orderId = _orderId;
      tableId = _tableId;
      tableName = _tableName;
    });

    if (orderId != null) {
      getOrders();
    }
  }

  Future getOrders() async {
    QuerySnapshot query = await dbRef
        .collection('restaurantDB')
        .doc(companyId)
        .collection('order-items')
        .where('orderId', isEqualTo: orderId)
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
          "message": "เก็บเงิน",
          "time": new DateTime.now().millisecondsSinceEpoch,
        });
        Fluttertoast.showToast(
            msg: "เรียกพนักงานชำระเงิน",
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
          "message": "เก็บเงิน",
          "time": new DateTime.now().millisecondsSinceEpoch,
          "tableId": tableId,
          "tableName": tableName,
          "orderId": orderId
        });
        Fluttertoast.showToast(
            msg: "เรียกพนักงานชำระเงิน",
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            webBgColor: "#00b09b",
            textColor: Colors.white,
            fontSize: 16);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "เกิดข้อผิดผลาด กรุณาลองใหม่อีกครั้ง",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "#F75151",
          textColor: Colors.white,
          fontSize: 16);
    }
  }

  @override
  void initState() {
    super.initState();
    checkCompanyInfo();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Text('เรียกพนักงานเก็บเงิน'),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: ThemeColors.kPrimaryColor,
                      minimumSize: Size(150, 50)),
                  onPressed: () => callEmployee())
            ],
          ),
        ),
      ),
    );
  }
}
