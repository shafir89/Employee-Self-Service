import 'package:intl/intl.dart';

String formatHarga(double jumlah) {
    final formatter = NumberFormat.currency(
        //format untuk mata uang
        locale: 'id',
        symbol: 'Rp',
        decimalDigits:
            0); //bagian dari paket intl currency untuk format angka jadi bentuk mata uang
    return formatter.format(jumlah);
  }
