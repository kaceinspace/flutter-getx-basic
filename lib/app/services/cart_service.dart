import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class CartService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  Future<Response> getCart() {
    return get(BaseUrl.cart, headers: ApiHelper.getAuthHeaders());
  }

  Future<Response> addToCart(int bookId, {int quantity = 1}) {
    return post('${BaseUrl.cartAdd}/$bookId', {
      'quantity': quantity,
    }, headers: ApiHelper.getAuthHeaders());
  }

  Future<Response> deleteFromCart(int id) {
    return delete(
      '${BaseUrl.cartDelete}/$id',
      headers: ApiHelper.getAuthHeaders(),
    );
  }

  Future<Response> borrowFromCart() {
    return post(BaseUrl.borrow, {}, headers: ApiHelper.getAuthHeaders());
  }
}
