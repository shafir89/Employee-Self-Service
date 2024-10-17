import 'dart:async';

import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  

@override
  Widget build(BuildContext context) {
Future.delayed(
  Duration(seconds: 2),(()=>Get.toNamed(Routes.LOGIN))
);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Splash Screen',style: TextStyle(fontSize: 16),),
        )
      ),
    );
  }
}




// import 'dart:async';
// import 'package:ems/app/modules/login/views/login_view.dart';
// import 'package:flutter/material.dart';

// class SplashView extends StatefulWidget {
//   @override 
//   State<SplashView> createState() => _SplashViewState(); //membuat state yang terkait dengan SplashView yang berisi _SplashViewState 
// }

// class _SplashViewState extends State<SplashView> { 
//   delayScreen() {  
//     Timer( // widget untuk menjalankan kode setelah 3 detik 
//       const Duration(seconds: 3), //mengatur durasi 
//       () {
//         Navigator.pushAndRemoveUntil( //setelah itu akan pindah ke halaman lain 
//           context, //untuk mengetahui di mana posisi widget dalam widget tree
//           MaterialPageRoute(builder: (context) => LoginView()), //membuat rute baru untuk halaman tujuan
//           // MaterialPageRoute(builder: (context) => Musik()), //membuat rute baru untuk halaman tujuan
//           (Route route) => false, //memberitau kapan berhenti menghapus halaman dari stack, false akan menghapus semua halaman kecuali halaman tujuan
//         );
//       },
//     );
//   }

//   @override //informasi tambahan bahwa metode dan properti yang ditulis akan diubah
//   void initState() {
//     super.initState();
//     delayScreen(); 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Text('Splash Screen',style: TextStyle(fontSize: 16),),
//         )
//       ),
//     );
//   }
// }
