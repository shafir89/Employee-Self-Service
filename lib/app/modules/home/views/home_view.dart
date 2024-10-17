import 'package:ems/app/data/absen_provider.dart';
import 'package:ems/app/data/kanban_provider.dart';
import 'package:ems/app/data/summary_provider.dart';
import 'package:ems/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/modules/format_price.dart';
import 'package:ems/app/modules/home/views/dashboard.dart';
import 'package:ems/app/modules/home/views/profile.dart';
import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:ems/app/modules/proyek/controllers/proyek_controller.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  HomeController controller = Get.put(HomeController());
  final employeeController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchSummary(); // Refresh summary data
          controller.fetchAttendances(); // Refresh attendance data
          controller.proyekController.getProyek(); // Refresh project data
          controller.filterProyek();
        },
        child: ListView(
          children: [
            Obx(
              () {
                final employee = employeeController.getEmployee();
                if (controller.summaryData.value == null) {
                  // Jika data masih null, tampilkan indikator loading
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(child: Text('Belum ada data')),
                  );

                  // return Center(child: CircularProgressIndicator());
                }

                String firstname = employee!.name.split(" ")[0];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Halo,',
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      subtitle: Text(
                        firstname,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            letterSpacing: 1),
                      ),
                      // trailing: IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(Icons.notifications),
                      //       iconSize: 30,
                      //     ),
                      // trailing: CircleAvatar(
                      //   backgroundImage: AssetImage('assets/images/avauser.png'),
                      //   radius: 22,
                      // ),
                      //               trailing: PopupMenuButton(
                      //                 onSelected: (item)=>print(item),
                      //                 child:
                      //                 CircleAvatar(
                      //                 backgroundImage: AssetImage('assets/images/avauser.png'),
                      //                 radius: 22,
                      //               ),
                      //   itemBuilder: (BuildContext context) {
                      //     return [
                      //       PopupMenuItem(value: 0,child:
                      //       Row(
                      //         children: [
                      //           Icon(Icons.person),
                      //           SizedBox(width: 5,),
                      //           Text('Lihat Profil')
                      //         ],
                      //       )),
                      //       PopupMenuItem(value: 1,child:
                      //       Row(
                      //         children: [
                      //           Icon(Icons.logout_rounded,color: Colors.red,),
                      //           SizedBox(width: 5,),
                      //           Text('Logout',style: TextStyle(color: Colors.red),)
                      //         ],
                      //       )),
                      //     ];
                      //   },
                      // )
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 24, 79, 235),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                employee.guardName,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              showCustomPopupMenu(
                                  context, details.globalPosition);
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/avauser.png'),
                              radius: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 8),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           //       Text(
                    //           //   'Halo,',
                    //           //   style:
                    //           //       TextStyle(fontSize: 17, color: Colors.grey[800]),
                    //           // ),
                    //           Text(
                    //             'Halo, ${firstname}',
                    //             style: TextStyle(
                    //                 fontSize: 25,
                    //                 fontWeight: FontWeight.normal,
                    //                 color: Colors.black,
                    //                 letterSpacing: 1),
                    //           ),
                    //         ],
                    //       ),
                    //       IconButton(
                    //         onPressed: () {
                    //           controller.getCurrentPosition();
                    //         },
                    //         icon: const Icon(Icons.notifications),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     // Text(
                          //     //       'Rekap Absensi',
                          //     //       style: TextStyle(
                          //     //           fontSize: 18,
                          //     //           fontWeight: FontWeight.w500),
                          //     //     ),

                          //   ],
                          // ),
                          //  SizedBox(
                          //           height: 10,
                          //         ),
                          // Add Staggered Grid
                          StaggeredGrid.count(
                            crossAxisCount: 4, // Total kolom dalam grid
                            mainAxisSpacing: 8, // Spasi vertikal antar tile
                            crossAxisSpacing: 8, // Spasi horizontal antar tile
                            children:
                                controller.tiles.asMap().entries.map((entry) {
                              int index = entry.key;
                              TileData tile = entry.value;

                              // Tentukan ukuran grid berdasarkan indeks atau logika lainnya
                              return StaggeredGridTile.count(
                                // Misalnya tile pertama dan terakhir ukurannya 2x2, yang lainnya 2x1
                                crossAxisCellCount:
                                    (index == 0 || index == 2) ? 2 : 2,
                                // 2,

                                mainAxisCellCount:
                                    // 1,
                                    (index == 0 || index == 2) ? 2 : 1,
                                child: DashboardTile(tile),
                              );
                            }).toList(),
                          ),

                          // SizedBox(height: 20),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       'Absensi Harian',
                          //       style: TextStyle(
                          //           fontSize: 18, fontWeight: FontWeight.w500),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 10),
                          // Obx(
                          //   () {
                          //     if (controller.isLoading.value) {
                          //       return Center(
                          //           child: CircularProgressIndicator());
                          //     }

                          //     // if (controller.attendances.isEmpty) {
                          //     //   return Center(
                          //     //       child: Text('No Attendance Data Found'));
                          //     // }

                          //     // Dapatkan tanggal sekarang
                          //     DateTime today = DateTime.now();

                          //     // Cek apakah ada tanggal di attendances yang sesuai dengan hari ini
                          //     bool todayExists = controller.attendances.any(
                          //         (attendance) =>
                          //             attendance.createdAt.year == today.year &&
                          //             attendance.createdAt.month ==
                          //                 today.month &&
                          //             attendance.createdAt.day == today.day);

                          //     // Jika ada data untuk hari ini, tidak tampilkan UI (contohnya SizedBox).
                          //     // if (todayExists) {
                          //     //   return SizedBox(); // Tidak tampilkan apapun
                          //     // }
                          //     return Row(
                          //       children: [
                          //         Expanded(
                          //           child: Card(
                          //             elevation: 8,
                          //             shadowColor: Colors.grey.withOpacity(0.5),
                          //             child: ListTile(
                          //               title: Text(
                          //                 'Absensi Karyawan',
                          //                 style: TextStyle(
                          //                     fontSize: 19,
                          //                     fontWeight: FontWeight.w500),
                          //               ),
                          //               subtitle: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   Text(
                          //                     DateFormat('dd MMMM yyyy')
                          //                         .format(DateTime.now()),
                          //                     style: TextStyle(
                          //                         fontSize: 16,
                          //                         color: Colors.grey[700]),
                          //                   ),
                          //                   // Text(
                          //                   //   'Tenggat: 08:00',
                          //                   //   style: TextStyle(
                          //                   //       fontSize: 16,
                          //                   //       color: Colors.grey[700]),
                          //                   // ),
                          //                 ],
                          //               ),
                          //               trailing: ElevatedButton(
                          //                 onPressed: () async {
                          //                   controller.getCurrentPosition();
                          //                   AbsenService().AbsenRequest();
                          //                 },
                          //                 child: Text(
                          //                   'Absen',
                          //                   style: TextStyle(
                          //                       fontSize: 18,
                          //                       fontWeight: FontWeight.w500,
                          //                       color: Colors.white),
                          //                 ),
                          //                 style: ElevatedButton.styleFrom(
                          //                     backgroundColor: Color.fromARGB(
                          //                         255, 24, 79, 235),
                          //                     shape: RoundedRectangleBorder(
                          //                         borderRadius:
                          //                             BorderRadius.all(
                          //                                 Radius.circular(
                          //                                     12)))),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tugas Hari Ini',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          Obx(
                            () {
                              if (controller.isLoading.value) {
                                // return Center(
                                return SizedBox();
                                // child: CircularProgressIndicator());
                              }

                              if (controller.filteredProyekList.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                      child: Text(
                                          'Belum ada tugas dengan tenggat hari ini')),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.filteredProyekList.length,
                                itemBuilder: (context, index) {
                                  final proyek =
                                      controller.filteredProyekList[index];
                                  return Card(
                                    elevation: 8,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 12, top: 10),
                                                child: Text(
                                                  proyek.name,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.green,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                child: Text(
                                                  proyek.status,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                proyek.description,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700]),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    // ('Harga: ${formatHarga(double.tryParse(proyek.price)!)}'),
                                                    ('Harga: '),
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
                                                          '${formatHarga(double.tryParse(proyek.price)!)}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[700],
                                                            // color: Colors.black,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                          proyek.end_date ==
                                                                  null
                                                              ? ''
                                                              : '${DateFormat('dd MMMM yyyy').format(proyek.end_date)}',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[700]),
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: proyek
                                                            .assignedProjects
                                                            .map(
                                                                (assignedProject) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: Text(
                                                              assignedProject
                                                                  .employeeName,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .grey[700],
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
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
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 15,right: 15,bottom: 8),
                                                
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    print('next');
                                                    SpUtil.putInt(
                                                        'idKanban', proyek.id);
                                                    SpUtil.putString(
                                                        'namaProyek',
                                                        proyek.name);
                                                     await KanbanProvider()
                                            .fetchComments(proyek.id);
                                                    await KanbanController()
                                                        .getKanban(proyek.id);
                                                  },
                                                  child: controller
                                                          .isLoading.value
                                                      ? SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          'Kanban',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17),
                                                        ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 24, 79, 235),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
