import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/theme.dart';

class OrderItemWidget extends StatelessWidget {
  final DocumentSnapshot document;

  const OrderItemWidget({@required this.document});

  @override
  Widget build(BuildContext context) {
    Map data = this.document.data();

    double totalPrice = this.document['qty'] * this.document['price'];

    if (data.containsKey('options')) {
      double _priceOption =
          this.document['qty'] * this.document['options']['price'];
      totalPrice += _priceOption;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          // bottom: BorderSide(color: Colors.grey[100], width: 1),
          right: BorderSide(
            color: this.document['itemStatus'] == 'PREPARED'
                ? ThemeColors.kPrepareColor
                : this.document['itemStatus'] == 'SERVED'
                    ? ThemeColors.kServedColor
                    : ThemeColors.kCanceledColor,
            width: 10,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink,
          child: Text(
            '${this.document['qty']}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${this.document['productName']}'),
        isThreeLine: true,
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('หน่วยละ ${this.document['price']} บาท'),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Chip(
              label: Text('${this.document['type']}'),
              backgroundColor: Color(0xffe5eaf8),
            ),
          ),
          data.containsKey('options')
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Chip(
                    backgroundColor: Color(0xffe5eaf8),
                    label: Text('${this.document['options']['name']}'),
                    avatar: CircleAvatar(
                      child: Text(
                        '${this.document['options']['price']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                )
              : Container()
        ]),
        trailing: Text(
          '$totalPrice',
          style: TextStyle(
            fontSize: 20,
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
