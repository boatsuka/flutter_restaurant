import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/widgets/ProductItemBox.dart';

class AddOrderPage extends StatefulWidget {
  final DocumentSnapshot product;

  const AddOrderPage({Key? key, required this.product}) : super(key: key);

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สั่งอาหาร'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.product['productName']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ProductItemBox(
                  imageUrl: '${widget.product['imageUrl']}',
                  width: 150,
                  height: 100,
                ),
                Text('ราคา ${widget.product['price']} บาท'),
              ],
            ),
          ),
          Center(child: Text('รายละเอียด / รูปแบบ')),
          Column(
            children: [
              ListTile(
                title: Text('สูตรธรรมดา'),
                leading: Icon(Icons.check_box_outline_blank_outlined),
              ),
              ListTile(
                title: Text('สูตรพิเศษ'),
                leading: Icon(Icons.check_box_outline_blank_outlined),
              ),
            ],
          ),
          Center(child: Text('ตัวเลือก')),
          Column(
            children: [
              ListTile(
                title: Text('ไข่ดาว'),
                trailing: Text('10 บาท'),
                leading: Icon(Icons.check_box_outline_blank_outlined),
              ),
              ListTile(
                title: Text('ไส้กรอก'),
                trailing: Text('10 บาท'),
                leading: Icon(Icons.check_box_outline_blank_outlined),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: ThemeColors.kAccentColor,
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ThemeColors.kGreyText,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '2',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.kPrimaryColor),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: ThemeColors.kPrimaryColor,
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: ThemeColors.kAccentColor,
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.cancel),
                    label: Text('ยกเลิก'),
                    onPressed: () {},
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: ThemeColors.kPrimaryColor,
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.check),
                    label: Text('ยืนยัน'),
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
