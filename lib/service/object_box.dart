import 'dart:io';

import 'package:qrisku/models/convert_qris_model.dart';
import 'package:qrisku/models/info_qris_model.dart';
import 'package:qrisku/objectbox.g.dart';


class ObjectBox {
  late final Store _store;
  late final Box<ConvertQrisModel> _qrisBox;
  late final Box<InfoQrisModel> _defaultQrisBox;

  ObjectBox._init(this._store) {
    _defaultQrisBox = Box<InfoQrisModel>(_store);
    _qrisBox = Box<ConvertQrisModel>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();
    return ObjectBox._init(store);
  }
  ///Default Qris
  InfoQrisModel? getDefaultQris() => _defaultQrisBox.query().build().find().last;

  int insertDefaultQris(InfoQrisModel data) => _defaultQrisBox.put(data);

  Future<int> deleteDefaultQris() async {
    await _defaultQrisBox.removeAll();
    await _qrisBox.removeAll();
    return 0;
  }

  ///Convert Qris
  ConvertQrisModel? getData(int id) => _qrisBox.get(id);

  Future<List<ConvertQrisModel>> getDatas() async {
    var datas = <ConvertQrisModel>[];
    datas = _qrisBox.getAll();
    return datas;
  }
  int insertData(ConvertQrisModel data) => _qrisBox.put(data);

  bool deleteData(int id) => _qrisBox.remove(id);
}