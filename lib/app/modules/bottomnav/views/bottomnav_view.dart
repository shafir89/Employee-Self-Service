// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_util/sp_util.dart';
// import '../controllers/bottomnav_controller.dart';

// class BottomnavView extends GetView<BottomnavController> {
//   const BottomnavView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     var totalNotif = SpUtil.getString('totalNotif');
//     print(totalNotif);
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 24, 79, 235),
//       body: Obx(() {
//         return controller.currentPage;
//       }),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             currentIndex: controller.currentIndex.value,
//             onTap: controller.handleNavigationChange,
//             // backgroundColor: const Color.fromARGB(255, 24, 79, 235),
//             selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
//             unselectedItemColor: const Color.fromARGB(153, 0, 0, 0),
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home, size: 25.5),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.assignment_ind_rounded, size: 25.5),
//                 label: "Absensi",
//               ),
//                 BottomNavigationBarItem(
//                 icon: Icon(Icons.fingerprint, size: 25.5),
//                 label: "fingerprint",
//               ),
//               BottomNavigationBarItem(
//                 icon: Stack(
//                   children: <Widget>[
//                     Icon(
//                       Icons.notifications,
//                       size: 25.5,
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: Container(
//                         padding: EdgeInsets.only(top: 1, right: 1, left: 1),
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 60, 107, 238),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         constraints: BoxConstraints(
//                           minWidth: 12,
//                           minHeight: 12,
//                         ),
//                         child: Text(
//                           totalNotif!,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 label: "Notifikasi",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.assignment,
//                   size: 25.5,
//                 ),
//                 label: "Proyek",
//               ),
//             ],
//           )),

//     );
//   }
// }

import 'package:ems/app/modules/maps/views/maps_view.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../controllers/bottomnav_controller.dart';

class BottomnavView extends GetView<BottomnavController> {
  const BottomnavView({super.key});

  @override
  Widget build(BuildContext context) {
    var totalNotif =
        SpUtil.getString('totalNotif') ?? '0'; // Default to '0' if null
    final iconList = [
      Icons.home,
      Icons.assignment_ind_rounded,
      Icons.notifications, // Use regular IconData here
      Icons.assignment,
    ]; // Icons list for the AnimatedBottomNavigationBar

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Obx(() {
        return controller
            .currentPage; // Display the current page based on the controller's state
      }),

      // Floating Action Button with fingerprint icon in the center
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Get.toNamed(Routes.MAPS);
        },
        child: const Icon(
          Icons.fingerprint,
          color: Colors.white,
        ), // Icon fingerprint in the FAB
        backgroundColor: const Color.fromARGB(255, 24, 79, 235),
      ),

      // Position FAB in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Animated Bottom Navigation Bar
      bottomNavigationBar: Stack(
        children: [
          // The Bottom Navigation Bar itself
          Obx(() => AnimatedBottomNavigationBar(
                icons: iconList, // List of icons
                activeIndex:
                    controller.currentIndex.value, // Current active index
                gapLocation: GapLocation.center, // Gap location for the FAB
                notchSmoothness:
                    NotchSmoothness.softEdge, // Smooth edge for notch
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                onTap: (index) {
                  controller
                      .handleNavigationChange(index); // Handle navigation tap
                },
                activeColor: const Color.fromARGB(255, 24, 79, 235),
                inactiveColor: Colors.grey,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              )),

          // Notification badge positioned over the third icon (notifications)
          Positioned(
            bottom: 30, // Adjust position as needed
            left: MediaQuery.of(context).size.width * 0.5 +
                75, // Position over the third icon
            child: totalNotif != '0'
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 60, 107, 238),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      totalNotif,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox(), // Hide badge if there are no notifications
          ),
        ],
      ),
    );
  }
}
