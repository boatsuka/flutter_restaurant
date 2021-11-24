import 'package:flutter/material.dart';

class NotFoundPage extends StatefulWidget {
  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.face_unlock_rounded,
              size: 40,
              color: Colors.red,
            ),
            Text('ไม่พบร้านค้า กรุณาสแกนคิวอาร์โค้ด'),
          ],
        ),
      ),
    );
  }
}
