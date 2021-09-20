import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/widgets/CustomerChatItem.dart';
import 'package:flutter_restaurant/widgets/EmployeeChatItem.dart';

class AdminChatDetailPage extends StatefulWidget {
  final DocumentSnapshot document;

  AdminChatDetailPage({@required this.document});

  @override
  _AdminChatDetailPageState createState() => _AdminChatDetailPageState();
}

class _AdminChatDetailPageState extends State<AdminChatDetailPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();

  ScrollController listController;
  TextEditingController ctrlMessage = TextEditingController();

  Future sendMessage(String message) async {
    try {
      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('chats')
          .doc(widget.document['orderId'])
          .collection('messages')
          .add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "type": "EMPLOYEE"
      });

      if (listController.hasClients) {
        listController.jumpTo(listController.position.maxScrollExtent);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('คุยกับลูกค้า'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คุยกับลูกค้า ${widget.document['tableName']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: dbRef
                .collection('restaurantDB')
                .doc('s1KEI8hv3vt9UveKERtJ')
                .collection('chats')
                .doc(widget.document['orderId'])
                .collection('messages')
                .orderBy('time', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    children: snapshot.data.docs.length > 0
                        ? snapshot.data.docs.map((e) {
                            return e['type'] == "CUSTOMER"
                                ? CustomerChatItem(
                                    message: e,
                                  )
                                : EmployeeChatItem(
                                    message: e,
                                  );
                          }).toList()
                        : [Center(child: Text('ไม่พบการสนทนา'))],
                  );
              }
            },
          ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: TextFormField(
          controller: ctrlMessage,
          readOnly: widget.document['orderId'] == null ? true : false,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
            hintText: 'พิมพ์ข้อความ...',
            filled: true,
            contentPadding: EdgeInsets.all(10),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: widget.document['orderId'] != null
                  ? () {
                      if (ctrlMessage.text.isNotEmpty) {
                        String message = ctrlMessage.text;
                        sendMessage(message);

                        setState(() {
                          ctrlMessage.clear();
                        });
                      }
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
