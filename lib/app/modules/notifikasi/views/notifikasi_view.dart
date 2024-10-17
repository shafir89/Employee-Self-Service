import 'package:ems/app/data/notifikasi_provider.dart';
import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});
  @override
  Widget build(BuildContext context) {
    NotifikasiController controller = Get.put(NotifikasiController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Tandai telah dibaca(${SpUtil.getString('totalNotif')})',
                style: TextStyle(color: Colors.blue),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10), backgroundColor: Colors.white,shadowColor: Colors.transparent),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getNotif();
        },
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.notifList.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(child: Text('Belum ada notifikasi')),
              );
            }

            return ListView.builder(
                itemCount: controller.notifList.length,
                itemBuilder: (context, index) {
                  final notif = controller.notifList[index];

                  Color cardColor;
                  Color textColor;

                  switch (notif.type) {
                    case 'success':
                      cardColor = Colors.green;

                      break;
                    case 'info':
                      cardColor = Colors.yellow;

                      break;
                    case 'danger':
                      cardColor = Colors.red;

                      break;

                    default:
                      cardColor = Colors.white;
                  }
                  if (notif.readAt.isNotEmpty) {
                    textColor = Colors.grey[700]!;
                  } else {
                    textColor = Colors.black;
                  }

                  return notif.type == 'info'?GestureDetector(
                    onTap: (){Get.toNamed(Routes.PROYEK);},
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cardColor)),

                    // color: cardColor,
                    // elevation: 3,
                    child: ListTile(
                      title: Text(
                        notif.title,
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(notif.message,
                              style: TextStyle(color: textColor)),
                          Text(
                              KanbanController()
                                  .timeAgo(DateTime.parse(notif.createdAt)),
                              style: TextStyle(color: textColor)),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            NotifikasiProvider().deleteNotif(notif.id);
                            print(notif.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ),
                  ):Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cardColor)),

                    // color: cardColor,
                    // elevation: 3,
                    child: ListTile(
                      title: Text(
                        notif.title,
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(notif.message,
                              style: TextStyle(color: textColor)),
                          Text(
                              KanbanController()
                                  .timeAgo(DateTime.parse(notif.createdAt)),
                              style: TextStyle(color: textColor)),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            NotifikasiProvider().deleteNotif(notif.id);
                            print(notif.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}


// import 'package:ems/app/modules/notifikasi/controllers/notifikasi_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NotifikasiView extends StatelessWidget {
//   final NotifikasiController controller = Get.put(NotifikasiController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifikasi'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.notifList.isEmpty) {
//           return Center(child: Text('Tidak ada notifikasi.'));
//         }

//         return ListView.builder(
//           itemCount: controller.notifList.length,
//           itemBuilder: (context, index) {
//             var notif = controller.notifList[index];
//             return ListTile(
//               title: Text(notif.title),
//               subtitle: Text(notif.message),
//               trailing: Text(notif.createdAt),
//               onTap: () {
//                 controller.setNotif(notif);
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
