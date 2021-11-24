import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminSettingCompany extends StatefulWidget {
  @override
  _AdminSettingCompanyState createState() => _AdminSettingCompanyState();
}

class _AdminSettingCompanyState extends State<AdminSettingCompany> {
  TextEditingController ctrlCompanyName = new TextEditingController();
  TextEditingController ctrlAddress = new TextEditingController();
  TextEditingController ctrlPhone = new TextEditingController();

  final dbRef = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  Future updateData() async {
    try {
      String companyName = ctrlCompanyName.text;
      String address = ctrlAddress.text;
      String phone = ctrlPhone.text;

      dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('settings')
          .doc('info')
          .update(
              {"companyName": companyName, "address": address, "phone": phone});
      print('Success');
    } catch (error) {
      print(error);
    }
  }

  Future getCompanyInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('settings')
          .doc('info')
          .get();

      if (document.data().isNotEmpty) {
        setState(() {
          ctrlCompanyName.text = document.data()['companyName'];
          ctrlAddress.text = document.data()['address'];
          ctrlPhone.text = document.data()['phone'];
        });
      } else {
        print('ไม่พบข้อมูลร้านค้า');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลร้านค้า'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: ctrlCompanyName,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุชื่อร้านค้า';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ชื่อร้านค้า',
                  helperText: 'ระบุชื่อร้านค้า',
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: ctrlAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุที่อยู่ร้านค้า';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ที่อยู่',
                  helperText: 'ระบุที่อยู่ร้านค้า',
                  prefixIcon: Icon(Icons.map),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: ctrlPhone,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุเบอร์โทร';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'เบอร์โทร',
                  helperText: 'ระบุเบอร์โทร',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  primary: ThemeColors.kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    updateData();
                  }
                },
                icon: Icon(Icons.save),
                label: Text('บันทึก'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
