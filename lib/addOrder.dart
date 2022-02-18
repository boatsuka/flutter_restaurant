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

  String companyId;
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;

  Future checkCompanyInfo() async {
    String _companyId = await helper.getStorage('companyId');

    setState(() {
      companyId = _companyId;
    });
  }

  Future saveOrder() async {
    String tableId = await helper.getStorage('tableId');
    String tableName = await helper.getStorage('tableName');
    String orderId = await helper.getStorage('orderId');

    await dbRef
        .collection('restaurantDB')
        .doc(companyId)
        .collection('order-items')
        .add({
      "itemStatus": "ORDERING",
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

    Navigator.of(context).pop(true);
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
    checkCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.kPrimaryColor,
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
                  width: 220,
                  height: 200,
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
          height: 130,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'ระบุจำนวน :',
                      style: TextStyle(fontSize: 18),
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.remove,
                    //     color: ThemeColors.kAccentColor,
                    //     size: 25,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       if (qty != 1) {
                    //         qty--;
                    //       }
                    //     });
                    //   },
                    // ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: ThemeColors.kAccentColor,
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.remove),
                      label: Text('ลด'),
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
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.kPrimaryColor),
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: ThemeColors.kPrimaryColor,
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Text('เพิ่ม'),
                      onPressed: () {
                        setState(() {
                          qty++;
                        });
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.add_circle,
                    //     color: ThemeColors.kPrimaryColor,
                    //     size: 25,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       qty++;
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TextButton.icon(
                    //   style: TextButton.styleFrom(
                    //     primary: Colors.white,
                    //     backgroundColor: ThemeColors.kAccentColor,
                    //     minimumSize: Size(130, 50),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(20),
                    //         bottomLeft: Radius.circular(20),
                    //       ),
                    //     ),
                    //   ),
                    //   icon: Icon(Icons.cancel),
                    //   label: Text('ยกเลิก'),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: ThemeColors.kPrimaryColor,
                        onPrimary: Colors.white,
                        minimumSize: Size(400, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.check),
                      label: Text('ยืนยัน'),
                      onPressed:
                          // selectedType != null && selectedOptionName != null
                          selectedType != null
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
