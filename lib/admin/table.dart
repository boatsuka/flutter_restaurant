import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AdminTablePage extends StatefulWidget {
  @override
  _AdminTablePageState createState() => _AdminTablePageState();
}

class _AdminTablePageState extends State<AdminTablePage> {
  final dbRef = FirebaseFirestore.instance;

  Future createOrder(DocumentSnapshot document) async {
    DocumentReference ref = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('orders')
        .add({
      "orderStatus": "OPEN",
      "tableId": document.id,
      "orderDate": new DateTime.now().millisecondsSinceEpoch
    });

    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('tables')
        .doc(document.id)
        .update({"orderId": ref.id});

    Navigator.of(context).pop();
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
                  onPressed: () {},
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
                  },
                ),
              ],
            )
          ],
        );
      },
    );
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
            'โต๊ะที่เปิดให้บริการ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
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
                      return Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ));
                    default:
                      return ResponsiveGridList(
                        desiredItemWidth: 100,
                        minSpacing: 10,
                        children: snapshot.data.docs.map((document) {
                          return GestureDetector(
                            onTap: () {
                              if (document['orderId'] == null) {
                                showConfirmOrder(document);
                              }
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
                                        top: 5, bottom: 5, left: 10, right: 10),
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
                }))
      ],
    ));
  }
}
