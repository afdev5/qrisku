part of 'default_qris_bloc.dart';

@immutable
abstract class DefaultQrisEvent {}

class GetDefaultQris extends DefaultQrisEvent {
}

class AddDefaultQris extends DefaultQrisEvent {
  final String data;
  AddDefaultQris({required this.data});
}

class DeleteDefaultQris extends DefaultQrisEvent {
  final int id;
  DeleteDefaultQris({required this.id});
}
