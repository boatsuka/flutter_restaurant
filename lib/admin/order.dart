import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  int qty = 1;

  void changeItemStatus(DocumentSnapshot document, String itemStatus) async {
    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('order-items')
        .doc(document.id)
        .update({'itemStatus': itemStatus});

    Navigator.of(context).pop();
  }

  void editQty(DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Text('แก้ไขจำนวน'),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${document['productName']}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.orange,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            if (qty != 1) {
                              qty -= 1;
                            }
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          '$qty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffcfd8dc),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: ThemeColors.kPrimaryColor,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            qty += 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.cancel),
                      label: Text('ยกเลิก'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        primary: ThemeColors.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        updateQty(document, qty);
                      },
                      icon: Icon(Icons.check),
                      label: Text('ตกลง'),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  void updateQty(DocumentSnapshot document, int _qty) async {
    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('order-items')
        .doc(document.id)
        .update({'qty': _qty});

    Navigator.of(context).pop();
  }

  void showActionMenu(DocumentSnapshot document) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 5, color: Colors.orange),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'จัดการออร์เดอร์',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(
                    Icons.send,
                    color: Colors.green,
                  ),
                  title: Text('เสิร์ฟอาหาร'),
                  subtitle: Text('เปลี่ยนสถานะเป็นเสิร์ฟ'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () => changeItemStatus(document, "SERVED"),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('แก้ไขจำนวน'),
                  subtitle: Text('แก้ไขจำนวนที่ลูกค้าสั่ง'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    setState(() {
                      qty = document['qty'];
                    });

                    editQty(document);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  title: Text('ยกเลิกรายการ'),
                  subtitle: Text('ยกเลิกรายการที่ลูกค้าสั่ง'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () => changeItemStatus(document, "CANCELED"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'รายการอาหารที่กำลังปรุง',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: dbRef
              .collection('restaurantDB')
              .doc('s1KEI8hv3vt9UveKERtJ')
              .collection('order-items')
              .where('itemStatus', isEqualTo: 'PREPARED')
              .orderBy('orderDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('เกิดข้อผิดผลาด');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
                break;
              default:
                return ResponsiveGridList(
                  desiredItemWidth: 150,
                  minSpacing: 10,
                  children: snapshot.data.docs.map((doc) {
                    Map document = doc.data();
                    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                        doc['orderDate']);
                    return GestureDetector(
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(color: Color(0xffcfd8dc)),
                        child: Stack(
                          children: [
                            Container(
                              height: 120,
                              margin: EdgeInsets.all(10),
                              // decoration: BoxDecoration(color: Colors.white),
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${doc['productName']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'x${doc['qty']}',
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      document.containsKey('type')
                                          ? Text('${document['type']}')
                                          : Container(),
                                      document.containsKey('options')
                                          ? Text(
                                              '${document['options']['name']}')
                                          : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 80,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.kPrimaryColor,
                                  ),
                                  child: Text(
                                    '${doc['tableName']}',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text('${helper.timestampToTime(date)} น.'),
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () => showActionMenu(doc),
                    );
                  }).toList(),
                );
            }
          },
        ))
      ],
    ));
  }
}
