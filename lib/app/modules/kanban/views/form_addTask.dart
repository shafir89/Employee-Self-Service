import 'package:date_field/date_field.dart';
import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

Future<void> addTaskKanban(context) {
  KanbanController controller = Get.put(KanbanController());

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text('Buat tugas baru'),
        content: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tanggal Mulai (Required)
                Obx(() => DateTimeField(
                      decoration: InputDecoration(
                        labelText: 'Sampai Tanggal',
                        border: OutlineInputBorder(),
                      ),
                      value: controller.tanggalSelesai.value,
                      onChanged: (DateTime? newValue) {
                        if (newValue != null) {
                          controller.tanggalSelesai.value = newValue;
                          print(
                              'Sampai Tanggal: ${DateFormat('yyyy-MM-dd').format(newValue)}');
                        }
                      },
                      mode: DateTimeFieldPickerMode.date,
                    )),

                SizedBox(height: 8),

                // Deskripsi (Optional)
                TextFormField(
                  maxLines: 3,
                  controller: controller.judul,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi',
                  ),
                ),

                SizedBox(height: 8),

                // Deskripsi (Optional)
                TextFormField(
                  maxLines: 3,
                  controller: controller.deskripsi,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi',
                  ),
                ),

                // Radio Button for Tipe Izin (Required)

                SizedBox(height: 15),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // clearForm();
                        Get.back();
                      },
                      child:
                          Text('Batal', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 73, 190, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          if (controller.judul.value == null) {
                            Get.snackbar(
                                'Tidak Valid', 'Judul harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (controller.deskripsi.value == null) {
                            Get.snackbar(
                                'Tidak Valid', 'Deskripsi harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (controller.tanggalSelesai.value == null) {
                            Get.snackbar(
                                'Tidak Valid', 'Tanggal Selesai harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          } 
                          if (controller.judul.value != null ||
                              controller.deskripsi.value != null ||
                            controller.tanggalSelesai.value != null) {
                            // requestizin();
                            Get.back();
                            print("Form disimpan");
                            print(controller.judul.value);
                            print(controller.deskripsi.value);
                            print(controller.tanggalSelesai.value);
                          }
                        }
                      },
                      child:
                          Text('Simpan', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 93, 135, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
  );
}
