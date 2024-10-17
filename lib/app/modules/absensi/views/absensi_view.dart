import 'package:ems/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

class AbsensiView extends StatelessWidget {
  final AbsensiController controller = Get.put(AbsensiController());
  TextEditingController dicari = TextEditingController();
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  var absensiFilter = [].obs;

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absensi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                AbsensiController().formLeave(context);
              },
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 2),
                  Text(
                    'Izin',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 174, 31),
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchAttendances();
          selectedDate?.value = null;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pilih bulan dan tahun',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.date_range),
                        ],
                      ),
                      onPressed: () async {
                        final selected = await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                        );
                        if (selected != null) {
                          selectDate(selected);
                          print(selected);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 24, 79, 235),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(height: 5),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.attendances.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(child: Text('Belum ada data absensi')),
                    );
                  }

                  DateTime now = DateTime.now();
                  final filterdate = selectedDate?.value;

                  final filteredAttendances = filterdate != null
                      ? controller.attendances.where((attendance) {
                          DateTime attendanceDate = DateTime.parse(attendance.date);
                          return attendanceDate.month == filterdate.month &&
                              attendanceDate.year == filterdate.year;
                        }).toList()
                      : controller.attendances.where((attendance) {
                          DateTime attendanceDate = DateTime.parse(attendance.date);
                          return attendanceDate.isBefore(now) || attendanceDate.isAtSameMomentAs(now);
                        }).toList();

                  if (filteredAttendances.isEmpty) {
                     return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(child: Text('Belum ada data absensi')),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredAttendances.length,
                    itemBuilder: (context, index) {
                      var attendance = filteredAttendances[index];

                      DateTime localCreatedAt = attendance.createdAt.toLocal();

                      String formattedDate =
                          DateFormat('dd MMMM yyyy').format(localCreatedAt);
                      String formattedTime =
                          DateFormat('HH:mm').format(localCreatedAt);
                      print(attendance.createdAt);
                      print(formattedTime);
                      DateTime date = DateTime.parse(attendance.date);
                      String dateFormatted =
                          DateFormat('d MMMM yyyy').format(date);

                      String statusText;

                      Color backColor;
                      Color textColor = Colors.white;
                      String backgroundImage;

                      switch (attendance.status) {
                        case 'present':
                          statusText = 'Hadir';
                          backColor = Color.fromARGB(255, 20, 168, 141);
                          backgroundImage = 'assets/images/attend_green.png';
                          break;
                        case 'late':
                          statusText = 'Telat';
                          backColor = Color.fromARGB(255, 93, 135, 255);
                          backgroundImage = 'assets/images/attend_blue.png';
                          break;
                        case 'alpha':
                          statusText = 'Alpha';
                          backColor = Color.fromARGB(255, 250, 137, 107);
                          backgroundImage = 'assets/images/attend_red.png';
                          break;
                        case 'absent':
                          statusText = 'Sakit';
                          backColor = Color.fromARGB(255, 255, 174, 31);
                          backgroundImage = 'assets/images/attend_orange.png';
                          break;
                        default:
                          statusText = 'Unknown';
                          backColor = Color.fromARGB(255, 93, 135, 255);
                          backgroundImage = 'assets/images/attend_orange.png';
                          textColor = Colors.black;
                      }

                      return Container(
                        decoration: BoxDecoration(
                            color: backColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Warna bayangan
                                spreadRadius: 1, // Jarak bayangan
                                blurRadius: 1, // Blur radius
                                offset: Offset(
                                    0, 3), // Hanya offset vertikal ke bawah)
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                                child: attendance.status == 'absent'
                                    ? IconButton(
                                        onPressed: () {
                                          print('halo');
                                        },
                                        icon: Icon(
                                          Icons.document_scanner_rounded,
                                          color: Colors.white,
                                        ))
                                    : SizedBox(
                                        width: 20,
                                      )),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      color: Color.fromARGB(255, 24, 79, 235),
                                    ),
                                    Text(dateFormatted),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                  color: backColor),
                              padding: EdgeInsets.all(11),
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '${attendance.status}',
                                        style: TextStyle(
                                            fontSize: 15, color: textColor),
                                      ),
                                      attendance.status == 'absent'? SizedBox():
                                      Text(
                                        '${formattedTime}',
                                        style: TextStyle(
                                            fontSize: 15, color: textColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
