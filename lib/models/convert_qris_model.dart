import 'package:objectbox/objectbox.dart';

@Entity()
class ConvertQrisModel {
  int id = 0;
  final DateTime dateTime;
  final String? title;
  final String nominal;
  final String dataQr;

  ConvertQrisModel(
      {
      required this.dateTime,
      required this.title,
      required this.nominal,
      required this.dataQr});
}
