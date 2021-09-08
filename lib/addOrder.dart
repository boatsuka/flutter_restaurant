import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/widgets/ProductItemBox.dart';

class AddOrderPage extends StatefulWidget {
  final DocumentSnapshot product;

  const AddOrderPage({@required this.product});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  int qty = 1;
  List types = [];
  List options = [];
  String selectedType;
  Map selectedOption;
  String selectedOptionName;

  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  Future saveOrder() async {
    String tableId = await helper.getStorage('tableId');
    String tableName = await helper.getStorage('tableName');
    String orderId = await helper.getStorage('orderId');

    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('order-items')
        .add({
      "itemStatus": "PREPARED",
      "options": selectedOption,
      "orderDate": new DateTime.now().millisecondsSinceEpoch,
      "orderId": orderId,
      "price": widget.product['price'],
      "productId": widget.product.id,
      "productName": widget.product['productName'],
      "qty": qty,
      "tableId": tableId,
      "tableName": tableName,
      "type": selectedType,
    });

    Navigator.of(context).pop();
  }

  initData() {
    setState(() {
      types = widget.product['types'];
      options = widget.product['options'];
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

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
            children: types.map((item) {
              return ListTile(
                onTap: () {
                  setState(() {
                    selectedType = item;
                  });
                },
                title: Text(item),
                leading: selectedType == item
                    ? Icon(Icons.check_box, color: Colors.green)
                    : Icon(Icons.check_box_outline_blank_outlined,
                        color: Colors.grey),
              );
            }).toList(),
          ),
          Center(child: Text('ตัวเลือก')),
          Column(
              children: options.map((item) {
            return ListTile(
              onTap: () {
                setState(() {
                  selectedOption = item;
                  selectedOptionName = item['name'];
                });
              },
              title: Text("${item['name']}"),
              trailing: Text("${item['price']}"),
              leading: selectedOptionName == item['name']
                  ? Icon(Icons.check_box, color: Colors.green)
                  : Icon(Icons.check_box_outline_blank_outlined,
                      color: Colors.grey),
            );
          }).toList())
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
                    onPressed: () {
                      setState(() {
                        if (qty != 1) {
                          qty--;
                        }
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ThemeColors.kGreyText,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '$qty',
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
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: ThemeColors.kAccentColor,
                        minimumSize: Size(130, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.cancel),
                      label: Text('ยกเลิก'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: ThemeColors.kPrimaryColor,
                        onPrimary: Colors.white,
                        minimumSize: Size(130, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.check),
                      label: Text('ยืนยัน'),
                      onPressed:
                          selectedType != null && selectedOptionName != null
                              ? () {
                                  saveOrder();
                                }
                              : null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
