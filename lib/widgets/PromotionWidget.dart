import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/widgets/ProductItemBox.dart';

class PromotionWidget extends StatefulWidget {

  @override
  _PromotionWidgetState createState() => _PromotionWidgetState();
}

class _PromotionWidgetState extends State<PromotionWidget> {
  final dbRef = FirebaseFirestore.instance;

  bool isloading = false;
  List<DocumentSnapshot> promotions = [];

  Future getPromotions() async {
    setState(() {
      isloading = true;
    });
    QuerySnapshot snapshot = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('products')
        .where('isPromotion', isEqualTo: true)
        .get();

    setState(() {
      isloading = false;
      promotions = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();

    getPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isloading
            ? LinearProgressIndicator(
                backgroundColor: Colors.pink[50],
                valueColor: AlwaysStoppedAnimation(Colors.pink),
                value: 1000,
              )
            : Container(),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
          child: Text('สินค้าแนะนำ'),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: promotions.map((document) {
                    return Column(
                      children: [
                        Stack(
                          children: [
                            ProductItemBox(
                              imageUrl: document['imageUrl'],
                              width: 100,
                              height: 70,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              child: Text(
                                'ใหม่',
                                style: TextStyle(color: Colors.pink),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.pink[50],
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            document['productName'],
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
