import 'package:ems/app/data/kanban_provider.dart';
import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/modules/format_price.dart';
import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:ems/app/modules/proyek/model_proyek.dart';
import 'package:ems/app/modules/proyek/views/detail_proyek.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

import '../controllers/proyek_controller.dart';

class ProyekView extends GetView<ProyekController> {
  ProyekView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<ProyekController>(ProyekController());
    // List<ProyekModel> proyekList = controller.proyekList;

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.blue,
          title: const Text(
            'Seluruh Proyek',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                letterSpacing: 1,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.getProyek();
          },
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.proyekList.isEmpty) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(child: Text('Belum ada data proyek')),
                );
              }

              return ListView.builder(
                itemCount: controller.proyekList.length,
                itemBuilder: (context, index) {
                  final proyek = controller.proyekList[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 10, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        // detailProyek(context);
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    padding: EdgeInsets.only(left: 12, top: 10),
                                    child: Text(
                                      proyek.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.green,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      proyek.status,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey[350],
                            ),
                            ListTile(
                              // title: Text(
                              //   proyek.name,
                              //   style: const TextStyle(
                              //       fontSize: 19, fontWeight: FontWeight.w500),
                              // ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proyek.description,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       // ('Harga: ${formatHarga(double.tryParse(proyek.price)!)}'),
                                  //       ('Harga: '),
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         color: Colors.grey[700],
                                  //         // color: Colors.black,
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.end,
                                  //         children: [
                                  //           Text(
                                  //             '${formatHarga(double.tryParse(proyek.price)!)}',
                                  //             style: TextStyle(
                                  //               fontSize: 16,
                                  //               color: Colors.grey[700],
                                  //               // color: Colors.black,
                                  //             ),
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Text(
                                        // ('Harga: ${formatHarga(double.tryParse(proyek.price)!)}'),
                                        ('Tenggat: '),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                          // color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              proyek.end_date == null
                                                  ? ''
                                                  : '${DateFormat('dd MMMM yyyy').format(proyek.end_date)}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Team: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              proyek.assignedProjects
                                                  .map((assignedProject) =>
                                                      assignedProject
                                                          .employeeName)
                                                  .join(
                                                      ', '), // Join names with comma
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        print('next');
                                        SpUtil.putInt('idKanban', proyek.id);
                                        SpUtil.putString(
                                            'namaProyek', proyek.name);
                                        // await KanbanController()
                                        // .getKomentar(proyek.id);
                                        await KanbanController().getKanban(proyek.id);
  await KanbanController().getKomentar(proyek.id);
                                      },
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Kanban',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 24, 79, 235),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
