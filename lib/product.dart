import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:flutter_restaurant/widgets/ProductItemBox.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9ebee),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  ProductItemBox(
                                    imageUrl:
                                        'https://img.wongnai.com/p/1968x0/2018/04/17/06993eef2aa940e49c57c1c564c53376.jpg',
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
                                  'กระเพราหมูสับไข่ดาว',
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                children: [
                                  ProductItemBox(
                                    imageUrl:
                                        'https://img.wongnai.com/p/1968x0/2018/04/17/06993eef2aa940e49c57c1c564c53376.jpg',
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'กระเพราหมูสับไข่ดาว',
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ),
            color: Colors.white,
            height: 150,
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
                          children: [
                            Chip(
                              label: Text(
                                'อาหารตามสั่ง',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: ThemeColors.kPrimaryColor,
                            ),
                            Chip(
                              label: Text(
                                'ก๋วยเตี๋ยว',
                                style:
                                    TextStyle(color: ThemeColors.kPrimaryColor),
                              ),
                              backgroundColor: Color(0xffe5eaf0),
                            ),
                            Chip(
                              label: Text(
                                'ข้าวต้ม',
                                style:
                                    TextStyle(color: ThemeColors.kPrimaryColor),
                              ),
                              backgroundColor: Color(0xffe5eaf0),
                            ),
                            Chip(
                              label: Text(
                                'เครื่องดื่ม',
                                style:
                                    TextStyle(color: ThemeColors.kPrimaryColor),
                              ),
                              backgroundColor: Color(0xffe5eaf0),
                            ),
                            Chip(
                              label: Text(
                                'ขนม',
                                style:
                                    TextStyle(color: ThemeColors.kPrimaryColor),
                              ),
                              backgroundColor: Color(0xffe5eaf0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            color: Colors.white,
            height: 80,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
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
                            '5 รายการ',
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
                      children: [
                        Column(
                          children: [
                            ProductItemBox(
                              imageUrl:
                                  'https://img.wongnai.com/p/1968x0/2018/04/17/06993eef2aa940e49c57c1c564c53376.jpg',
                              width: 150,
                              height: 100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'กระเพราหมูสับไข่ดาว',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ราคา 50 บาท',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ProductItemBox(
                              imageUrl:
                                  'https://img.wongnai.com/p/1968x0/2018/04/17/06993eef2aa940e49c57c1c564c53376.jpg',
                              width: 150,
                              height: 100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'กระเพราหมูสับไข่ดาว',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ราคา 50 บาท',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ProductItemBox(
                              imageUrl:
                                  'https://img.wongnai.com/p/1968x0/2018/04/17/06993eef2aa940e49c57c1c564c53376.jpg',
                              width: 150,
                              height: 100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'กระเพราหมูสับไข่ดาว',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ราคา 50 บาท',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
