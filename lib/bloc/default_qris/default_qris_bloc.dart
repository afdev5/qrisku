
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrisku/models/info_qris_model.dart';
import 'package:qrisku/service/object_box.dart';
import 'package:qrisku/service/qris_service.dart';

part 'default_qris_event.dart';
part 'default_qris_state.dart';

class DefaultQrisBloc extends Bloc<DefaultQrisEvent, DefaultQrisState> {
  final ObjectBox service = Get.find();
  DefaultQrisBloc() : super(DefaultQrisState()) {
    on<DefaultQrisEvent>((event, emit) async {
      // TODO: implement event handler
      if(event is GetDefaultQris) {
        try {
          emit(state.copyWith(isLoading: true));
          var data = await service.getDefaultQris();
          emit(state.copyWith(data: data, isLoading: false)); // jika dari home screen hanya ambil 3 data
        } catch(e) {
          debugPrint('Error Get All Qris -> $e');
          emit(state.copyWith(isLoading: false, isError: true, message: 'Terjadi kesalahan, coba lagi'));
        }
      } else if(event is AddDefaultQris) {
        try {
          emit(state.copyWith(isLoading: true));
          InfoQrisModel info = await QrisService().getInfoQris(event.data);
          if(info.merchantName.isEmpty || info.pencetak.isEmpty || info.idQris.isEmpty || info.nmId.isEmpty) {
            emit(state.copyWith(isLoading: false, isError: true, message: 'QRIS tidak sesuai, coba lagi'));
          } else {
            var id = await service.insertDefaultQris(info);
            var data = await service.getDefaultQris();
            emit(state.copyWith(data: data, isLoading: false, message: 'Berhasil menambahkan default QRIS'));
          }
        } catch(e) {
          debugPrint('Error Add Qris -> $e');
          emit(state.copyWith(isLoading: false, isError: true, message: 'Terjadi kesalahan, coba lagi'));
        }
      } else if(event is DeleteDefaultQris) {
        try {
          emit(state.copyWith(isLoading: true));
          await service.deleteData(event.id);
          var data = await service.getDefaultQris();
          emit(state.copyWith(data: data, isLoading: false));
        } catch(e) {
          debugPrint('Error Delete Qris -> $e');
          emit(state.copyWith(isLoading: false, isError: true, message: 'Terjadi kesalahan, coba lagi'));
        }
      }
    });
  }
}
