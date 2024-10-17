import 'dart:convert';
import 'dart:io';
import 'package:ems/app/data/absen_provider.dart';
import 'package:ems/app/data/leaveRequest_provider.dart';
import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path/path.dart'; // Pastikan package ini terinstal

enum Tipeizin { Izin, Sakit }

class AbsensiController extends GetxController {
  var attendances = <Attendance>[].obs; // List observable dari Attendance
  var isLoading = true.obs;

  var _image = Rx<File?>(null);
  var loading = false.obs;
  final formKey = GlobalKey<FormState>();
  final deskripsi = TextEditingController();
  Rx<DateTime> tanggalMulai = DateTime.now().obs; // Tidak boleh null
  Rxn<DateTime> tanggalSelesai = Rxn<DateTime>(); // Bisa null
  Tipeizin? character = Tipeizin.Izin;
  DateTime? filterdipilih;
  var selectedValue = Rxn<String>(); // Default value
  void setSelected(String value) {
    selectedValue.value = value;
  }

  Future<void> onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: filterdipilih ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      locale: localeObj,
    );
    // final selected = await showDatePicker(
    //   context: context,
    //   initialDate: _selected ?? DateTime.now(),
    //   firstDate: DateTime(2019),
    //   lastDate: DateTime(2022),
    //   locale: localeObj,
    // );
    if (selected != null) {
      filterdipilih = selected;
    }
  }

  var absensiFilter = [].obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onInit() {
    fetchAttendances();
    super.onInit();
  }

  void fetchAttendances() async {
    try {
      isLoading(true);
      var fetchedAttendances = await AbsenService().fetchAbsensi();
      attendances.assignAll(fetchedAttendances);
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
    }
  }

  void clearForm() {
    deskripsi.clear();
    tanggalMulai.value = DateTime.now(); // Reset to current date
    tanggalSelesai.value = null; // Reset to null
    _image.value = null;
  }

//   void requestizin() async {
//     if (formKey.currentState!.validate()) {
//       loading.value = true;

//       String tanggalmulai = tanggalMulai.value.toString();
//       String tanggalselesai = tanggalSelesai.value.toString();
// print(selectedValue);
//         print(tanggalmulai);
//         print(tanggalselesai);
//         print(_image.value.toString());
//       try {

//         var data = {
//           'start_date': tanggalmulai,
//           'end_date': tanggalselesai,
//           'type': selectedValue.value,
//         };

//         var response =
//             await LeaverequestProvider().LeaveRequest(data, _image.value);
//         var jsonResponse = jsonDecode(response.body); // Parse JSON
//         String message = jsonResponse['message'];
//         String status = jsonResponse['success'];

//         if (response.statusCode == 200 || status == 'true') {
//           loading.value = false;
//           Get.snackbar('Success', message,
//               colorText: Colors.white, backgroundColor: Colors.green);
//         } else {
//           loading.value = false;
//           Get.snackbar('Error', message,
//               colorText: Colors.white, backgroundColor: Colors.red);
//           print(response.body);

//         }
//       } catch (e) {
//         loading.value = false;
//         Get.snackbar('Error', 'Terjadi kesalahan',
//             colorText: Colors.white, backgroundColor: Colors.red);
//         print(e);
//         // print(response.reasonPhrase);
//       }
//     }
//   }

  void requestizin() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;

      String tanggalmulai = tanggalMulai.value.toString();
      String tanggalselesai = tanggalSelesai.value.toString();

      try {
        print(_image.value.toString());

        var data = {
          'start_date': tanggalmulai,
          'end_date': tanggalselesai,
          'type': selectedValue.value,
        };

        var response =
            await LeaverequestProvider().LeaveRequest(data, _image.value);
        print(response.statusCode);
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        String status = jsonResponse['success'].toString();
        if (status == 'true') {
          loading.value = false;
          Get.snackbar('Success', message,
              colorText: Colors.white, backgroundColor: Colors.green);
          return;
        }
        if (status == 'false') {
          loading.value = false;
          Get.snackbar('Error', message,
              colorText: Colors.white, backgroundColor: Colors.red);
        } else {
          loading.value = false;
          // Get.snackbar(
          //     'Error', 'Permintaan Gagal, kode status: ${response.statusCode}',
          print(response.statusCode);
          Get.snackbar('Error', message,
              colorText: Colors.white, backgroundColor: Colors.red);
          print(response.body);
        }
      } catch (e) {
        loading.value = false;

        Get.snackbar('Error', 'Terjadi kesalahan',
            colorText: Colors.white, backgroundColor: Colors.red);
        print(e);
      }
    }
  }

  Future<void> formLeave(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Tambah Permintaan Cuti'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tanggal Mulai (Required)
                    Obx(() => DateTimeField(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Mulai',
                            border: OutlineInputBorder(),
                          ),
                          value: tanggalMulai.value,
                          onChanged: (DateTime? newValue) {
                            if (newValue != null) {
                              tanggalMulai.value = newValue;
                              print(
                                  'Tanggal Mulai: ${DateFormat('yyyy-MM-dd').format(newValue)}');
                            }
                          },
                          mode: DateTimeFieldPickerMode.date,
                        )),

                    SizedBox(height: 8),

                    // Tanggal Selesai (Required)
                    Obx(() => DateTimeField(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Selesai',
                            border: OutlineInputBorder(),
                          ),
                          value: tanggalSelesai.value,
                          onChanged: (DateTime? newValue) {
                            tanggalSelesai.value = newValue;
                            if (newValue != null) {
                              print(
                                  'Tanggal Selesai: ${DateFormat('yyyy-MM-dd').format(newValue)}');
                            }
                          },
                          mode: DateTimeFieldPickerMode.date,
                        )),

                    SizedBox(height: 8),

                    // Display Image (Required)
                    Obx(() => _image.value == null
                        ? Text('Belum ada bukti yang dipilih',
                            style: TextStyle(color: Colors.red))
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: Image.file(
                                  _image.value!,
                                  fit: BoxFit.cover,
                                )),
                          )),
                    ElevatedButton(
                      onPressed: () async {
                        await pickImage();
                      },
                      child: Center(
                          child: Text(
                        'Pilih Bukti Foto',
                        style: TextStyle(color: Colors.white),
                      )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 24, 79, 235)),
                    ),
                    SizedBox(height: 8),

                    // Deskripsi (Optional)
                    // TextFormField(
                    //   maxLines: 3,
                    //   controller: deskripsi,
                    //   decoration: InputDecoration(
                    //     enabled: true,
                    //     border: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey)),
                    //     labelText: 'Deskripsi (Opsional)',
                    //   ),
                    // ),
                    TextFormField(
                      controller: deskripsi,
                      decoration: const InputDecoration(
                        label: Text('Deskripsi (Opsional)'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 167, 158, 162)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                       
                      ),
                     
                    ),

                    SizedBox(height: 8),

                    // Radio Button for Tipe Izin (Required)
                    Text(
                      'Tipe Izin',
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => Row(
                              children: [
                                Radio(
                                  value: 'Izin',
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    setSelected(value!);
                                  },
                                ),
                                Text("Izin"),
                              ],
                            )),
                        Obx(() => Row(
                              children: [
                                Radio(
                                  value: 'Sakit',
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    setSelected(value!);
                                  },
                                ),
                                Text("Sakit"),
                              ],
                            )),
                      ],
                    ),

                    SizedBox(height: 15),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            clearForm();
                            Get.back();
                          },
                          child: Text('Batal',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 73, 190, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (tanggalSelesai.value == null) {
                                Get.snackbar('Tidak Valid',
                                    'tanggal selesai harus diisi',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (_image.value == null) {
                                Get.snackbar('Tidak Valid',
                                    'foto bukti harus disertakan',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (selectedValue.value == null) {
                                Get.snackbar(
                                    'Tidak Valid', 'Harus memilih tipe izin',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (tanggalMulai.value != null ||
                                  tanggalSelesai.value != null ||
                                  _image.value != null) {
                                requestizin();
                                Get.back();
                                print("Form disimpan");
                                print(tanggalMulai.value);
                                print(selectedValue.value);
                                print(tanggalSelesai.value);
                                print(_image.value.toString());
                              }
                            }
                          },
                          child: Text('Simpan',
                              style: TextStyle(color: Colors.white)),
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
            ));
      },
    );
  }
}
