  import 'package:ems/app/data/notifikasi_provider.dart';
  import 'package:ems/app/modules/notifikasi/model_notif.dart';
  import 'package:get/get.dart';

  class NotifikasiController extends GetxController {
    var notifList = <NotifModel>[].obs;
    var isLoading = false.obs;
    var notif = Rx<NotifModel?>(null);

    void setNotif(NotifModel? emp) {
      notif.value = emp;
    }

    NotifModel? ambilNotif() {
      return notif.value;
    }

    @override
    void onInit() {
      getNotif();
      super.onInit();
    }

    void getNotif() async {
      try {
        isLoading(true);
        var fetchedNotif = await NotifikasiProvider().fetchNotif();
        
        notifList.assignAll(fetchedNotif);
      } finally {
        isLoading(false);
      }
    }
  }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ems/app/data/notifikasi_provider.dart';
// import 'package:ems/app/modules/notifikasi/model_notif.dart';

// class NotifikasiController extends GetxController {
//   var notifList = <NotifModel>[].obs;
//   var isLoading = false.obs;
//   var notif = Rx<NotifModel?>(null);
//   var lastNotifCount = 0.obs; // Menyimpan jumlah notifikasi terakhir

//   void setNotif(NotifModel? notifItem) {
//     notif.value = notifItem;
//   }

//   NotifModel? ambilNotif() {
//     return notif.value;
//   }

//   @override
//   void onInit() {
//     getNotif();
    
//     // Polling setiap 30 detik untuk mengecek notifikasi baru
//     ever(notifList, (_) {
//       checkNewNotification();
//     });
    
//     super.onInit();
//   }

//   Future<void> getNotif() async {
//     try {
//       isLoading(true);
//       var fetchedNotif = await NotifikasiProvider().fetchNotif();
      
//       if (fetchedNotif.length > lastNotifCount.value) {
//         // Ada notifikasi baru
//         var newNotifCount = fetchedNotif.length - lastNotifCount.value;
        
//         // Tampilkan notifikasi untuk notifikasi baru
//         for (int i = 0; i < newNotifCount; i++) {
//           Get.snackbar(
//             'Notifikasi Baru', 
//             fetchedNotif[i].message,
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         }
//       }

//       // Update jumlah notifikasi terakhir
//       lastNotifCount.value = fetchedNotif.length;

//       notifList.assignAll(fetchedNotif);
//     } finally {
//       isLoading(false);
//     }
//   }

//   void checkNewNotification() {
//     getNotif();
//   }
// }
