import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:ems/app/modules/kanban/model_kometar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CommentItem extends StatelessWidget {
  final Datum comment;

  const CommentItem({required this.comment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var komentarTime = KanbanController().timeAgo(comment.createdAt);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avauser.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                comment.user?.name ?? 'Anonymous',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      komentarTime,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            comment.comment,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          InkWell(
              onTap: () {
                print('udah ke tap');
              },
              child: Text(
                'Balas',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
          // const SizedBox(height: 8),
          // Text(
          //   'Posted by: ${comment.user?.name ?? 'Anonymous'}',
          //   style: TextStyle(color: Colors.grey[600]),
          // ),
          const SizedBox(height: 4),

          // Optional: Menampilkan balasan komentar jika ada
          if (comment.replies != null && comment.replies!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: comment.replies!.map((reply) {
                  final replyTime = KanbanController().timeAgo(reply.createdAt);
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/avauser.png'),
                              radius: 12,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              reply.user?.name ?? 'Anonymous',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    replyTime,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          reply.comment,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
