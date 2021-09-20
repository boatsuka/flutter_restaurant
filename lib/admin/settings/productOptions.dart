import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminSettingProductOptions extends StatefulWidget {
  final DocumentSnapshot document;

  AdminSettingProductOptions({@required this.document});

  @override
  _AdminSettingProductOptionsState createState() =>
      _AdminSettingProductOptionsState();
}

class _AdminSettingProductOptionsState
    extends State<AdminSettingProductOptions> {
  List options = [];
  final dbRef = FirebaseFirestore.instance;

  TextEditingController ctrlName = TextEditingController();
  TextEditingController ctrlPrice = TextEditingController();

  void setData() {
    Map data = widget.document.data();

    setState(() {
      options = data.containsKey('options') ? widget.document['options'] : [];
    });
  }

  Future save(String name, double price) async {
    try {
      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .set({
        "options": FieldValue.arrayUnion([
          {"name": name, "price": price}
        ])
      }, SetOptions(merge: true));

      setState(() {
        options.add({"name": name, "price": price});
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
          .update({"options": FieldValue.delete()});

      List oldItems = options;
      oldItems.removeAt(index);

      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .set({"options": FieldValue.arrayUnion(oldItems)},
              SetOptions(merge: true));

      setState(() {
        options = oldItems;
      });
    } catch (error) {
      print(error);
    }
  }

  Future showBottomSheet() async {
    setState(() {
      ctrlName.clear();
      ctrlPrice.clear();
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
                TextFormField(
                  controller: ctrlPrice,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    labelText: 'ราคา',
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
                          String name = ctrlName.text;
                          double price = double.tryParse(ctrlPrice.text) ?? 0;
                          if (name != null && price != null) {
                            save(name, price);
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
            child: options.length > 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      Map option = options[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ListTile(
                          title: Text('${option['name']}'),
                          subtitle: Text('${option['price']}'),
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
                    itemCount: options.length,
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
