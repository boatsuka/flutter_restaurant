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

  Helper helper = Helper();
  DateTime reportDate;
  double totalPrice = 0;
  List<Map> results = [];

  final dbRef = FirebaseFirestore.instance;

  Future getOrderItems() async {
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

      double _totalPrice = 0;
      List<Map> _results = [];

      qsTable.docs.forEach((tDocument) {
        Map table = new Map();
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
        totalPrice = _totalPrice;
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
          child: Text(
            'สรุปรายได้ประจำวัน',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
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
                      firstDate: DateTime.now().subtract(Duration(days: 30)),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          child: child,
                          data: ThemeData.light().copyWith(
                              primaryColor: ThemeColors.kPrimaryColor,
                              accentColor: ThemeColors.kAccentColor,
                              colorScheme: ColorScheme.light(
                                primary: ThemeColors.kPrimaryColor,
                              ),
                              buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              )),
                        );
                      });
                  if (selectedDate != null) {
                    String strDate =
                        new DateFormat.yMMMMd('th_TH').format(selectedDate);

                    setState(() {
                      ctrlReportDate.text = strDate;
                      reportDate = selectedDate;
                    });

                    getOrderItems();
                  }
                },
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ThemeColors.kPrimaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'บาท',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        DataTable(
            columns: [
              DataColumn(label: Text('โต๊ะ')),
              DataColumn(label: Text('รายรับ'), numeric: true)
            ],
            rows: results.map((item) {
              return DataRow(cells: [
                DataCell(Text('${item['tableName']}')),
                DataCell(Text('${helper.formatNumber(item['total'], 0)}')),
              ]);
            }).toList())
      ],
    ));
  }
}
