import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/admin/call.dart';
import 'package:flutter_restaurant/admin/chat.dart';
import 'package:flutter_restaurant/admin/dashboard.dart';
import 'package:flutter_restaurant/admin/order.dart';
import 'package:flutter_restaurant/admin/table.dart';
import 'package:flutter_restaurant/login.dart';
import 'package:flutter_restaurant/theme.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String email;
  int selectedIndex = 0;
  List pages = [
    AdminDashboard(),
    AdminOrderPage(),
    AdminTablePage(),
    AdminCallPage(),
    AdminChatPage()
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future checkLogin() async {
    User _user = _auth.currentUser;

    if (_user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      setState(() {
        email = _user.email;
      });
    }
  }

  Future logout() async {
    final _user = _auth.currentUser;

    if (_user != null) {
      _auth.signOut();
    }

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('จัดการหลังบ้าน')),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logout(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('ผู้ดูแลระบบร้าน'),
              accountEmail: Text('${email ?? "wongnok@application.com"}'),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.pinclipart.com/picdir/big/379-3797946_software-developer-computer-servers-web-others-web-developer.png'),
                    )),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder_open),
              title: Text('ข้อมูลสินค้า'),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              leading: Icon(Icons.group_work),
              title: Text('ข้อมูลหมวดหมู่สินค้า'),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('ข้อมูลโต๊ะ'),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('ข้อมูลร้านค้า'),
              trailing: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        selectedItemColor: ThemeColors.kPrimaryColor,
        unselectedItemColor: ThemeColors.kUnselectedItemColor,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'หน้าหลัก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'ออร์เดอร์'),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'โต๊ะ'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'ลูกค้าเรียก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'ข้อความ')
        ],
      ),
    );
  }
}
