import 'dart:html';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/showQRCode.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:week_of_year/week_of_year.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  String webUrl;
  final dbRef = FirebaseFirestore.instance;

  void getCurrentUrl() {
    String url = window.location.href;
    String xurl = url.split('#')[0];

    setState(() {
      webUrl = xurl;
    });
  }

  Future createOrder(DocumentSnapshot document) async {
    DocumentReference ref = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('orders')
        .add({
      "orderStatus": "OPEN",
      "tableId": document.id,
      "orderDay": new DateTime.now().day,
      "orderWeek": new DateTime.now().weekOfYear,
      "orderMonth": new DateTime.now().month,
      "orderDate": new DateTime.now().millisecondsSinceEpoch
    });

    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('tables')
        .doc(document.id)
        .update({"orderId": ref.id});

    Navigator.of(context).pop();
    showQrcode(document, ref.id);
  }

  void showConfirmOrder(DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('ยืนยันการออกออร์เดอร์'),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  'ต้องการออกออร์เดอร์สำหรับ ${document['tableName']} ใช่หรือไม่?'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel),
                  label: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                      primary: ThemeColors.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ))),
                  onPressed: () {
                    createOrder(document);
                    Fluttertoast.showToast(
                        msg: "เปิดออร์เดอร์ ${document['tableName']} เสร็จสิ้น",
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void showQrcode(DocumentSnapshot document, String orderId) {
    String orderUrl = '$webUrl#/request/s1KEI8hv3vt9UveKERtJ/${orderId}';
    print(orderUrl);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowQRCodePage(
          url: orderUrl,
          tableName: document['tableName'],
        ),
      ),
    );
  }

  // void showActionMenu(DocumentSnapshot document) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           decoration: BoxDecoration(
  //               border:
  //                   Border(top: BorderSide(width: 5, color: Colors.orange))),
  //           child: Column(
  //             children: [
  //               Text(
  //                 'จัดการโต๊ะ',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               ListTile(
  //                 title: Text('คิดเงิน'),
  //                 subtitle: Text('คิดเงินลูกค้า'),
  //                 leading: Icon(
  //                   Icons.money_off,
  //                   color: ThemeColors.kPrimaryColor,
  //                 ),
  //                 trailing: Icon(Icons.arrow_right),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => AdminCheckoutPage(
  //                             document: document,
  //                           )));
  //                 },
  //               ),
  //               ListTile(
  //                 title: Text('คิวอาร์โค้ด'),
  //                 subtitle: Text('แสดง/พิมพ์ คิวอาร์โค้ด'),
  //                 leading: Icon(
  //                   Icons.qr_code_scanner,
  //                   color: ThemeColors.kPrimaryColor,
  //                 ),
  //                 trailing: Icon(Icons.arrow_right),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   showQrcode(document);
  //                 },
  //               ),
  //               ListTile(
  //                 title: Text('รายการออร์เดอร์'),
  //                 subtitle: Text('รายการสินค้าที่ลูกค้าสั่ง'),
  //                 leading: Icon(
  //                   Icons.list,
  //                   color: ThemeColors.kPrimaryColor,
  //                 ),
  //                 trailing: Icon(Icons.arrow_right),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => AdminOrderItemPage(
  //                             document: document,
  //                           )));
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'โต๊ะที่เปิดให้บริการ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: dbRef
                      .collection('restaurantDB')
                      .doc('s1KEI8hv3vt9UveKERtJ')
                      .collection('tables')
                      .orderBy('tableName')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return new Text('เกิดข้อผิดพลาด');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          )),
                        );
                      default:
                        return ResponsiveGridList(
                          desiredItemWidth: 100,
                          minSpacing: 10,
                          children: snapshot.data.docs.map((document) {
                            return GestureDetector(
                              onTap: () {
                                if (document['orderId'] == null) {
                                  showConfirmOrder(document);
                                } else {}
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: document['orderId'] == null
                                      ? Colors.green[50]
                                      : Colors.pink[50],
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                        height: 100,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.bottomLeft,
                                        child: document['orderId'] == null
                                            ? Text(
                                                'ว่าง',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : Text(
                                                'ไม่ว่าง',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.pink,
                                                ),
                                              )),
                                    Container(
                                      child: Text(
                                        '${document['tableName']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      decoration: BoxDecoration(
                                          color: ThemeColors.kPrimaryColor),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
