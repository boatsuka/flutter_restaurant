import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_chart/d_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController ctrlReportDate = TextEditingController();
  TextEditingController ctrlReportDateStart = TextEditingController();
  TextEditingController ctrlReportDateEnd = TextEditingController();

  Helper helper = Helper();
  DateTime reportDate;
  DateTime reportDateStart;
  DateTime reportDateEnd;
  double totalPrice = 0;
  double totalProduct = 0;
  double totalPriceY = 0;
  double totalProductY = 0;
  double totalBalance = 0;
  double totalBalanceProduct = 0;
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> resultsY = [];
  List<Map<String, dynamic>> productsY = [];
  List pages = [0, 1];
  // int _currentIndex = 0;

  final dbRef = FirebaseFirestore.instance;

  Future getOrderItemsToDay() async {
    try {
      int startDate = new DateTime(
        reportDate.year,
        reportDate.month,
        reportDate.day,
        0,
        0,
        0,
      ).millisecondsSinceEpoch;

      int endDate = new DateTime(
        reportDate.year,
        reportDate.month,
        reportDate.day,
        23,
        59,
        59,
      ).millisecondsSinceEpoch;

      int startDateY = new DateTime(
        reportDate.year,
        reportDate.month,
        reportDate.day - 1,
        0,
        0,
        0,
      ).millisecondsSinceEpoch;

      int endDateY = new DateTime(
        reportDate.year,
        reportDate.month,
        reportDate.day - 1,
        23,
        59,
        59,
      ).millisecondsSinceEpoch;

      QuerySnapshot qsTable = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('tables')
          .orderBy('tableName', descending: false)
          .get();

      QuerySnapshot qs = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderDate', isLessThanOrEqualTo: endDate)
          .where('orderDate', isGreaterThanOrEqualTo: startDate)
          .get();
      // yestesday
      QuerySnapshot qsY = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderDate', isLessThanOrEqualTo: endDateY)
          .where('orderDate', isGreaterThanOrEqualTo: startDateY)
          .get();

      QuerySnapshot p = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .get();

      QuerySnapshot ps = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderDate', isLessThanOrEqualTo: endDate)
          .where('orderDate', isGreaterThanOrEqualTo: startDate)
          .get();

      // yestesday
      QuerySnapshot psY = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderDate', isLessThanOrEqualTo: endDateY)
          .where('orderDate', isGreaterThanOrEqualTo: startDateY)
          .get();

      double _totalPrice = 0;
      double _totalProduct = 0;
      double _totalPriceY = 0;
      double _totalProductY = 0;

      List<Map<String, dynamic>> _results = [];
      List<Map<String, dynamic>> _products = [];
      List<Map<String, dynamic>> _resultsY = [];
      List<Map<String, dynamic>> _productsY = [];

      // today
      p.docs.forEach((tDocument) {
        Map<String, dynamic> product = new Map();
        double _qtyProductsY = 0;
        double _qtyProducts = 0;
        product['productName'] = tDocument['productName'];

        ps.docs.forEach((document) {
          if (document['productId'] == tDocument.id) {
            double qtyProduct = document['qty'];

            _qtyProducts += qtyProduct;
            _totalProduct += qtyProduct;
          }
        });

        psY.docs.forEach((document) {
          if (document['productId'] == tDocument.id) {
            double qtyProduct = document['qty'];

            _qtyProductsY += qtyProduct;
            _totalProductY += qtyProduct;
          }
        });

        product['total'] = _qtyProducts;
        product['totalY'] = _qtyProductsY;
        product['balance'] = _qtyProductsY - _qtyProducts;

        _products.add(product);
      });

      // today
      qsTable.docs.forEach((tDocument) {
        Map<String, dynamic> table = new Map();
        table['tableName'] = tDocument['tableName'];
        double totalPricetable = 0;
        double totalPricetableY = 0;

        qs.docs.forEach((document) {
          Map<String, dynamic> data = document.data();

          if (document['tableId'] == tDocument.id) {
            double qtyPrice = document['qty'] * document['price'];
            if (data.containsKey('options')) {
              double optionsPrice =
                  document['options']['price'] * document['qty'];
              qtyPrice += optionsPrice;
            }

            totalPricetable += qtyPrice;

            _totalPrice += qtyPrice;
          }
        });

        qsY.docs.forEach((document) {
          Map<String, dynamic> data = document.data();

          if (document['tableId'] == tDocument.id) {
            double qtyPrice = document['qty'] * document['price'];
            if (data.containsKey('options')) {
              double optionsPrice =
                  document['options']['price'] * document['qty'];
              qtyPrice += optionsPrice;
            }

            totalPricetableY += qtyPrice;

            _totalPriceY += qtyPrice;
          }
        });

        table['total'] = totalPricetable;
        table['totalY'] = totalPricetableY;
        table['balance'] = totalPriceY - totalPricetable;
        _results.add(table);
      });

      setState(() {
        results = _results;
        resultsY = _resultsY;
        products = _products;
        productsY = _productsY;
        totalProduct = _totalProduct;
        totalProductY = _totalProductY;
        totalPrice = _totalPrice;
        totalPriceY = _totalPriceY;
        totalBalance = _totalPrice - _totalPriceY;
        totalBalanceProduct = _totalProduct - _totalProductY;
      });
    } catch (error) {
      print(error);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (mounted) {
  //     getOrderItemsRealTime();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Card(
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 60,
                    child: TextFormField(
                      readOnly: true,
                      controller: ctrlReportDate,
                      decoration: InputDecoration(
                        labelText: 'ข้อมูล ณ วันที่',
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 90)),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    child: child,
                                    data: ThemeData.light().copyWith(
                                        primaryColor: ThemeColors.kPrimaryColor,
                                        buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        colorScheme: ColorScheme.light(
                                          primary: ThemeColors.kPrimaryColor,
                                        ).copyWith(
                                            secondary:
                                                ThemeColors.kAccentColor)),
                                  );
                                });
                            if (selectedDate != null) {
                              String strDate = new DateFormat.yMMMMd('th_TH')
                                  .format(selectedDate);

                              setState(() {
                                ctrlReportDate.text = strDate;
                                reportDate = selectedDate;
                              });

                              getOrderItemsToDay();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CarouselSlider(
          items: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'วันนี้',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalPrice, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'บาท',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เมื่อวาน',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalPrice, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'บาท',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'คงเหลือ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalBalance, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'บาท',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1000,
                    height: 400,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: DChartBar(
                              showBarValue: true,
                              data: [
                                {
                                  'id': 'Bar1',
                                  'data': results.map((e) {
                                    return {
                                      'domain': e['tableName'],
                                      'measure': e['total']
                                    };
                                  }).toList()
                                },
                                {
                                  'id': 'Bar2',
                                  'data': results.map((e) {
                                    return {
                                      'domain': e['tableName'],
                                      'measure': e['totalY']
                                    };
                                  }).toList()
                                }
                              ],
                              barValueColor: Colors.white,
                              barColor: (item, index, id) => id == 'Bar1'
                                  ? Colors.amber
                                  : ThemeColors.kPrimaryColor,
                              barValue: (item, index) =>
                                  item['measure'].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'วันนี้',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalProduct, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'เมนู',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เมื่อวาน',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalProductY, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'เมนู',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints.tightFor(height: 125, width: 200),
                          decoration: BoxDecoration(
                              color: ThemeColors.kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'คงเหลือ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${helper.formatNumber(totalBalanceProduct, 0)}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  'เมนู',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1000,
                    height: 400,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: DChartBar(
                              showBarValue: true,
                              data: [
                                {
                                  'id': 'Bar1',
                                  'data': products.map((e) {
                                    return {
                                      'domain': e['productName'],
                                      'measure': e['total']
                                    };
                                  }).toList()
                                },
                                {
                                  'id': 'Bar2',
                                  'data': products.map((e) {
                                    return {
                                      'domain': e['productName'],
                                      'measure': e['totalY']
                                    };
                                  }).toList()
                                }
                              ],
                              barValueColor: Colors.white,
                              barColor: (item, index, id) => id == 'Bar1'
                                  ? Colors.amber
                                  : ThemeColors.kPrimaryColor,
                              barValue: (item, index) =>
                                  item['measure'].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            height: 550,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
          ),
        ),
      ],
    ));
  }
}
