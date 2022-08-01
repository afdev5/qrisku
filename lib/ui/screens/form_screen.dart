import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qrisku/bloc/convert_qris/qris_bloc.dart';
import 'package:qrisku/ui/screens/qris_screen.dart';
import 'package:qrisku/ui/widgets/card_background_with_text_dot.dart';
import 'package:qrisku/ui/widgets/custom_switch.dart';
import 'package:qrisku/ui/widgets/custom_text_form_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController _nominal = TextEditingController(text: '');
  TextEditingController _tax = TextEditingController(text: '');
  bool _taxIsPercent = false;
  final QrisBloc _qrisBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _qrisBloc,
      listener: (context, QrisState state) {
        if(state.isLoading) {
          showDialog(
              context: context,
              builder: (context) {
                return CircularProgressIndicator();
              }
          );
        } else if(state.isError) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('${state.message}'),
              ).build(context);
            },
          );
        } else {
          Navigator.pop(context);
          if(state.message != null && state.message!.contains('Berhasil')) {
            var data = state.message!.split(';@').last;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QrisScreen(data: data)));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff11542).withOpacity(0.8),
          title: Text('Konversi QRIS'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CardBackgroundWithTextDot(
                    title: 'Jumlah Uang',
                    borderColor: Color(0xff0f1735),
                    textBorderColor: Color(0xff0f1735),
                    dotColor: Colors.red,
                    widget: TextFieldWithoutBorder(
                      initialValue: _nominal.text,
                      keyboardType: TextInputType.number,
                      hintText: 'Rp. 0',
                      onChanged: (value) {
                        _nominal.text = value;
                      },
                    )),
                SizedBox(height: 16),
                CardBackgroundWithTextDot(
                    title: 'Biaya / Pajak',
                    borderColor: Color(0xff0f1735),
                    textBorderColor: Color(0xff0f1735),
                    dotColor: Colors.grey,
                    widget: TextFieldWithoutBorder(
                      initialValue: _tax.text,
                      keyboardType: TextInputType.number,
                      hintText: _taxIsPercent ? '0' : 'Rp. 0',
                      onChanged: (value) {
                        _tax.text = value;
                      },
                    )),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Biaya / Pajak dalam (%)'),
                    SizedBox(width: 12),
                    CustomRollingSwitch(
                      iconOff: Icons.close,
                      iconOn: Icons.check,
                      colorOff: Colors.grey,
                      colorOn: Color(0xfff11542),
                      onChanged: (val) {
                        setState(() {
                          _taxIsPercent = val;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 52,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xfff11542).withOpacity(0.9)),
                      onPressed: () {
                        if(_nominal.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text('Error'),
                                content: Text('Nominal tidak boleh kosong'),
                              ).build(context);
                            },
                          );
                        } else {
                          _qrisBloc.add(AddQris(nominal: _nominal.text, taxIsPercent: _taxIsPercent, fee: _tax.text));
                        }
                      },
                      child: Text("Generate QRIS")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
