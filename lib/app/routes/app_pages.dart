import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/post.dart';
import 'package:rpl1getx/app/middlewares/auth_middleware.dart';
import 'package:rpl1getx/app/modules/post/views/post_create_view.dart';
import 'package:rpl1getx/app/modules/post/views/post_edit_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/counter/bindings/counter_binding.dart';
import '../modules/counter/views/counter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/post_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.COUNTER,
      page: () => CounterView(),
      binding: CounterBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.POST,
      page: () => PostView(),
      binding: PostBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CREATE_POST,
      page: () => CreatePostView(),
      binding: PostBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.EDIT_POST,
      page: () {
        final post = Get.arguments as DataPost?;
        if (post == null) {
          Get.offNamed(Routes.POST);
          return Container();
        }
        return EditPostView(post: post);
      },
      binding: PostBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
