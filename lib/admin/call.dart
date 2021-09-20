import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminCallPage extends StatefulWidget {
  @override
  _AdminCallPageState createState() => _AdminCallPageState();
}

class _AdminCallPageState extends State<AdminCallPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  void setOpened(DocumentSnapshot document) async {
    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('calls')
        .doc(document.id)
        .update({
      "isOpened": true,
      "time": new DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
          child: Row(
            children: [
              Icon(Icons.chat_bubble),
              SizedBox(
                width: 10,
              ),
              Text(
                'เรียกพนักงาน',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: dbRef
              .collection('restaurantDB')
              .doc('s1KEI8hv3vt9UveKERtJ')
              .collection('calls')
              .where('isOpened', isEqualTo: false)
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('เกิดข้อผิดพลาด');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('กำลังโหลดข้อมูล...');
              default:
                return ListView(
                    children: snapshot.data.docs.length > 0
                        ? snapshot.data.docs.map((document) {
                            DateTime date =
                                new DateTime.fromMillisecondsSinceEpoch(
                                    document['time']);
                            return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              color: Color(0xffcfd8de),
                              child: ListTile(
                                onTap: () {
                                  setOpened(document);
                                },
                                leading: CircleAvatar(
                                  child: Icon(Icons.call),
                                  backgroundColor: ThemeColors.kPrimaryColor,
                                ),
                                title: Text('${document['tableName']}'),
                                subtitle: Text('${document['message']}'),
                                trailing:
                                    Text('${helper.timestampToTime(date)} น.'),
                              ),
                            );
                          }).toList()
                        : [
                            Center(
                              child: Text('ไม่พบรายการ'),
                            )
                          ]);
            }
          },
        ))
      ],
    ));
  }
}
