import 'package:ems/app/data/kanban_provider.dart';
import 'package:ems/app/modules/kanban/model_kometar.dart';
import 'package:ems/app/modules/kanban/views/comments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import '../controllers/kanban_controller.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';
import 'package:ems/app/modules/kanban/model_task.dart';

class KanbanView extends GetView<KanbanController> {
  KanbanView({super.key});
  @override
  // KanbanController controllerkanban = Get.put(KanbanController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    // Initialize lists with arguments if available
    if (args != null) {
      controller.todoList.value = args['todoList'] ?? [];
      controller.inProgressList.value = args['inProgressList'] ?? [];
      controller.doneList.value = args['doneList'] ?? [];
    }
    final namaProyek = SpUtil.getString('namaProyek') ?? 'Kanban';
    final total_comment = SpUtil.getInt('total_komen') ?? '0';
    // final List<String> items =
    //     List<String>.generate(50, (index) => 'Item $index');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Kanban ${namaProyek}',
            // 'Kanban',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: KanbanBoard(
                        idkanban: controller.id,
                        [
                          BoardListsData(
                            title: 'To Do',
                            items: controller.todoList
                                .map((task) => _buildCard(task))
                                .toList(),
                            backgroundColor:
                                const Color.fromRGBO(187, 222, 251, 1),
                          ),
                          BoardListsData(
                            title: 'In Progress',
                            items: controller.inProgressList
                                .map((task) => _buildCard(task))
                                .toList(),
                            backgroundColor: Colors.yellow.shade100,
                          ),
                          BoardListsData(
                            title: 'Done',
                            items: controller.doneList
                                .map((task) => _buildCard(task))
                                .toList(),
                            backgroundColor: Colors.green.shade100,
                          ),
                        ],
                        // // onItemLongPress: (cardIndex, listIndex) {
                        // //   print(
                        // //       'Kartu pada index $cardIndex di list $listIndex ditekan lama.');
                        // // },
                        // onItemReorder: (oldCardIndex, newCardIndex,
                        //     oldListIndex, newListIndex) {
                        //   print(
                        //       'Kartu dipindah dari posisi $oldCardIndex ke $newCardIndex, dari list $oldListIndex ke $newListIndex.');
                        // },
                        // onListLongPress: (listIndex) {
                        //   print('List pada index $listIndex ditekan lama.');
                        // },
                        // onListReorder: (oldListIndex, newListIndex) {
                        //   print(
                        //       'List dipindahkan dari posisi $oldListIndex ke $newListIndex.');
                        // },
                        // onItemTap: (cardIndex, listIndex) {
                        //   print(
                        //       'Kartu pada index $cardIndex di list $listIndex diketuk.');
                        // },
                        // onListTap: (listIndex) {
                        //   print('List pada index $listIndex diketuk.');
                        // },
                        // onListRename: (oldName, newName) {
                        //   print(
                        //       'Nama list diubah dari $oldName menjadi $newName.');
                        // },
                        backgroundColor: Colors.white,
                        displacementY: 124,
                        displacementX: 100,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
//                 DraggableScrollableSheet(
//   initialChildSize: 0.1,
//   minChildSize: 0.1,
//   maxChildSize: 0.5,
//   builder: (BuildContext context, scrollController) {
//     final comments = Get.find<KanbanController>();
//     final komentar = comments.getKomentar();

//     return Container(
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: Theme.of(context).canvasColor,
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 143, 141, 141),
//             spreadRadius: 0.1,
//             blurRadius: 3,
//           ),
//         ],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: CustomScrollView(
//         controller: scrollController,
//         slivers: [
//           SliverToBoxAdapter(
//             child: Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).hintColor,
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       spreadRadius: 0.5,
//                     ),
//                   ],
//                 ),
//                 height: 4,
//                 width: 40,
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//               ),
//             ),
//           ),
//           SliverAppBar(
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   komentarModel.comments.data.length.toString(),
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   'Komentar',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ],
//             ),
//           ),
//           ListView.builder(
//               controller: scrollController,
//               itemCount: KomentarModel.comments.data.length,
//               itemBuilder: (context, index) {
//                 Datum comment = komentarModel.comments.data[index];
//                 return CommentItem(comment: comment);
//               },
//             ),

//         ],
//       ),
//     );
//   },
// ),
                DraggableScrollableSheet(
                  initialChildSize: 0.1,
                  minChildSize: 0.1,
                  maxChildSize: 0.7,
                  builder: (BuildContext context, scrollController) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 143, 141, 141),
                            spreadRadius: 0.1,
                            blurRadius: 3,
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Obx(() {
                        final komentarModel = controller.komentar
                            .value; // Ambil data komentar dari controller

                        if (komentarModel == null) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Tampilkan loading jika data belum ada
                        }
                        int totalComments = komentarModel.comments.data.length;
                        int totalReplies = komentarModel.comments.data.fold(0,
                            (sum, item) => sum + (item.replies?.length ?? 0));
                        int totalKomen = totalReplies + totalComments;
                        return CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                  ),
                                  height: 4,
                                  width: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            SliverAppBar(
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    totalKomen.toString(),
                                    // komentarModel.comments.commentCount.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Komentar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  Datum comment =
                                      komentarModel.comments.data[index];
                                  return CommentItem(
                                      comment: comment); // Tampilkan komentar
                                },
                                childCount: komentarModel.comments.data.length,
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _buildCard(Task task) {
  return Container(
    decoration: BoxDecoration(
      color: _getStatusColor(task.status).withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.grey.shade200),
    ),
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        // Text(task.description),
        Text(task.assignedTo),
        // Text('Due Date: ${task.dueDate ?? 'N/A'}'),
      ],
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'done':
      return Colors.green;
    case 'todo':
      return Color.fromARGB(255, 24, 79, 235);
    case 'progress':
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}
