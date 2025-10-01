import 'package:get/get.dart';
import 'package:rpl1getx/app/utils/api.dart';
import 'package:rpl1getx/app/utils/api_helper.dart';

class DashboardService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> fetchLatestBooks() async {
    try {
      return await get(
        BaseUrl.latestBooks,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Network Error: ${e.toString()}',
      );
    }
  }
}
