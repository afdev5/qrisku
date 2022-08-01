part of 'qris_bloc.dart';

abstract class QrisEvent {}

class GetAllQris extends QrisEvent {
  final bool isFromHome;
  GetAllQris({this.isFromHome = false});
}


class AddQris extends QrisEvent {
  final String nominal;
  final String? fee;
  final bool taxIsPercent;
  AddQris({required this.nominal, required this.taxIsPercent, this.fee});
}

class DeleteQris extends QrisEvent {
  final int id;
  DeleteQris({required this.id});
}
