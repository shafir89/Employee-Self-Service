import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 50),
                Text(
                  'Modernize',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Text(
                  'Masuk untuk melanjutkan',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Form(
                  key: controller.form,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 290,
                        child: TextFormField(
                          controller: controller.txtEmail,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 167, 158, 162)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email harus diisi';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 290,
                        child: Obx(
                          () => TextFormField(
                            obscureText: controller.isObscure.value,
                            controller: controller.txtPassword,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6),
                              suffixIcon: IconButton(
                                icon: Icon(controller.isObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: controller.toggleObscure,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password harus diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 54,
                        width: 290,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.loading.value
                                ? null
                                : controller.auth,
                            child: controller.loading.value
                                ? SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white,))
                                : Text(
                                    'Masuk',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                        fontSize: 20),),
            

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 84, 156, 254),
                              fixedSize: Size(Get.width - 70, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                          ),
                        ),
                        // child: ElevatedButton(
                        //     onPressed: () {
                        //       Get.offAllNamed(Routes.BOTTOMNAV);
                        //     },
                        //     child: Text('masuk')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
