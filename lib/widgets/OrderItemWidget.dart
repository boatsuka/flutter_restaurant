import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  final DocumentSnapshot document;

  const OrderItemWidget({@required this.document});

  @override
  Widget build(BuildContext context) {
    Map data = this.document.data();

    final f = new DateFormat('yyyy-MM-dd hh:mm:ss a', 'th-TH');
    int timeUpdate = this.document['statusDate'];
    double totalPrice = this.document['qty'] * this.document['price'];

    if (data.containsKey('options')) {
      double _priceOption =
          this.document['qty'] * this.document['options']['price'];
      totalPrice += _priceOption;
    }

    return Container(
      //   decoration: BoxDecoration(
      //     border: Border(
      //       // bottom: BorderSide(color: Colors.grey[100], width: 1),
      //       right: BorderSide(
      //         color: this.document['itemStatus'] == 'PREPARED'
      //             ? ThemeColors.kPrepareColor
      //             : this.document['itemStatus'] == 'SERVED'
      //                 ? ThemeColors.kServedColor
      //                 : ThemeColors.kCanceledColor,
      //         width: 10,
      //       ),
      //     ),
      //   ),
      //   child: Column(
      //     children: [
      //       ListTile(
      //         leading: CircleAvatar(
      //           backgroundColor: Colors.pink,
      //           child: Text(
      //             '${this.document['qty']}',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //         ),
      //         title: Text('${this.document['productName']}'),
      //         isThreeLine: true,
      //         subtitle:
      //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //           Text('หน่วยละ ${this.document['price']} บาท'),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 10),
      //             child: Chip(
      //               label: Text('${this.document['type']}'),
      //               backgroundColor: Color(0xffe5eaf8),
      //             ),
      //           ),
      //           data.containsKey('options')
      //               ? Padding(
      //                   padding: const EdgeInsets.only(top: 10, bottom: 10),
      //                   child: Chip(
      //                     backgroundColor: Color(0xffe5eaf8),
      //                     label: Text('${this.document['options']['name']}'),
      //                     avatar: CircleAvatar(
      //                       child: Text(
      //                         '${this.document['options']['price']}',
      //                         style: TextStyle(color: Colors.white),
      //                       ),
      //                       backgroundColor: Colors.orange,
      //                     ),
      //                   ),
      //                 )
      //               : Container()
      //         ]),
      //         trailing: Text(
      //           '$totalPrice',
      //           style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.pink,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      child: ClipRRect(
        child: Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(color: Colors.grey[100], width: 1),
          //   ),
          // ),
          color: Colors.white60,
          child: Row(
            children: [
              Container(
                  color: this.document['itemStatus'] == 'ORDERING'
                      ? ThemeColors.kAccentColor
                      : this.document['itemStatus'] == 'PREPARED'
                          ? ThemeColors.kPrepareColor
                          : this.document['itemStatus'] == 'SERVED'
                              ? ThemeColors.kServedColor
                              : ThemeColors.kCanceledColor,
                  width: 85,
                  height: 160,
                  child: this.document['itemStatus'] == 'ORDERING'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_basket_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'สั่งแล้ว',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      : this.document['itemStatus'] == 'PREPARED'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_restaurant,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text('กำลังปรุง',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            )
                          : this.document['itemStatus'] == 'SERVED'
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text('เสร็จแล้ว',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text('ยกเลิก',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${this.document['productName']}'),
                    Text('หน่วยละ ${this.document['price']} บาท'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Chip(
                        backgroundColor: Color(0xffe5eaf8),
                        label: Text('จำนวน'),
                        avatar: CircleAvatar(
                          child: Text(
                            '${this.document['qty']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Chip(
                            label: Text('${this.document['type']}'),
                            backgroundColor: Color(0xffe5eaf8),
                          ),
                        ),
                        data.containsKey('options')
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5, top: 9),
                                child: Chip(
                                  backgroundColor: Color(0xffe5eaf8),
                                  label: Text(
                                      '${this.document['options']['name']}'),
                                  avatar: CircleAvatar(
                                    child: Text(
                                      '${this.document['options']['price']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Chip(
                        label: Text(
                            "อัพเดทเมื่อ ${f.format(new DateTime.fromMillisecondsSinceEpoch(timeUpdate))}"),
                        backgroundColor: Color(0xffe5eaf8),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  '$totalPrice',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
