import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrisku/ui/screens/qris_screen.dart';


class CardHistory extends StatelessWidget {
  final String? title;
  final String? subTitile;
  final String? dateTime;
  final String dataQr;

  const CardHistory({this.title, this.dateTime, this.subTitile, required this.dataQr});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QrisScreen(data: dataQr)));
      },
      child: Card(
        child: ListTile(
          // isThreeLine: true,
          title: Text(
            '${CurrencyFormat().convertToIdr(double.parse(title ?? '0'), 0)}',
            style: const TextStyle(color: Color(0xff0f1735), fontWeight: FontWeight.bold),
          ),
          leading: const Icon(Icons.qr_code_2),
          subtitle: Text('$subTitile'),
          trailing: Text('$dateTime'),
        ),
      ),
    );
  }
}


class CurrencyFormat {
  String convertToIdr(double number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}