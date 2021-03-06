import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isError = false;
  final dbRef = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  Future getCompanyInfo(String uid) async {
    try {
      QuerySnapshot snapshot = await dbRef
          .collection('restaurantDB')
          .doc('companies')
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      DocumentSnapshot document = snapshot.docs[0];
      String companyId = document['companyId'];
      print(companyId);

      setState(() {
        isError = false;
      });

      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   "/admin",
      //   (r) => true,
      // );

      Future.delayed(Duration.zero, () {
       Navigator.of(context).pushNamedAndRemoveUntil(
            '/admin', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  Future signIn() async {
    String email = ctrlEmail.text;
    String password = ctrlPassword.text;

    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult == null) {
        setState(() {
          isError = true;
        });
      } else {
        String uid = authResult.user.uid;

        getCompanyInfo(uid);
      }
    } catch (error) {
      setState(() {
        isError = true;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vpn_key,
                    size: 80,
                  ),
                  Text(
                    '??????????????????????????????????????????????????????',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[100],
                    ),
                  ),
                  TextFormField(
                    controller: ctrlEmail,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '??????????????????',
                      helperText: '??????????????????????????????????????????????????????????????????',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '??????????????????????????????';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ctrlPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '????????????????????????',
                      helperText: '???????????????????????????????????????????????????????????????????????????',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '????????????????????????????????????';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isError
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '?????????????????????????????????????????????????????????????????????????????????????????????????????????',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.lock_open),
                            label: Text('?????????????????????????????????'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(50, 50),
                              primary: ThemeColors.kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                signIn();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
