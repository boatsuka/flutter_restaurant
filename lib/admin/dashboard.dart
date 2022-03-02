import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_chart/d_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:week_of_year/week_of_year.dart';
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
  List<Map<String, dynamic>> weeklyPay = [];
  List<Map<String, dynamic>> weeklyProduct = [];
  List<Map<String, dynamic>> monthPay = [];
  List<Map<String, dynamic>> monthProduct = [];
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

      int weekDate = new DateTime(
        reportDate.year,
        reportDate.month,
        reportDate.day,
        0,
        0,
        0,
      ).weekOfYear;

      int monthDateStart = new DateTime(
        reportDate.year,
        reportDate.month,
      ).month;

      // int monthDateEnd = new DateTime(
      //   reportDate.year,
      //   reportDate.month - 6,
      // ).month;

      QuerySnapshot qsOrder = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('orders')
          .get();

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

      // weeeky
      QuerySnapshot pw = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderWeek', isEqualTo: weekDate)
          .orderBy('orderDay', descending: true)
          .get();

      // month
      QuerySnapshot pm = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('order-items')
          .where('itemStatus', isEqualTo: 'SERVED')
          .where('orderMonth', isLessThanOrEqualTo: monthDateStart)
          .get();

      double _totalPrice = 0;
      double _totalProduct = 0;
      double _totalPriceY = 0;
      double _totalProductY = 0;
      double _totalPriceW = 0;
      double _totalProductW = 0;

      List<Map<String, dynamic>> _results = [];
      List<Map<String, dynamic>> _products = [];
      List<Map<String, dynamic>> _weeklyPay = [];
      List<Map<String, dynamic>> _weeklyProduct = [];
      List<Map<String, dynamic>> _monthPay = [];
      List<Map<String, dynamic>> _monthProduct = [];

      qsOrder.docs.forEach((e) {
        Map<String, dynamic> weekly = new Map();
        double _weekPayment = 0;
        double _weekDay = 0;
        String _weekDetail = "";

        pw.docs.forEach((i) {
          Map<String, dynamic> data = i.data();
          if (e['orderWeek'] == i['orderWeek']) {
            if (e['orderDay'] == i['orderDay']) {
              double qtyPrice = i['price'] * i['qty'];
              if (data.containsKey('options')) {
              double optionsPrice =
                  i['options']['price'] * i['qty'];
              qtyPrice += optionsPrice;
            }

              _weekPayment += qtyPrice;
              _weekDay = i['orderDay'];
              _weekDetail = "วันที่ $_weekDay";
            }
          }

          weekly['day'] = _weekDetail;
          weekly['total'] = _weekPayment;
        });

        print(weekly);

        _weeklyPay.add(weekly);
      });

      //
      qsOrder.docs.forEach((e) {
        Map<String, dynamic> weeklyProduct = new Map();
        double _qtyProducts = 0;
        double _weeklyProducts = 0;
        String _weeklyDetail = "";

        pw.docs.forEach((i) {
          if (i['orderWeek'] == e['orderWeek']) {
            if (i['orderDay'] == e['orderDay']) {
              double qtyProduct = i['qty'];

              _qtyProducts += qtyProduct;
              _weeklyProducts = i['orderDay'];
              _weeklyDetail = "วันที่ $_weeklyProducts";
            }
          }

          weeklyProduct['day'] = _weeklyDetail;
          weeklyProduct['total'] = _qtyProducts;
        });

        _weeklyProduct.add(weeklyProduct);
      });

      qsOrder.docs.forEach((e) {
        Map<String, dynamic> product = new Map();
        double _monthPayment = 0;
        String _monthDetail = "";
        double totalPricetableMonth = 0;

        pm.docs.forEach((document) {
          Map<String, dynamic> data = document.data();
          if (document['orderMonth'] == e['orderMonth']) {
            double qtyPrice = document['qty'] * document['price'];
            if (data.containsKey('options')) {
              double optionsPrice =
                  document['options']['price'] * document['qty'];
              qtyPrice += optionsPrice;
            }

            totalPricetableMonth += qtyPrice;

            _monthPayment = document['orderMonth'];
            _monthDetail = "เดือนที่ $_monthPayment";
          }

          product['month'] = _monthDetail;
          product['total'] = totalPricetableMonth;
        });

        _monthPay.add(product);
      });

      qsOrder.docs.forEach((e) {
        Map<String, dynamic> product = new Map();
        double _qtyProducts = 0;
        double _monthProducts = 0;
        String _monthDetail = "";

        pm.docs.forEach((item) {
          if (item['orderMonth'] == e['orderMonth']) {
            double qtyProduct = item['qty'];

            _qtyProducts += qtyProduct;
            _monthProducts = item['orderMonth'];
            _monthDetail = "เดือนที่ $_monthProducts";
          }

          product['month'] = _monthDetail;
          product['total'] = _qtyProducts;
        });

        _monthProduct.add(product);
      });

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
        double _totalPricetable = 0;
        double _totalPricetableY = 0;

        qs.docs.forEach((document) {
          Map<String, dynamic> data = document.data();

          if (document['tableId'] == tDocument.id) {
            double qtyPrice = document['qty'] * document['price'];
            if (data.containsKey('options')) {
              double optionsPrice =
                  document['options']['price'] * document['qty'];
              qtyPrice += optionsPrice;
            }

            _totalPricetable += qtyPrice;

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

            _totalPricetableY += qtyPrice;

            _totalPriceY += qtyPrice;
          }
        });

        table['total'] = _totalPricetable;
        table['totalY'] = _totalPricetableY;
        table['balance'] = _totalPrice - _totalPriceY;
        table['tableName'] = tDocument['tableName'];
        _results.add(table);
      });

      setState(() {
        results = _results;
        products = _products;
        weeklyPay = _weeklyPay;
        weeklyProduct = _weeklyProduct;
        monthPay = _monthPay;
        monthProduct = _monthProduct;
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
                                '${helper.formatNumber(totalPriceY, 0)}',
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
                                'ส่วนต่าง',
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
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: 1000,
                          height: 200,
                          child: Card(
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
                                  yAxisTitle: "จำนวนเงิน / บาท",
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
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: 1000,
                          height: 200,
                          child: Card(
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: DChartBar(
                                  showBarValue: true,
                                  data: [
                                    {
                                      'id': 'Bar1',
                                      'data': weeklyPay.map((e) {
                                        return {
                                          'domain': e['day'],
                                          'measure': e['total']
                                        };
                                      }).toList()
                                    },
                                  ],
                                  yAxisTitle: "จำนวนเงิน / บาท",
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
                    ),
                  ],
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 1300,
                      height: 500,
                      child: Card(
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: DChartBar(
                              showBarValue: true,
                              data: [
                                {
                                  'id': 'Bar1',
                                  'data': monthPay.map((e) {
                                    return {
                                      'domain': e['month'],
                                      'measure': e['total']
                                    };
                                  }).toList()
                                },
                              ],
                              yAxisTitle: "จำนวนเงิน / บาท",
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
                ),
              ],
            )),
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
                                  'ส่วนต่าง',
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
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 1000,
                            height: 200,
                            child: Card(
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
                                    yAxisTitle: "จำนวนเงิน / บาท",
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
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 1000,
                            height: 200,
                            child: Card(
                              child: Container(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: DChartBar(
                                    showBarValue: true,
                                    data: [
                                      {
                                        'id': 'Bar1',
                                        'data': weeklyProduct.map((e) {
                                          return {
                                            'domain': e['day'],
                                            'measure': e['total']
                                          };
                                        }).toList()
                                      },
                                    ],
                                    yAxisTitle: "จำนวนเงิน / บาท",
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
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: 1300,
                        height: 500,
                        child: Card(
                          child: Container(
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DChartBar(
                                showBarValue: true,
                                data: [
                                  {
                                    'id': 'Bar1',
                                    'data': monthProduct.map((e) {
                                      return {
                                        'domain': e['month'],
                                        'measure': e['total']
                                      };
                                    }).toList()
                                  },
                                ],
                                yAxisTitle: "จำนวนเงิน / บาท",
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
