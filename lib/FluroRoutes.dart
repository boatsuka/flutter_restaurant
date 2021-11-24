import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/OrderRequestSplash.dart';
import 'package:flutter_restaurant/admin/home.dart';
import 'package:flutter_restaurant/admin/settings/addProduct.dart';
import 'package:flutter_restaurant/admin/settings/category.dart';
import 'package:flutter_restaurant/admin/settings/company.dart';
import 'package:flutter_restaurant/admin/settings/product.dart';
import 'package:flutter_restaurant/admin/settings/table.dart';
import 'package:flutter_restaurant/home.dart';
import 'package:flutter_restaurant/notFound.dart';

class FloruRoutes {
  static final FluroRouter router = FluroRouter();

  static Handler adminHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminHomePage();
  });

  static Handler requestHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return OrderRequestSplashPage(
      companyId: params['companyId'][0],
      orderId: params['orderId'][0],
    );
  });

  static Handler defaultHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return HomePage();
  });

  static Handler adminSettingProductsHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminSettingProducts();
  });

  static Handler adminSettingAddProductHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminSettingAddProduct();
  });

  static Handler adminSettingCategoryHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminSettingCategory();
  });

  static Handler adminSettingTableHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminSettingTable();
  });

  static Handler adminSettingCompanyHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return AdminSettingCompany();
  });

  static Handler notFoundHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return NotFoundPage();
  });

  static void defineRoutes() {
    router.define('/', handler: defaultHandler);
    router.define('/admin', handler: adminHandler);
    router.define('/admin/products', handler: adminSettingProductsHandler);
    router.define('/admin/add/product', handler: adminSettingAddProductHandler);
    router.define('/admin/categories', handler: adminSettingCategoryHandler);
    router.define('/admin/tables', handler: adminSettingTableHandler);
    router.define('/admin/company', handler: adminSettingCompanyHandler);
    router.define('/not-found', handler: notFoundHandler);
    router.define('/request/:companyId/:orderId', handler: requestHandler);
  }
}
