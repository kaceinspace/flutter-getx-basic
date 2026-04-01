import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class DashboardService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  Future<Response> getHome() {
    return get(BaseUrl.home, headers: BaseUrl.defaultHeaders);
  }

  Future<Response> getCategories() {
    return get(BaseUrl.categories, headers: BaseUrl.defaultHeaders);
  }

  Future<Response> getBorrowHistory() {
    return get(BaseUrl.borrowHistory, headers: ApiHelper.getAuthHeaders());
  }
}
