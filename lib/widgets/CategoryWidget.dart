import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryWidget extends StatefulWidget {
  final Function(DocumentSnapshot) onChange;

  const CategoryWidget({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final dbRef = FirebaseFirestore.instance;

  bool isloading = false;
  DocumentReference? selectedCategory;
  List<DocumentSnapshot> categories = [];

  Future getCategories() async {
    setState(() {
      isloading = true;
    });
    QuerySnapshot snapshot = await dbRef
        .collection('restaurantDB')
        .doc('s1KEI8hv3vt9UveKERtJ')
        .collection('categories')
        .get();

    setState(() {
      isloading = false;
      categories = snapshot.docs;

      if (categories.length > 0) {
        selectedCategory = categories[0].reference;
        widget.onChange(categories[0]);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
          child: Text('หมวดหมู่สินค้า'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((DocumentSnapshot document) {
                    return GestureDetector(
                      child: Chip(
                        label: Text(
                          '${document['categoryName']}',
                          style: selectedCategory == document.reference
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: ThemeColors.kPrimaryColor),
                        ),
                        backgroundColor: selectedCategory == document.reference
                            ? ThemeColors.kPrimaryColor
                            : Color(0xffe5eaf0),
                      ),
                      onTap: () {
                        widget.onChange(document);
                        setState(() {
                          selectedCategory = document.reference;
                        });
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
