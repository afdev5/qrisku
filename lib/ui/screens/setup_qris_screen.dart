import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qrisku/bloc/default_qris/default_qris_bloc.dart';

class SetupQrisScreen extends StatefulWidget {
  final DefaultQrisBloc bloc;
  const SetupQrisScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<SetupQrisScreen> createState() => _SetupQrisScreenState();
}

class _SetupQrisScreenState extends State<SetupQrisScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: (context, DefaultQrisState state) {
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Informasi'),
                content: Text('${state.message}'),
              ).build(context);
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if(widget.bloc.state.data != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text('Semua data konversi QRIS akan dihapus jika anda mengupdate default QRIS'),
                          actions: [
                            // The "Yes" button
                            TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Batal', style: TextStyle(color: Color(0xfff11542)),)),
                            TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                  _settingModalBottomSheet();
                                },
                                child: const Text('Hapus', style: TextStyle(color: Colors.black),))
                          ],
                        ).build(context);
                      },
                    );
                  } else {
                    _settingModalBottomSheet();
                  }
                },
                child: const Card(
                  child: ListTile(
                    leading: Icon(Icons.qr_code_scanner_outlined,
                        color: Color(0xfff11542)),
                    title: Text('Setup Default QRIS'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outlined, color: Color(0xfff11542)),
                  title: Text('Tentang Aplikasi'),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 6,
                width: 50,
                margin: EdgeInsets.only(top: 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Kamera'),
                onTap: () async {
                  _scan();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Galeri'),
                onTap: () async {
                  await _imgScan();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      Navigator.pop(context);
      if(result != null) {
        widget.bloc.add(AddDefaultQris(data: result.rawContent));
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(ResultType.Error.name),
            content: Text(e.code == BarcodeScanner.cameraAccessDenied
                ? 'The user did not grant the camera permission!'
                : 'Unknown error: $e'),
          ).build(context);
        },
      );

    }
  }

  Future _imgScan() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
    if (image == null) return;
    final rest = await FlutterQrReader.imgScan(image.path);
    widget.bloc.add(AddDefaultQris(data: rest));
  }
}
