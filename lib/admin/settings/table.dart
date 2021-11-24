import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminSettingTable extends StatefulWidget {
  @override
  _AdminSettingTableState createState() => _AdminSettingTableState();
}

class _AdminSettingTableState extends State<AdminSettingTable> {
  bool isEdit = false;
  DocumentSnapshot editDocument;
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlName = new TextEditingController();

  Future save() async {
    try {
      String tableName = ctrlName.text;

      dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('tables')
          .add({'orderId': null, 'tableName': tableName});

      setState(() {
        ctrlName.clear();
      });

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  Future remove(DocumentSnapshot document) async {
    try {
      dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('tables')
          .doc(document.id)
          .delete();
    } catch (error) {
      print(error);
    }
  }

  Future update() async {
    try {
      String tableName = ctrlName.text;

      dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('tables')
          .doc(editDocument.id)
          .update({'tableName': tableName});

      setState(() {
        editDocument = null;
        isEdit = false;
        ctrlName.clear();
      });

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  Future showAddModel() async {
    if (isEdit) {
      ctrlName.text = editDocument['tableName'];
    }
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('${isEdit ? 'แก้ไขโต๊ะ' : 'เพิ่มโต๊ะ'}'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: ctrlName,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'ชื่อโต๊ะ',
                      prefixIcon: Icon(Icons.edit)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50),
                          primary: ThemeColors.kAccentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
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
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (ctrlName.text != null) {
                            if (isEdit) {
                              update();
                            } else {
                              save();
                            }
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text('บันทึก'),
                      ),
                    ),
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
      appBar: AppBar(title: Text('จัดการโต๊ะอาหาร')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.list),
                Text('รายการโต๊ะอาหาร'),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: dbRef
                  .collection('restaurantDB')
                  .doc('s1KEI8hv3vt9UveKERtJ')
                  .collection('tables')
                  .orderBy('tableName', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                    break;
                  default:
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        return Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          decoration: BoxDecoration(
                            color: Color(0xffcfd8dc),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'แก้ไข',
                                color: Colors.black45,
                                icon: Icons.edit,
                                onTap: () {
                                  setState(() {
                                    isEdit = true;
                                    editDocument = document;
                                  });

                                  showAddModel();
                                },
                              ),
                              IconSlideAction(
                                caption: 'ลบ',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  remove(document);
                                },
                              ),
                            ],
                            child: ListTile(
                              title: Text('${document['tableName']}'),
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAddModel();
        },
      ),
    );
  }
}
