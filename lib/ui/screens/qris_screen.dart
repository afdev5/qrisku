import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:qrisku/bloc/default_qris/default_qris_bloc.dart';
import 'package:qrisku/models/convert_qris_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class QrisScreen extends StatefulWidget {
  final String data;
  const QrisScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<QrisScreen> createState() => _QrisScreenState();
}

class _QrisScreenState extends State<QrisScreen> {
  final DefaultQrisBloc _defaultQrisBloc = Get.find();
  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff11542).withOpacity(0.8),
        title: const Text('QRIS'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _imageQris(_size),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 85,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Color(0xff0f1735)),
                      onPressed: () async {
                        PermissionStatus permission = await Permission.storage.request();
                        if (permission == PermissionStatus.granted) {
                          final _capture = await screenshotController.capture();
                          if(_capture != null) {
                            final _directory = await getTemporaryDirectory();
                            final _file = await File('${_directory.path}/qris.png').create();
                            await _file.writeAsBytes(_capture);
                            final result = await ImageGallerySaver.saveFile(_file.path);
                            if(result['isSuccess']) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Berhasil mengunduh gambar qris'),
                                  ).build(context);
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Gagal mengunduh gambar qris'),
                                  ).build(context);
                                },
                              );
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text('Akses ke gallery harus diijinkan'),
                              ).build(context);
                            },
                          );
                        }
                      },
                      child: Icon(Icons.download_outlined)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 130,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Color(0xfff11542).withOpacity(0.9)),
                      onPressed: () async {
                        final _capture = await screenshotController.capture();
                        if(_capture != null) {
                          final _directory = await getTemporaryDirectory();
                          final _file = await File('${_directory.path}/qris.png').create();
                          await _file.writeAsBytes(_capture);
                          await Share.shareFiles([_file.path]);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 12),
                          Text("Bagikan QRIS"),
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _imageQris(Size _size) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        height: _size.height / 1.5,
        width: _size.width,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/template.png',
              fit: BoxFit.fill,
            ),
            Center(
              child: QrImage(
                data: widget.data,
                version: QrVersions.auto,
                size: 200.sp,
              ),
            ),
            Positioned(
              left: 1,
              right: 1,
              top: 85,
              child: Column(
                children: [
                  Text(_defaultQrisBloc.state.data?.merchantName ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 6),
                  Text('NMID : ${_defaultQrisBloc.state.data?.nmId ?? ''}'),
                  SizedBox(height: 6),
                  Text(_defaultQrisBloc.state.data?.idQris ?? '',)
                ],
              ),
            ),
            Positioned(
                left: 25,
                right: 1,
                bottom: 55,
                child: Text('Dicetak oleh: ${_defaultQrisBloc.state.data?.pencetak ?? ''}')
            )
          ],
        ),
      ),
    );
  }
}
