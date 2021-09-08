import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/addOrder.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter_restaurant/widgets/ProductItemBox.dart';

class ProductListWidget extends StatefulWidget {
  final List<DocumentSnapshot> products;

  const ProductListWidget({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายการในหมวดหมู่'),
              Chip(
                padding: EdgeInsets.all(0),
                label: Text(
                  '${widget.products.length} รายการ',
                  style: TextStyle(
                    color: Colors.orange[800],
                  ),
                ),
                backgroundColor: Colors.orange[50],
              ),
            ],
          ),
        ),
        Expanded(
          child: ResponsiveGridList(
            desiredItemWidth: 150,
            minSpacing: 10,
            children: widget.products.map((DocumentSnapshot product) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddOrderPage(
                          product: product,
                        ),
                      ));
                    },
                    child: ProductItemBox(
                      imageUrl: '${product['imageUrl']}',
                      width: 150,
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${product['productName']}',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ราคา ${product['price']} บาท',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
