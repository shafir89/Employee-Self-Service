import 'package:ems/app/data/login_provider.dart';
import 'package:ems/app/modules/home/views/detail_profile.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showCustomPopupMenu(BuildContext context, Offset position) async {
  final employeeController = Get.find<LoginController>();
  final employee = employeeController.getEmployee();
  final selected = await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + 20, // Mengatur jarak munculnya pop-up menu dari pemicu
      position.dx + 1,
      position.dy + 1,
    ),
    items: [
      PopupMenuItem<int>(
          value: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: 
                CircleAvatar(
                backgroundImage: AssetImage('assets/images/avauser.png'),
                radius: 25,
              )
                ,
                title: Text(employee!.name,style: TextStyle(fontSize: 16,),),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(employee.role,style: TextStyle(fontSize: 16,color: Colors.grey[700])),
                  Row(
                    children: [
                      Icon(Icons.email_outlined,size: 18.1,color: Colors.grey[700],),
                      Text(employee.email,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                    ],
                
                  ),
                             
                  Row(
                    children: [
                      Icon(Icons.business_sharp,size: 18,color: Colors.grey[700],),
                      Text(employee.nameComp,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                    ],
                  )
                                  ],),
              ),
              // CircleAvatar(
              //   backgroundImage: AssetImage('assets/images/avauser.png'),
              //   radius: 25,
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       employee!.name,
              //       style: TextStyle(fontSize: 16),
              //     ),
              //                   SizedBox(
              //   height: 5,
              // ),
              //     Text(employee.role,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
              //                   SizedBox(
              //   height: 5,
              // ),
              //     Row(
              //       children: [
              //         Icon(Icons.email_outlined,size: 18.1,color: Colors.grey[700],),
              //         Text(employee.email,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
              //       ],
                
              //     ),
              //                 SizedBox(
              //   height: 5,
              // ),
              //     Row(
              //       children: [
              //         Icon(Icons.business_sharp,size: 18,color: Colors.grey[700],),
              //         Text(employee.nameComp,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
              //       ],
              //     )
              //   ],
              // ),
              Row(
          children: [
            // Icon(Icons.logout_rounded, color: Colors.red),
            // SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  // backgroundColor: Colors.red
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Anda yakin ingin keluar?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Tidak',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await LoginProvider().logoutRequest();
                                  },
                                  child: const Text(
                                    'Ya',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Text('Logout',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            )
          ],
        ),
            ],
          ),),
      // PopupMenuItem<int>(
      //   value: 1,
      //   child: Row(
      //     children: [
      //       // Icon(Icons.logout_rounded, color: Colors.red),
      //       // SizedBox(width: 5),
      //       Expanded(
      //         child: ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             side: BorderSide(color: Colors.red),
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.all(Radius.circular(12))),
      //             // backgroundColor: Colors.red
      //           ),
      //           onPressed: () {
      //             showDialog(
      //               context: context,
      //               builder: (BuildContext context) => Dialog(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12)),
      //                 backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: <Widget>[
      //                       const SizedBox(
      //                         height: 10,
      //                       ),
      //                       const Text(
      //                         'Anda yakin ingin keluar?',
      //                         style: TextStyle(
      //                           fontSize: 16,
      //                           color: Color.fromARGB(255, 0, 0, 0),
      //                         ),
      //                       ),
      //                       const SizedBox(height: 15),
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                         children: [
      //                           TextButton(
      //                             onPressed: () {
      //                               Navigator.pop(context);
      //                             },
      //                             child: const Text(
      //                               'Tidak',
      //                               style: TextStyle(
      //                                   fontSize: 16,
      //                                   color: Color.fromARGB(255, 0, 0, 0)),
      //                             ),
      //                           ),
      //                           TextButton(
      //                             onPressed: () async {
      //                               await LoginProvider().logoutRequest();
      //                             },
      //                             child: const Text(
      //                               'Ya',
      //                               style: TextStyle(
      //                                   fontSize: 16, color: Colors.red),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //           child: Text('Logout',
      //               style: TextStyle(color: Colors.red, fontSize: 16)),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    ],
  );

  if (selected != null) {
    if (selected == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Anda yakin ingin keluar?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Tidak',
                        style: TextStyle(
                            fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await LoginProvider().logoutRequest();
                      },
                      child: const Text(
                        'Ya',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (selected == 0) {
      detailProfile(context);
    }
  }
}
