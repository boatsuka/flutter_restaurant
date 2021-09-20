import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminSettingProductTypes extends StatefulWidget {
  final DocumentSnapshot document;

  AdminSettingProductTypes({@required this.document});

  @override
  _AdminSettingProductTypesState createState() =>
      _AdminSettingProductTypesState();
}

class _AdminSettingProductTypesState extends State<AdminSettingProductTypes> {
  List types = [];
  final dbRef = FirebaseFirestore.instance;

  TextEditingController ctrlName = TextEditingController();

  void setData() {
    Map data = widget.document.data();

    setState(() {
      types = data.containsKey('types') ? widget.document['types'] : [];
    });
  }

  Future save(String typeName) async {
    try {
      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .set({
        "types": FieldValue.arrayUnion([typeName])
      }, SetOptions(merge: true));

      setState(() {
        types.add(typeName);
      });

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  Future remove(int index) async {
    try {
      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .update({"types": FieldValue.delete()});

      List oldItems = types;
      oldItems.removeAt(index);

      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .set({"types": FieldValue.arrayUnion(oldItems)},
              SetOptions(merge: true));

      setState(() {
        types = oldItems;
      });

    } catch (error) {
      print(error);
    }
  }

  Future showBottomSheet() async {
    setState(() {
      ctrlName.clear();
    });
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.orange,
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'เพิ่มรายการ',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ctrlName,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    labelText: 'ชื่อประเภท',
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        label: Text('บันทึก'),
                        icon: Icon(Icons.save),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 50),
                          padding: EdgeInsets.all(20),
                          primary: ThemeColors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        onPressed: () {
                          String typeName = ctrlName.text;
                          if (typeName != null) {
                            save(typeName);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประเภทสินค้า'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('${widget.document['productName']}'),
          ),
          Expanded(
            child: types.length > 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      String type = types[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ListTile(
                          title: Text('$type'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              remove(index);
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: types.length,
                  )
                : Center(
                    child: Text('ไม่พบรายการ'),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showBottomSheet(),
      ),
    );
  }
}
