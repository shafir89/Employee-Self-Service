import 'package:ems/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardTile extends StatelessWidget {
  final TileData tile;

  const DashboardTile(this.tile);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: tile.color,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8),
        //   // color: tile.color,
        //   image: DecorationImage(image: AssetImage('assets/images/bluecard.png'),fit: BoxFit.cover)
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tile.value,
              style: TextStyle(
                fontSize: 36,
                color: const Color(0xFFEEEEEE),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              tile.label,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFFEEEEEE),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileData {
  final String value;
  final String label;
  final Color color;

  TileData(this.value, this.label,this.color);
}
