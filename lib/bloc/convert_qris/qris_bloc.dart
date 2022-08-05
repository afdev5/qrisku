import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:qrisku/models/convert_qris_model.dart';
import 'package:qrisku/service/object_box.dart';
import 'package:get/get.dart';
import 'package:qrisku/service/qris_service.dart';

part 'qris_event.dart';

part 'qris_state.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  final ObjectBox service = Get.find();

  QrisBloc() : super(QrisState(datas: [])) {
    on<QrisEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is GetAllQris) {
        try {
          emit(state.copyWith(isLoading: true));
          var datas = await service.getDatas();
          emit(state.copyWith(
              datas: event.isFromHome ? datas.take(3).toList() : datas,
              isLoading: false)); // jika dari home screen hanya ambil 3 data
        } catch (e) {
          debugPrint('Error Get All Qris -> $e');
          emit(state.copyWith(
              isLoading: false,
              isError: true,
              message: 'Terjadi kesalahan, coba lagi'));
        }
      } else if (event is AddQris) {
        emit(state.copyWith(isLoading: true));
        var qrDefault = await service.getDefaultQris()?.defaultCode;
        var qrData = await QrisService().convertQris(
            qris: qrDefault!,
            nominal: event.nominal,
            fee: event.fee,
            taxIsPercent: event.taxIsPercent);
        var nominal = event.fee != null
            ? event.taxIsPercent
                ? (double.parse(event.nominal) +
                        (double.parse(event.fee!.isNotEmpty ? event.fee! : '0')) * double.parse(event.nominal) / 100)
                    .toString()
                : (double.parse(event.nominal) +
                        double.parse(event.fee!.isNotEmpty ? event.fee! : '0'))
                    .toString()
            : event.nominal;
        await service.insertData(ConvertQrisModel(
            dataQr: qrData,
            nominal: nominal,
            dateTime: DateTime.now(),
            title: ''));
        var datas = await service.getDatas();
        emit(state.copyWith(
            datas: datas, isLoading: false, message: 'Berhasil;@$qrData'));
        try {} catch (e) {
          debugPrint('Error Add Qris -> $e');
          emit(state.copyWith(
              isLoading: false,
              isError: true,
              message: 'Terjadi kesalahan, coba lagi'));
        }
      } else if (event is DeleteQris) {
        try {
          emit(state.copyWith(isLoading: true));
          await service.deleteData(event.id);
          var datas = await service.getDatas();
          emit(state.copyWith(datas: datas, isLoading: false));
        } catch (e) {
          debugPrint('Error Delete Qris -> $e');
          emit(state.copyWith(
              isLoading: false,
              isError: true,
              message: 'Terjadi kesalahan, coba lagi'));
        }
      }
    });
  }
}
