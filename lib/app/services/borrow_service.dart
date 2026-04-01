import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class BorrowService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  Future<Response> getBorrowHistory({int page = 1}) async {
    try {
      return await get(
        '${BaseUrl.borrowHistory}?page=$page',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }
}
