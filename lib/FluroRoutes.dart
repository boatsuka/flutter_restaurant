import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/OrderRequestSplash.dart';
import 'package:flutter_restaurant/admin/home.dart';
import 'package:flutter_restaurant/home.dart';
import 'package:flutter_restaurant/order.dart';

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

  static void defineRoutes() {
    router.define('/', handler: defaultHandler);
    router.define('/admin', handler: adminHandler);
    router.define('/request/:companyId/:orderId', handler: requestHandler);
  }
}
