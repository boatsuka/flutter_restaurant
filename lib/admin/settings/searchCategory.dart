import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSettingSearchCategory extends StatefulWidget {
  @override
  _AdminSettingSearchCategoryState createState() =>
      _AdminSettingSearchCategoryState();
}

class _AdminSettingSearchCategoryState
    extends State<AdminSettingSearchCategory> {
  final dbRef = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลหมวดหมู่สินค้า'),
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
                  'รายการหมวดหมู่สินค้า',
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
                    .collection('categories')
                    .orderBy('categoryName', descending: false)
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
                          DocumentSnapshot category = snapshot.data.docs[index];

                          return Container(
                            margin:
                                EdgeInsets.only(left: 20, top: 10, right: 20),
                            decoration: BoxDecoration(
                              color: Color(0xffcfd8dc),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text('${category['categoryName']}'),
                              trailing: Icon(Icons.view_headline),
                              onTap: () {
                                Navigator.of(context).pop(category);
                              },
                            ),
                          );
                        },
                      );
                  }
                }),
          )
        ],
      ),
    );
  }
}
