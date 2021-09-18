import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isError = false;

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  Future signIn() async {
    String email = ctrlEmail.text;
    String password = ctrlPassword.text;

    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (authResult == null) {
        setState(() {
          isError = true;
        });
      } else {
        setState(() {
          isError = false;
        });
        Navigator.of(context).pushReplacementNamed('/admin');
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
                      'ระบบจัดการหลังบ้าน',
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
                        labelText: 'อีเมล์',
                        helperText: 'ระบุอีเมล์เพื่อล็อคอิน',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ระบุอีเมล์';
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
                        labelText: 'รหัสผ่าน',
                        helperText: 'ระบุรหัสผ่านสำหรับล็อคอิน',
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ระบุรหัสผ่าน';
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
                              'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
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
                              label: Text('เข้าสู่ระบบ'),
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
          )),
    );
  }
}
