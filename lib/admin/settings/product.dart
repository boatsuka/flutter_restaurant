import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/admin/settings/editProduct.dart';
import 'package:flutter_restaurant/admin/settings/productOptions.dart';
import 'package:flutter_restaurant/admin/settings/productTypes.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminSettingProducts extends StatefulWidget {
  @override
  _AdminSettingProductsState createState() => _AdminSettingProductsState();
}

class _AdminSettingProductsState extends State<AdminSettingProducts> {
  final dbRef = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future doRemoveProduct(DocumentSnapshot document) async {
    String url = document['imageUrl'];
    try {
      await storage
          .ref()
          .child(url)
          .delete()
          .then((value) => print('ลบไฟล์แล้ว'));

      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(document.id)
          .delete();
      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  Future showConfirmRemove(DocumentSnapshot document) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('ต้องการลบหรือไม่'),
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('ต้องการลบรายการนี้ ใช่หรือไม่'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
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
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
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
                        onPressed: () => doRemoveProduct(document),
                        icon: Icon(Icons.remove_circle),
                        label: Text('ตกลง'),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสินค้า'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: [
                Icon(Icons.list),
                SizedBox(width: 10),
                Text(
                  'รายการสินค้า',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('restaurantDB')
                    .doc('s1KEI8hv3vt9UveKERtJ')
                    .collection('products')
                    .orderBy('productName', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('เกิดข้อผิดพลาด');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading...');
                      break;
                    default:
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot product = snapshot.data.docs[index];

                          return Container(
                            margin:
                                EdgeInsets.only(left: 20, top: 10, right: 20),
                            decoration: BoxDecoration(
                              color: Color(0xffcfd8dc),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'แก้ไข',
                                  color: Colors.black45,
                                  icon: Icons.edit,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdminSettingEditProduct(
                                              document: product,
                                            )),
                                  ),
                                ),
                                IconSlideAction(
                                  caption: 'ประเภท',
                                  color: Colors.green,
                                  icon: Icons.list,
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminSettingProductTypes(
                                                document: product,
                                              ))),
                                ),
                                IconSlideAction(
                                  caption: 'ตัวเลือก',
                                  color: Colors.orange,
                                  icon: Icons.list,
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminSettingProductOptions(
                                                document: product,
                                              ))),
                                ),
                                IconSlideAction(
                                  caption: 'ลบ',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    showConfirmRemove(product);
                                  },
                                ),
                              ],
                              child: ListTile(
                                title: Text('${product['productName']}'),
                                trailing: Icon(Icons.view_headline),
                              ),
                            ),
                          );
                        },
                      );
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/admin/add/product'),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
