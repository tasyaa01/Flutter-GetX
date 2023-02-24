import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_project/app/data/headline_response.dart';
import 'package:mobile_project/app/utils/api.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController

  final _getConnect = GetConnect();

  Future<HeadlineResponse> getHeadline() async {
    final response = await _getConnect.get(BaseUrl().headline);
    return HeadlineResponse.fromJson(jsonDecode(response.body));
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
