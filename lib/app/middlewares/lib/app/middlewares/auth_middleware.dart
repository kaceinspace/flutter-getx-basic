import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final token = box.read('token');
    if (token == null && route != '/auth/login' && route != '/auth/register') {
      return const RouteSettings(name: '/auth/login');
    }
    return null;
  }
}
