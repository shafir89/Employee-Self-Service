  import 'package:ems/app/data/login_provider.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> detailProfile(BuildContext context) {
    final employeeController = Get.find<LoginController>();
    final employee = employeeController.getEmployee();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil Pengguna'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                maxRadius: 30,
                backgroundImage: AssetImage(
                  'assets/images/avauser.png',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Text(
                    employee!.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Text(
                    employee.email,
                    style: TextStyle(fontSize: 15),
                  ),
                  // Text('employee',style: TextStyle(fontSize: 15),),
                  // Text(employee.companyId.toString(),style: TextStyle(fontSize: 15),),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        backgroundColor:
                            const Color.fromARGB(255, 252, 231, 231),
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
                                'Anda Yakin Ingin Keluar?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     TextButton(
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: const Text(
                              //         'Tidak',
                              //         style: TextStyle(
                              //             color: Color.fromARGB(255, 0, 0, 0)),
                              //       ),
                              //     ),
                              //     TextButton(
                              //       onPressed: () async {
                              //         await LoginProvider().logoutRequest();
                              //       },
                              //       child: const Text(
                              //         'Ya',
                              //         style: TextStyle(color: Colors.red),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 24, 79, 235)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
