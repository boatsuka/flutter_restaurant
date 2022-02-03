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
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> products = [];
  List pages = [0, 1];
  int _currentIndex = 0;

  final dbRef = FirebaseFirestore.instance;

  Future getOrderItemsRealTime() async {
    try {
      int startDate = new DateTime.now().millisecondsSinceEpoch;

      int endDate = new DateTime(
        9999,
        99,
        99,
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

      double _totalPrice = 0;
      double _totalProduct = 0;

      List<Map<String, dynamic>> _results = [];
      List<Map<String, dynamic>> _products = [];

      p.docs.forEach((tDocument) {
        Map<String, dynamic> product = new Map();
        double _qtyProducts = 0;
        product['productName'] = tDocument['productName'];

        ps.docs.forEach((document) {
          if (document['productId'] == tDocument.id) {
            double qtyProduct = document['qty'];

            _qtyProducts += qtyProduct;
            _totalProduct += qtyProduct;
          }
        });
        product['total'] = _qtyProducts;
        _products.add(product);
      });

      qsTable.docs.forEach((tDocument) {
        Map<String, dynamic> table = new Map();
        table['tableName'] = tDocument['tableName'];
        double totalPricetable = 0;

        qs.docs.forEach((document) {
          Map data = document.data();

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
        table['total'] = totalPricetable;
        _results.add(table);
      });

      setState(() {
        results = _results;
        products = _products;
        totalProduct = _totalProduct;
        totalPrice = _totalPrice;
        ctrlReportDate.text =
            new DateFormat.yMMMMd('th_TH').format(DateTime.now());
      });
    } catch (error) {
      print(error);
    }
  }

  Future getOrderItems() async {
    try {
      int startDate = new DateTime(
        reportDateStart.year,
        reportDateStart.month,
        reportDateStart.day,
        0,
        0,
        0,
      ).millisecondsSinceEpoch;

      int endDate = new DateTime(
        reportDateEnd.year,
        reportDateEnd.month,
        reportDateEnd.day,
        0,
        0,
        0,
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

      double _totalPrice = 0;
      double _totalProduct = 0;

      List<Map<String, dynamic>> _results = [];
      List<Map<String, dynamic>> _products = [];

      p.docs.forEach((tDocument) {
        Map<String, dynamic> product = new Map();
        double _qtyProducts = 0;
        product['productName'] = tDocument['productName'];

        ps.docs.forEach((document) {
          if (document['productId'] == tDocument.id) {
            double qtyProduct = document['qty'];

            _qtyProducts += qtyProduct;
            _totalProduct += qtyProduct;
          }
        });
        product['total'] = _qtyProducts;
        _products.add(product);
      });

      qsTable.docs.forEach((tDocument) {
        Map<String, dynamic> table = new Map();
        table['tableName'] = tDocument['tableName'];
        double totalPricetable = 0;

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
        table['total'] = totalPricetable;
        _results.add(table);
      });

      setState(() {
        results = _results;
        products = _products;
        totalProduct = _totalProduct;
        totalPrice = _totalPrice;
      });
    } catch (error) {
      print(error);
    }
  }

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

      double _totalPrice = 0;
      double _totalProduct = 0;

      List<Map<String, dynamic>> _results = [];
      List<Map<String, dynamic>> _products = [];

      p.docs.forEach((tDocument) {
        Map<String, dynamic> product = new Map();
        double _qtyProducts = 0;
        product['productName'] = tDocument['productName'];

        ps.docs.forEach((document) {
          if (document['productId'] == tDocument.id) {
            double qtyProduct = document['qty'];

            _qtyProducts += qtyProduct;
            _totalProduct += qtyProduct;
          }
        });
        product['total'] = _qtyProducts;
        _products.add(product);
      });

      qsTable.docs.forEach((tDocument) {
        Map<String, dynamic> table = new Map();
        table['tableName'] = tDocument['tableName'];
        double totalPricetable = 0;

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
        table['total'] = totalPricetable;
        _results.add(table);
      });

      print(_products);

      setState(() {
        results = _results;
        products = _products;
        totalProduct = _totalProduct;
        totalPrice = _totalPrice;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getOrderItemsRealTime();
    }
  }

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
                                    DateTime.now().subtract(Duration(days: 30)),
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
                                            secondary: ThemeColors.kAccentColor)),
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
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 60,
                          child: TextFormField(
                            readOnly: true,
                            controller: ctrlReportDateStart,
                            decoration: InputDecoration(
                              labelText: 'ตั้งแต่ วันที่',
                              hintText: 'dd/mm/yyyy',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 30)),
                                      lastDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          child: child,
                                          data: ThemeData.light().copyWith(
                                              primaryColor:
                                                  ThemeColors.kPrimaryColor,
                                              buttonTheme: ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary,
                                              ),
                                              colorScheme: ColorScheme.light(
                                                primary:
                                                    ThemeColors.kPrimaryColor,
                                              ).copyWith(
                                                  secondary:
                                                      ThemeColors.kAccentColor)),
                                        );
                                      });
                                  if (selectedDate != null) {
                                    String strDate =
                                        new DateFormat.yMMMMd('th_TH')
                                            .format(selectedDate);

                                    setState(() {
                                      ctrlReportDateStart.text = strDate;
                                      reportDateStart = selectedDate;
                                    });

                                    getOrderItems();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 60,
                          child: TextFormField(
                            readOnly: true,
                            controller: ctrlReportDateEnd,
                            decoration: InputDecoration(
                              labelText: 'ถึง วันที่',
                              hintText: 'dd/mm/yyyy',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 30)),
                                      lastDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          child: child,
                                          data: ThemeData.light().copyWith(
                                              primaryColor:
                                                  ThemeColors.kPrimaryColor,
                                              buttonTheme: ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary,
                                              ),
                                              colorScheme: ColorScheme.light(
                                                primary:
                                                    ThemeColors.kPrimaryColor,
                                              ).copyWith(
                                                  secondary:
                                                      ThemeColors.kAccentColor)),
                                        );
                                      });
                                  if (selectedDate != null) {
                                    String strDate =
                                        new DateFormat.yMMMMd('th_TH')
                                            .format(selectedDate);

                                    setState(() {
                                      ctrlReportDateEnd.text = strDate;
                                      reportDateEnd = selectedDate;
                                    });

                                    getOrderItems();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CarouselSlider(
          items: [
            ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeColors.kPrimaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'รวมเป็นเงิน',
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
                              'จำนวน',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Card(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('โต๊ะ')),
                              DataColumn(label: Text('รายรับ'), numeric: true)
                            ],
                            rows: results.map((item) {
                              return DataRow(cells: [
                                DataCell(Text('${item['tableName']}')),
                                DataCell(Text(
                                    '${helper.formatNumber(item['total'], 0)}')),
                              ]);
                            }).toList(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: DChartBar(
                                  showBarValue: true,
                                  data: [
                                    {
                                      'id': 'Bar',
                                      'data': results.map((e) {
                                        return {
                                          'domain': e['tableName'],
                                          'measure': e['total']
                                        };
                                      }).toList()
                                    }
                                  ],
                                  barColor: (lineData, index, id) =>
                                      Colors.amber,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeColors.kPrimaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'รายการอาหารทั้งหมด',
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
                              'จำนวน',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('รายการอาหาร')),
                              DataColumn(label: Text('จำนวน'), numeric: true)
                            ],
                            rows: products.map((item) {
                              return DataRow(cells: [
                                DataCell(Text('${item['productName']}')),
                                DataCell(Text(
                                    '${helper.formatNumber(item['total'], 0)}')),
                              ]);
                            }).toList(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: DChartBar(
                                  showBarValue: true,
                                  data: [
                                    {
                                      'id': 'Bar',
                                      'data': products.map((e) {
                                        return {
                                          'domain': e['productName'],
                                          'measure': e['total']
                                        };
                                      }).toList()
                                    }
                                  ],
                                  barColor: (lineData, index, id) =>
                                      Colors.amber,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            height: 500,
            aspectRatio: 16/9,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: pages.map((item) {
        //     int index = pages.indexOf(item);
        //     return Container(
        //       width: 10.0,
        //       height: 10.0,
        //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: _currentIndex == index
        //             ? Color.fromRGBO(0, 0, 0, 0.8)
        //             : Color.fromRGBO(0, 0, 0, 0.3),
        //       ),
        //     );
        //   }).toList(),
        // )
      ],
    ));
  }
}
