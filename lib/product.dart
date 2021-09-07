import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/widgets/CategoryWidget.dart';
import 'package:flutter_restaurant/widgets/ProductListWidget.dart';
import 'package:flutter_restaurant/widgets/PromotionWidget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final dbRef = FirebaseFirestore.instance;

  bool isloading = false;
  String categoryId = "";
  List<DocumentSnapshot> products = [];

  Future getProducts() async {
    setState(() {
      isloading = true;
    });
    QuerySnapshot snapshot = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    setState(() {
      isloading = false;
      products = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();

    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9ebee),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            child: PromotionWidget(),
            color: Colors.white,
            height: 150,
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: CategoryWidget(
              onChange: (DocumentSnapshot document) {
                setState(() {
                  categoryId = document.id;
                });

                getProducts();
              },
            ),
            color: Colors.white,
            height: 80,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: products.length > 0
                  ? ProductListWidget(
                      products: products,
                    )
                  : Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.grey[300],
                            ),
                            Text(
                              'ไม่พบสินค้า',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ),
                    ),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
