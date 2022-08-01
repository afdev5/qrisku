import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrisku/bloc/convert_qris/qris_bloc.dart';
import 'package:qrisku/ui/widgets/card_history.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final QrisBloc _qrisBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff11542).withOpacity(0.8),
        title: const Text('Riwayat Generate QRIS'),
      ),
      body: BlocBuilder(
        bloc: _qrisBloc,
        builder: (context, QrisState state) {
          if(state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if(state.isError) {
            return Center(child: Text('${state.message}'));
          } else {
            if(state.datas.isEmpty) {
              return const Center(child: Text('Tidak ada data'));
            }
            return Container(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                  itemCount: state.datas.length,
                  itemBuilder: (context, index) {
                    var data = state.datas[index];
                    return CardHistory(
                      dataQr: data.dataQr,
                      title: data.nominal,
                      subTitile: data.title,
                      dateTime: '${data.dateTime.day}-${data.dateTime.month}-${data.dateTime.year} ${data.dateTime.hour}:${data.dateTime.minute}',
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
