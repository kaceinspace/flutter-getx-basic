import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../data/models/post.dart';
import '../middlewares/auth_middleware.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/book/bindings/book_binding.dart';
import '../modules/book/views/book_view.dart';
import '../modules/book_detail/bindings/book_detail_binding.dart';
import '../modules/book_detail/views/book_detail_view.dart';
import '../modules/borrow_history/bindings/borrow_history_binding.dart';
import '../modules/borrow_history/views/borrow_history_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/content/bindings/content_binding.dart';
import '../modules/content/views/content_view.dart';
import '../modules/counter/bindings/counter_binding.dart';
import '../modules/counter/views/counter_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';

import '../modules/latest_book/bindings/latest_book_binding.dart';
import '../modules/latest_book/views/latest_book_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/post_create_view.dart';
import '../modules/post/views/post_edit_view.dart';
import '../modules/post/views/post_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_edit/bindings/profile_edit_binding.dart';
import '../modules/profile_edit/views/profile_edit_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// import '../modules/auth/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
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
    // GetPage(
    //   name: _Paths.REGISTER,
    //   page: () => RegisterView(),
    //   binding: AuthBinding(),
    // ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BOOK,
      page: () => const BookView(),
      binding: BookBinding(),
    ),
    GetPage(
      name: _Paths.LATEST_BOOK,
      page: () => LatestBookView(),
      binding: LatestBookBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_DETAIL,
      page: () => const BookDetailView(),
      binding: BookDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.BORROW_HISTORY,
      page: () => const BorrowHistoryView(),
      binding: BorrowHistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CONTENT,
      page: () => const ContentView(),
      binding: ContentBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_EDIT,
      page: () => const ProfileEditView(),
      binding: ProfileEditBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
