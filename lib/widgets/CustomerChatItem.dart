import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';

class CustomerChatItem extends StatelessWidget {
  final DocumentSnapshot message;

  CustomerChatItem({@required this.message});

  @override
  Widget build(BuildContext context) {
    Helper helper = new Helper();

    DateTime date = new DateTime.fromMillisecondsSinceEpoch(message['time']);

    return Container(
      padding: EdgeInsets.only(
        right: 80,
        left: 10,
        top: 10,
        bottom: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(15),
        ),
        child: Container(
          color: Colors.indigo[50],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 15),
                child: Text(
                  '${message['message']}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Positioned(
                child: Text(
                  '${helper.timestampToTime(date)}',
                  style: TextStyle(fontSize: 10),
                ),
                bottom: 1,
                right: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
