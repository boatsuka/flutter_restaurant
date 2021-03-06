import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/widgets/CustomerChatItem.dart';
import 'package:flutter_restaurant/widgets/EmployeeChatItem.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final dbRef = FirebaseFirestore.instance;
  Helper helper = Helper();
  String orderId;
  String tableId;
  String tableName;
  String companyId;

  ScrollController listController;
  TextEditingController ctrlMessage = TextEditingController();

  Future checkCompanyInfo() async {
    String _companyId = await helper.getStorage('companyId');

    setState(() {
      companyId = _companyId;
    });

    getInfo();
  }

  Future getInfo() async {
    String _orderId = await helper.getStorage('orderId');
    String _tableId = await helper.getStorage('tableId');
    String _tableName = await helper.getStorage('tableName');

    setState(() {
      orderId = _orderId;
      tableId = _tableId;
      tableName = _tableName;
    });
  }

  Future sendMessage(String message) async {
    try {
      await dbRef
          .collection('restaurantDB')
          .doc(companyId)
          .collection('chats')
          .doc(orderId)
          .collection('messages')
          .add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "type": "CUSTOMER"
      });

      QuerySnapshot qsDashboard = await dbRef
          .collection('restaurantDB')
          .doc(companyId)
          .collection('chat-dashboard')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (qsDashboard.docs.length == 0) {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('chat-dashboard')
            .add({
          "isOpened": false,
          "message": message,
          "orderId": orderId,
          "tableId": tableId,
          "tableName": tableName,
          "time": new DateTime.now().millisecondsSinceEpoch
        });
      } else {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('chat-dashboard')
            .doc(qsDashboard.docs[0].id)
            .update({
          "isOpened": false,
          "message": message,
          "time": new DateTime.now().millisecondsSinceEpoch
        });
      }

      if (listController.hasClients) {
        listController.jumpTo(listController.position.maxScrollExtent);
      }
    } catch (e) {
      print(e);
    }
  }

  Future callEmployee() async {
    try {
      QuerySnapshot query = await dbRef
          .collection('restaurantDB')
          .doc(companyId)
          .collection('calls')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (query.docs.length > 0) {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('calls')
            .doc(query.docs[0].id)
            .update({
          "isOpened": false,
          "message": "????????????????????????????????????",
          "time": new DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        await dbRef
            .collection('restaurantDB')
            .doc(companyId)
            .collection('calls')
            .add({
          "isOpened": false,
          "message": "????????????????????????????????????",
          "time": new DateTime.now().millisecondsSinceEpoch,
          "tableId": tableId,
          "tableName": tableName,
          "orderId": orderId
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    listController = ScrollController(keepScrollOffset: true);
    checkCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '???????????????????????????????????????',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.alarm,
                    size: 18,
                    color: Colors.pink,
                  ),
                  label: Text(
                    '????????????????????????????????????',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.pink,
                  ),
                  onPressed: orderId != null ? () => callEmployee() : null,
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: orderId != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: dbRef
                        .collection('restaurantDB')
                        .doc('s1KEI8hv3vt9UveKERtJ')
                        .collection('chats')
                        .doc(orderId)
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
                                : [Center(child: Text('???????????????????????????????????????'))],
                          );
                      }
                    },
                  )
                : Container(
                    child: Center(
                      child: Text('???????????????????????????????????????'),
                    ),
                  ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: TextFormField(
          controller: ctrlMessage,
          readOnly: orderId == null ? true : false,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
            hintText: '????????????????????????????????????...',
            filled: true,
            contentPadding: EdgeInsets.all(10),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: orderId != null
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
