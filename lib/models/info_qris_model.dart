import 'package:objectbox/objectbox.dart';

@Entity()
class InfoQrisModel {
  int id;
  final String idQris;
  final String nmId;
  final String merchantName;
  final String pencetak;
  final String? nns;
  final String crc;
  final String defaultCode;

  InfoQrisModel({
    this.id = 0,
    required this.crc,
    required this.idQris,
    required this.merchantName,
    required this.nmId,
    required this.nns,
    required this.pencetak,
    required this.defaultCode
  });
}