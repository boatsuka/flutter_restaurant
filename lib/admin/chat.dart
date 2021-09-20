import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/admin/chatDetail.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminChatPage extends StatefulWidget {
  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  void setMessageOpened(DocumentSnapshot document) async {
    QuerySnapshot qs = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('chats')
        .doc(document['orderId'])
        .collection('messages')
        .get();

    qs.docs.forEach((_document) async {
      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('chats')
          .doc(document['orderId'])
          .collection('messages')
          .doc(_document.id)
          .update({
        "isOpened": true,
        "openTime": new DateTime.now().millisecondsSinceEpoch
      });
    });

    await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('chat-dashboard')
        .doc(document.id)
        .update({
      "isOpened": true,
      "openTime": new DateTime.now().millisecondsSinceEpoch
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminChatDetailPage(document: document)));
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
                'ข้อความจากลูกค้า',
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
              .collection('chat-dashboard')
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
                                onTap: () => setMessageOpened(document),
                                leading: CircleAvatar(
                                  child: Icon(Icons.chat_bubble),
                                  backgroundColor: ThemeColors.kPrimaryColor,
                                ),
                                title: Text('${document['message']}'),
                                subtitle: Text('${document['tableName']}'),
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
