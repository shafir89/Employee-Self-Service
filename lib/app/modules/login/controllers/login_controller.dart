import 'package:ems/app/data/login_provider.dart';
import 'package:ems/app/modules/home/controllers/home_controller.dart';
import 'package:ems/app/modules/login/employemodel.dart';
import 'package:ems/app/modules/login/lokasi_model.dart';
import 'package:ems/app/modules/proyek/controllers/proyek_controller.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class LoginController extends GetxController {
  final form = GlobalKey<FormState>();

  var loading = false.obs;
  var isObscure = true.obs;
  var employee = Rx<EmployeeModel?>(null);
  var lokasi = Rx<OfficeLocation?>(null);

  void setEmployee(EmployeeModel? emp) {
    employee.value = emp;
  }

  EmployeeModel? getEmployee() {
    return employee.value;
  }
  void setLocation(OfficeLocation? loc) {
    lokasi.value = loc;
  }

  OfficeLocation? getLocation() {
    return lokasi.value;
  }

  late TextEditingController txtEmail;
  late TextEditingController txtPassword;

  @override
  void onInit() {
    super.onInit();
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
    ProyekController().getProyek();
    HomeController().checkAndRequestGPS();
    // HomeController().getCurrentPosition();
  }

  @override
  void onClose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.onClose();
  }

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void auth() async {
    if (form.currentState!.validate()) {
      loading.value = true;

      String email = txtEmail.text;
      String password = txtPassword.text;

      try {
        var data = {'email': email, 'password': password};

        var response = await LoginProvider().auth(data);

        if (response.statusCode == 200) {
          loading.value = false;
          Get.snackbar('Success', 'Login Berhasil',
              colorText: Colors.white, backgroundColor: Colors.green);

          var token = response.body['access_token'];
          EmployeeModel employee =
              EmployeeModel.fromJson(response.body['user']);

          if (token != null) {
            SpUtil.putString('token', token);
            Get.find<LoginController>().setEmployee(employee);
          await LoginProvider().getLocation();
            


            Get.offAllNamed(Routes.BOTTOMNAV);
          } else {
            loading.value = false;
            Get.snackbar('Error', 'Token tidak ditemukan dalam respons',
                colorText: Colors.white, backgroundColor: Colors.red);
          }
        } else if (response.statusCode == 401) {
          loading.value = false;
          Get.snackbar('Error', 'Email atau Password Salah',
              colorText: Colors.white, backgroundColor: Colors.red);
        } else {
          loading.value = false;
          Get.snackbar(
              'Error', 'Login Gagal, kode status: ${response.statusCode}',
              colorText: Colors.white, backgroundColor: Colors.red);
          print(response.bodyString);
        }
      } catch (e) {
        loading.value = false;

        Get.snackbar('Error', 'Terjadi kesalahan',
            colorText: Colors.white, backgroundColor: Colors.red);
        print(e);
      }
    }
  }
}
