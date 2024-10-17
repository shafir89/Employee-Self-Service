import 'dart:developer';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kanban_board/Provider/store_task_provider.dart';
import 'package:kanban_board/Provider/user_provider.dart';
import '../custom/list_item.dart';
import '../custom/text_field.dart';
import '../models/item_state.dart';
import 'provider_list.dart';

class BoardListProvider extends ChangeNotifier {
  BoardListProvider(ChangeNotifierProviderRef<BoardListProvider> this.ref);
  Ref ref;
  var scrolling = false;
  var scrollingUp = false;
  var scrollingDown = false;
  var newList = false;
  var defaultWarna = 'Biru'.obs;
  var dropdownUser = 'Pilih Pengguna'.obs;
  List<String> dropdownItems = <String>[
    'Biru',
    'Cyan',
    'Hijau',
    'Merah',
    'Kuning',
    'Biru Muda'
  ];

  void calculateSizePosition(
      {required int listIndex,
      required BuildContext context,
      required VoidCallback setstate}) {
    var prov = ref.read(ProviderList.boardProvider);
    prov.board.lists[listIndex].context = context;
    var box = context.findRenderObject() as RenderBox;
    var location = box.localToGlobal(Offset.zero);
    prov.board.lists[listIndex].x =
        location.dx - prov.board.displacementX! - 10;
    prov.board.lists[listIndex].setState = setstate;
    prov.board.lists[listIndex].y =
        location.dy - prov.board.displacementY! + 24;
    prov.board.lists[listIndex].width ??= box.size.width;
    prov.board.lists[listIndex].height ??= box.size.height;
  }

  // Future addNewCard({required String position, required int listIndex}) async {
  // var prov = ref.read(ProviderList.boardProvider);
  // if (prov.board.newCardFocused == true) {
  //   ref.read(ProviderList.cardProvider).saveNewCard();
  // }

  // var scroll = prov.board.lists[listIndex].scrollController;

  // // log("MAX EXTENT =${scroll.position.maxScrollExtent}");

  // prov.board.lists[listIndex].items.insert(
  //     position == "TOP" ? 0 : prov.board.lists[listIndex].items.length,
  //     ListItem(
  //       child: Container(
  //           width: prov.board.lists[listIndex].width,
  //           color: Colors.white,
  //           margin: const EdgeInsets.only(bottom: 10),
  //           child: const TField()),
  //       listIndex: listIndex,
  //       isNew: true,
  //       index: prov.board.lists[listIndex].items.length,
  //       prevChild: Container(
  //           width: prov.board.lists[listIndex].width,
  //           color: Colors.white,
  //           margin: const EdgeInsets.only(bottom: 10),
  //           padding: const EdgeInsets.all(10),
  //           child: const TField()),
  //     ));
  // position == "TOP" ? await scrollToMin(scroll) : scrollToMax(scroll);
  // prov.board.newCardListIndex = listIndex;
  // prov.board.newCardFocused = true;
  // prov.board.newCardIndex =
  //     position == "TOP" ? 0 : prov.board.lists[listIndex].items.length - 1;
  // prov.board.lists[listIndex].setState!();
// }

  var formKey = GlobalKey<FormState>();
  TextEditingController judul = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  Rxn<DateTime> tanggalSelesai = Rxn<DateTime>();
  Future addNewCard(
      {required BuildContext context, // Add this parameter
      required String position,
      required int listIndex,
      required int idkanban
      // required List users,
      }) async {
    List<UserAssignModel> users = await UserProvider().fetchUser(idkanban);
    List<UserAssignModel> dropdownUsers = [
          UserAssignModel(idEmployee: 0, nameEmployee: 'Pilih Pengguna'),
        ] +
        users;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buat tugas baru'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judul,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Judul',
                  ),
                ),

                SizedBox(height: 8),
                TextFormField(
                  maxLines: 3,
                  controller: deskripsi,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi',
                  ),
                ),

                SizedBox(height: 8),

                Obx(() => DateTimeField(
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        border: OutlineInputBorder(),
                      ),
                      value: tanggalSelesai.value,
                      onChanged: (DateTime? newValue) {
                        if (newValue != null) {
                          tanggalSelesai.value = newValue;
                          print(
                              'Sampai Tanggal: ${DateFormat('yyyy-MM-dd').format(newValue)}');
                        }
                      },
                      mode: DateTimeFieldPickerMode.date,
                    )),

                SizedBox(height: 8),

                // TextFormField(
                //   controller: deskripsi,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Warna',
                //   ),
                // ),
                // SizedBox(height: 8),
                // TextFormField(
                //   controller: deskripsi,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Ditugaskan kepada Pengguna',
                //   ),
                // ),
                // Obx(()=>
                //   DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       value: dropdownWarna.value,
                //         onChanged: (String? newValue) {
                //           dropdownWarna.value = newValue!;
                //         },
                //       items: dropdownItems.map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //     ),),
                // ),
                Obx(() {
                  if (!dropdownItems.contains(defaultWarna.value)) {
                    defaultWarna.value =
                        dropdownItems.first; // Set nilai default
                  }
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Warna',
                    ),
                    value: defaultWarna
                        .value, // Pastikan ini terhubung ke variabel observasi
                    items: dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      defaultWarna.value = newValue!;
                    },
                  );
                }),

                SizedBox(height: 8),
                // Obx(
                //   () => DropdownButtonFormField<String>(
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Tugaskan kepada Pengguna',
                //     ),
                //     value: dropdownUser.value,
                //     items: dropdownUsers.map((user) {
                //       return DropdownMenuItem<String>(
                //         value: user.nameEmployee,
                //         child: Text(user.nameEmployee),
                //       );
                //     }).toList(),
                //     onChanged: (String? newValue) {
                //       if (newValue != null) {
                //         dropdownUser.value = newValue;
                //       }
                //     },
                //     validator: (value) {
                //       if (value == null || value == 'Pilih Pengguna') {
                //         return 'Pengguna harus dipilih';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Obx(() {
                  // Cek apakah dropdownUser.value ada dalam daftar dropdownUsers
                  final validdropdownWarna = dropdownUsers
                      .any((user) => user.idEmployee == dropdownUser.value);

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tugaskan kepada Pengguna',
                    ),
                    value: validdropdownWarna
                        ? dropdownUser.value
                        : null, // Pastikan hanya menampilkan value yang valid
                    items: dropdownUsers.map((user) {
                      return DropdownMenuItem<String>(
                        value: user.idEmployee
                            .toString(), // Simpan id sebagai value
                        child:
                            Text(user.nameEmployee), // Tampilkan nameEmployee
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        dropdownUser.value =
                            newValue; // Menyimpan id yang baru dipilih
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pengguna harus dipilih';
                      }
                      return null;
                    },
                  );
                }),

                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                        if (formKey.currentState!.validate()) {
                          if (judul.value == null) {
                            Get.snackbar('Tidak Valid', 'Judul harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (deskripsi.value == null) {
                            Get.snackbar('Tidak Valid', 'Deskripsi harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (tanggalSelesai.value == null) {
                            Get.snackbar(
                                'Tidak Valid', 'Tanggal Selesai harus diisi',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (judul.value != null ||
                              deskripsi.value != null ||
                              tanggalSelesai.value != null) {
                            // Get.back();

                            String title = judul.text;
                            String description = deskripsi.text;
                            DateTime date = tanggalSelesai.value!;
                            String color = '#ACB1B9';

                            if (defaultWarna.value == 'Biru') {
                              color = '#5D87FF';
                            }
                            if (defaultWarna.value == 'Cyan') {
                              color = '#49BEFF';
                            }
                            if (defaultWarna.value == 'Hijau') {
                              color = '#13DEB9';
                            }
                            if (defaultWarna.value == 'Merah') {
                              color = '#FA896B';
                            }
                            if (defaultWarna.value == 'Kuning') {
                              color = '#FFAE1F';
                            }
                            if (defaultWarna.value == 'Biru Muda') {
                              color = '#539BFF';
                            }
                            String kanbanId = idkanban.toString();
                            String statuslist = '0';
                            if (listIndex == 0) {
                              statuslist = 'todo';
                            }
                            if (listIndex == 1) {
                              statuslist = 'progress';
                            }
                            if (listIndex == 2) {
                              statuslist = 'done';
                            }

                            String employee_id = dropdownUser.value;

                            print(judul.text);
                            print(deskripsi.text);
                            print(tanggalSelesai.value.toString());
                            print(color);
                            print(dropdownUser.value);
                            print(statuslist);
                            print(idkanban);
                            print(listIndex);

                            StoreTaskProvider().store(title, description, date,
                                color, employee_id, statuslist, kanbanId);
                            judul.clear();
                            deskripsi.clear();
                            defaultWarna.value = '';
                            dropdownUser.value = '0';
                            tanggalSelesai.value = null;
                            Get.back();
                          } else {
                            Get.snackbar('error', 'terjadi kesalahan');
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
        ),
      ),
    );
  }
// UNTUK DRAG LIST KANBAN NYA BUKAN TASK NYA
  // void onListLongpress(
  //     {required int listIndex,
  //     required BuildContext context,
  //     required VoidCallback setstate}) {
  //   var prov = ref.read(ProviderList.boardProvider);
  //   for (var element in prov.board.lists) {
  //     if (element.context == null) break;
  //     var of = (element.context!.findRenderObject() as RenderBox)
  //         .localToGlobal(Offset.zero);
  //     element.x = of.dx - prov.board.displacementX!;
  //     element.width = element.context!.size!.width - 30;
  //     element.height = element.context!.size!.height - 30;
  //     element.y = of.dy - prov.board.displacementY!;
  //   }
  //   var box = context.findRenderObject() as RenderBox;
  //   var location = box.localToGlobal(Offset.zero);
  //   prov.updateValue(
  //       dx: location.dx - prov.board.displacementX! - 10,
  //       dy: location.dy - prov.board.displacementY! + 24);

  //   prov.board.dragItemIndex = null;
  //   prov.board.dragItemOfListIndex = listIndex;
  //   prov.draggedItemState = DraggedItemState(
  //       child: Container(
  //         width: box.size.width - 30,
  //         height: box.size.height - 30,
  //         color: prov.board.lists[listIndex].backgroundColor,
  //         child: Column(children: [
  //           Container(
  //             margin: const EdgeInsets.only(
  //               top: 20,
  //             ),
  //             padding: const EdgeInsets.only(left: 15, bottom: 10),
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               prov.board.lists[listIndex].title,
  //               style: const TextStyle(
  //                   fontSize: 20,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Expanded(
  //             child: MediaQuery.removePadding(
  //               context: context,
  //               removeTop: true,
  //               child: ListView.builder(
  //                 physics: const ClampingScrollPhysics(),
  //                 controller: null,
  //                 itemCount: prov.board.lists[listIndex].items.length,
  //                 shrinkWrap: true,
  //                 itemBuilder: (ctx, index) {
  //                   return Item(
  //                     color: prov.board.lists[listIndex].items[index]
  //                             .backgroundColor ??
  //                         Colors.grey.shade200,
  //                     itemIndex: index,
  //                     listIndex: listIndex,
  //                   );
  //                 },

  //                 // itemCount: prov.items.length,
  //               ),
  //             ),
  //           ),
  //         ]),
  //       ),
  //       listIndex: listIndex,
  //       itemIndex: null,
  //       height: box.size.height - 30,
  //       width: box.size.width - 30,
  //       x: location.dx - prov.board.displacementX!,
  //       y: location.dy - prov.board.displacementY!);
  //   prov.draggedItemState!.setState = () => setstate;
  //   prov.board.dragItemIndex = null;
  //   prov.board.isListDragged = true;
  //   prov.board.dragItemOfListIndex = listIndex;
  //   setstate();
  // }

  Future scrollToMax(ScrollController controller) async {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      return;
    }

    //log(controller.position.extentAfter.toString());
    await controller.animateTo(
      controller.position.pixels + controller.position.extentAfter,
      duration: Duration(
          milliseconds: (int.parse(controller.position.extentAfter
              .toString()
              .substring(0, 3)
              .split('.')
              .first))),
      curve: Curves.linear,
    );
    scrollToMax(controller);
  }

  Future scrollToMin(ScrollController controller) async {
    if (controller.position.pixels == controller.position.minScrollExtent) {
      return;
    }

    log(controller.position.extentBefore.toString());
    await controller.animateTo(
      controller.position.pixels - controller.position.extentBefore,
      duration: Duration(
          milliseconds: (int.parse(controller.position.extentBefore
              .toString()
              .substring(0, 3)
              .split('.')
              .first))),
      curve: Curves.linear,
    );
    scrollToMin(controller);
  }

  void maybeListScroll() async {
    var prov = ref.read(ProviderList.boardProvider);
    if (prov.board.isElementDragged == false || scrolling) {
      return;
    }
    var controller =
        prov.board.lists[prov.board.dragItemOfListIndex!].scrollController;
    if (controller.offset < controller.position.maxScrollExtent &&
        prov.valueNotifier.value.dy >
            controller.position.viewportDimension - 50) {
      scrolling = true;
      scrollingDown = true;
      if (prov.board.listScrollConfig == null) {
        await controller.animateTo(controller.offset + 45,
            duration: const Duration(milliseconds: 250), curve: Curves.linear);
      } else {
        await controller.animateTo(
            prov.board.listScrollConfig!.offset + controller.offset,
            duration: prov.board.listScrollConfig!.duration,
            curve: prov.board.listScrollConfig!.curve);
      }
      scrolling = false;
      scrollingDown = false;

      maybeListScroll();
    } else if (controller.offset > 0 && prov.valueNotifier.value.dy < 100) {
      scrolling = true;
      scrollingUp = true;
      if (prov.board.listScrollConfig == null) {
        await controller.animateTo(controller.offset - 45,
            duration: const Duration(milliseconds: 250), curve: Curves.linear);
      } else {
        await controller.animateTo(
            controller.offset - prov.board.listScrollConfig!.offset,
            duration: prov.board.listScrollConfig!.duration,
            curve: prov.board.listScrollConfig!.curve);
      }
      scrolling = false;
      scrollingUp = false;
      maybeListScroll();
    } else {
      return;
    }
  }

  void moveListRight() {
    var prov = ref.read(ProviderList.boardProvider);
    if (prov.draggedItemState!.listIndex == prov.board.lists.length - 1) {
      return;
    }
    if (prov.valueNotifier.value.dx +
            prov.board.lists[prov.draggedItemState!.listIndex!].width! / 2 <
        prov.board.lists[prov.draggedItemState!.listIndex! + 1].x!) {
      return;
    }
    // dev.log("LIST RIGHT");
    prov.board.lists.insert(prov.draggedItemState!.listIndex! + 1,
        prov.board.lists.removeAt(prov.draggedItemState!.listIndex!));
    prov.draggedItemState!.listIndex = prov.draggedItemState!.listIndex! + 1;
    prov.board.dragItemOfListIndex = null;
    prov.board.dragItemIndex = null;
    prov.draggedItemState!.itemIndex = null;
    prov.board.lists[prov.draggedItemState!.listIndex! - 1].setState!();
    prov.board.lists[prov.draggedItemState!.listIndex!].setState!();
  }

  void moveListLeft() {
    var prov = ref.read(ProviderList.boardProvider);
    if (prov.draggedItemState!.listIndex == 0) {
      return;
    }
    if (prov.valueNotifier.value.dx >
        prov.board.lists[prov.draggedItemState!.listIndex! - 1].x! +
            (prov.board.lists[prov.draggedItemState!.listIndex! - 1].width! /
                2)) {
      // dev.log(
      // "RETURN LEFT LIST ${prov.valueNotifier.value.dx} ${prov.board.lists[prov.draggedItemState!.listIndex! - 1].x! + (prov.board.lists[prov.draggedItemState!.listIndex! - 1].width! / 2)} ");
      return;
    }
    // dev.log("LIST LEFT ${prov.valueNotifier.value.dx} ${prov.board.lists[prov.draggedItemState!.listIndex! - 1].x! + (prov.board.lists[prov.draggedItemState!.listIndex! - 1].width! / 2)} ");
    prov.board.lists.insert(prov.draggedItemState!.listIndex! - 1,
        prov.board.lists.removeAt(prov.draggedItemState!.listIndex!));
    prov.draggedItemState!.listIndex = prov.draggedItemState!.listIndex! - 1;
    prov.board.dragItemOfListIndex = null;
    prov.board.dragItemIndex = null;
    prov.draggedItemState!.itemIndex = null;
    prov.board.lists[prov.draggedItemState!.listIndex!].setState!();
    prov.board.lists[prov.draggedItemState!.listIndex! + 1].setState!();
  }

  void createNewList() {}
}
