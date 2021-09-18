import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQRCodePage extends StatelessWidget {
  final String url;
  final String tableName;

  const ShowQRCodePage({@required this.url,@required this.tableName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.kPrimaryColor,
      appBar: AppBar(
        title: Text(
          'คิวอาร์โค้ดสั่งอาหาร',
          style: TextStyle(color: ThemeColors.kPrimaryColor),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: ThemeColors.kPrimaryColor),
      ),
      body: Center(
        child: Container(
          height: 280,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${this.tableName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              QrImage(
                size: 180,
                data: '${this.url}',
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
