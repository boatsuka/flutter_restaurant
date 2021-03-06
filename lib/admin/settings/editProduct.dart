import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/admin/settings/searchCategory.dart';
import 'package:flutter_restaurant/theme.dart';
import 'package:image_picker/image_picker.dart';

class AdminSettingEditProduct extends StatefulWidget {
  final DocumentSnapshot document;

  AdminSettingEditProduct({@required this.document});

  @override
  _AdminSettingEditProductState createState() =>
      _AdminSettingEditProductState();
}

class _AdminSettingEditProductState extends State<AdminSettingEditProduct> {
  XFile image;
  String imageUrl;
  String categoryId;
  String categoryName;
  bool isPromotion = false;
  ImagePicker picker = ImagePicker();
  final dbRef = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final formKey = GlobalKey<FormState>();
  TextEditingController ctrlProductName = new TextEditingController();
  TextEditingController ctrlPrice = new TextEditingController();

  Future _getImage() async {
    XFile _image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = _image;
    });
  }

  Future updatePictureToStorage(String url) async {
    await storage
        .ref()
        .child(url)
        .delete()
        .then((value) => print('ลบไฟล์แล้ว'));

    Uint8List bytes = await image.readAsBytes();

    Reference ref = storage
        .ref()
        .child('product/${DateTime.now().millisecondsSinceEpoch}.png');
    UploadTask uploadTask =
        ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    TaskSnapshot taskSnapshot = await uploadTask
        .whenComplete(() => print('done'))
        .catchError((error) => throw Exception('Error'));
    String _url = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      imageUrl = _url;
    });
  }

  Future getCategory(String categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds = await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('categories')
          .doc(categoryId)
          .get();

      setState(() {
        categoryName = ds.data()['categoryName'];
      });
    } catch (error) {
      print(error);
    }
  }

  Future saveProduct() async {
    try {
      String _productName = ctrlProductName.text;
      double _price = double.tryParse(ctrlPrice.text) ?? 0;
      String _imageUrl = imageUrl;
      String _categoryId = categoryId;
      bool _isPromotion = isPromotion;

      await dbRef
          .collection('restaurantDB')
          .doc('s1KEI8hv3vt9UveKERtJ')
          .collection('products')
          .doc(widget.document.id)
          .update({
        "categoryId": _categoryId,
        "imageUrl": _imageUrl,
        "isPromotion": _isPromotion,
        "price": _price,
        "productName": _productName,
      });

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  void setData() {
    setState(() {
      ctrlProductName.text = widget.document['productName'];
      ctrlPrice.text = widget.document['price'].toString();
      imageUrl = widget.document['imageUrl'];
      isPromotion = widget.document['isPromotion'];
      categoryId = widget.document['categoryId'];
    });

    getCategory(categoryId);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสินค้า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imageUrl == null || image != null
                    ? CachedNetworkImage(
                        height: 200,
                        fit: BoxFit.fill,
                        imageUrl: image.path,
                      )
                    : CachedNetworkImage(
                        height: 200,
                        fit: BoxFit.fill,
                        imageUrl:
                            '${imageUrl ?? 'https://www.activaschile.cl/images/NotData.png'}',
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    tooltip: 'เพิ่มรูปภาพ',
                    child: Icon(Icons.camera),
                    onPressed: () {
                      _getImage();
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ctrlProductName,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.edit,
                    color: ThemeColors.kPrimaryColor,
                  ),
                  labelText: 'ชื่อสินค้า',
                  helperText: 'ระบุชื่อสินค้า',
                  labelStyle: TextStyle(color: ThemeColors.kPrimaryColor),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุชื่อสินค้า';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ctrlPrice,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: ThemeColors.kPrimaryColor,
                  ),
                  labelText: 'ราคา',
                  helperText: 'ระบุราคาสินค้า',
                  labelStyle: TextStyle(color: ThemeColors.kPrimaryColor),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุราคาสินค้า';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('${categoryName ?? 'กรุณาเลือก'}'),
                subtitle: Text('หมวดหมู่สินค้า'),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  DocumentSnapshot category = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AdminSettingSearchCategory(),
                        fullscreenDialog: true),
                  );

                  if (category != null) {
                    setState(() {
                      categoryName = category['categoryName'];
                      categoryId = category.id;
                    });
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                value: isPromotion,
                title: Text('สินค้าโปรโมชั่น'),
                onChanged: (value) {
                  setState(() {
                    isPromotion = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    if (categoryId != null) {
                      if (image != null) {
                        await updatePictureToStorage(imageUrl);
                      }
                      await saveProduct();
                    } else {
                      print('ข้อมูลไม่ครบถ้วน');
                    }
                  }
                },
                icon: Icon(Icons.save),
                label: Text('บันทึกข้อมูล'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    primary: ThemeColors.kPrimaryColor,
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(150, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
