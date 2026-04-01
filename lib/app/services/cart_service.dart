import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class CartService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  Future<Response> getCart() async {
    try {
      return await get(BaseUrl.cart, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> addToCart(int bookId, int quantity) async {
    try {
      return await post('${BaseUrl.cartAdd}/$bookId', {
        'quantity': quantity,
      }, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> updateCart(int cartId, int quantity) async {
    try {
      return await put('${BaseUrl.cartUpdate}/$cartId', {
        'quantity': quantity,
      }, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> deleteFromCart(int cartId) async {
    try {
      return await delete(
        '${BaseUrl.cartDelete}/$cartId',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> borrowFromCart() async {
    try {
      return await post(
        BaseUrl.borrow,
        {},
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }
}
