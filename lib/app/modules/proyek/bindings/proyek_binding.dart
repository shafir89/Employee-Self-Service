import 'package:get/get.dart';

import '../controllers/proyek_controller.dart';

class ProyekBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProyekController>(
      () => ProyekController(),
    );
  }
}
