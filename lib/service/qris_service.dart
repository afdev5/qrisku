import 'package:qris/qris.dart';
import 'package:qrisku/models/info_qris_model.dart';

class QrisService {
  Future<String> convertQris(
      {required String qris,
      required String nominal,
      String? fee,
      bool taxIsPercent = false}) async {
    // tax type r/p, r = rupiah, p = persen
    var result = '';
    var tax = '';
    var qris2 =
        qris.substring(0, qris.length - 4); // to delete default crc in qris
    var replaceQris = qris2.replaceAll(
        "010211", "010212"); // update code from static to dynamic qris
    var splitQris = replaceQris.split("5802ID"); // split code for modify
    var money = "54" + pad(nominal.length) + nominal; // code for format money
    tax = fee == null || fee.isEmpty
        ? ''
        : taxIsPercent // to check convert with fee or not
            ? "55020357" +
                pad(fee.length) +
                fee // 55020357 code for fee with format percent
            : "55020256" +
                pad(fee.length) +
                fee; // 55020256 code for fee with format rupiah
    money +=
        tax.isEmpty ? "5802ID" : tax + "5802ID"; // final format code for money
    var output = splitQris[0].trim() +
        money +
        splitQris[1].trim(); // to combine default code and modify code
    output += toCRC16(output); // to add crc in modify code
    result = output; // final code modify
    return result;
  }

  // Future<InfoQrisModel> getInfoQris(String val) async {
  //   var dumpNmid = getBetween(val, "15ID", "0303");
  //   var nmId = "ID" + dumpNmid;
  //   var searchId = RegExp('A01').stringMatch(val);
  //   var id = searchId == null ? "01" : "A01";
  //   var merchantName =
  //       getBetween(val, "ID59", "60").substring(2).trim().toUpperCase();
  //   var regexPencetak = RegExp('(?<=ID|COM).+?(?=0118)');
  //   var getPencetak = regexPencetak.stringMatch(val);
  //   var jmlPencetak = getPencetak?.split('.');
  //   var pencetak =
  //       jmlPencetak?.length == 3 ? jmlPencetak![1] : jmlPencetak?.last;
  //   var regexNns = RegExp('(?<=0118).+?(?=ID)');
  //   var getNns = regexNns.stringMatch(val);
  //   var strnoncrc = val.substring(0, val.length - 4);
  //   var crc = val.substring(val.length - 4);
  //   var getCrc = toCRC16(strnoncrc);
  //   var cekCrc = (crc == getCrc);
  //   return InfoQrisModel(
  //       defaultCode: val,
  //       crc: crc,
  //       idQris: id,
  //       merchantName: merchantName,
  //       nmId: nmId,
  //       nns: getNns,
  //       pencetak: pencetak ?? '');
  // }

  Future<InfoQrisModel> getInfoQris(String val) async {
    var dumpNmid = getBetween(val, "15ID", "0303");
    var nmId = "ID" + dumpNmid;
    var searchId = RegExp('A01').stringMatch(val);
    var id = searchId == null ? "01" : "A01";
    var merchantName =
    getBetween(val, "ID59", "60").substring(2).trim().toUpperCase();
    var regexPencetak = RegExp('(?<=ID|COM).+?(?=0118)');
    var getPencetak = regexPencetak.stringMatch(val);
    var jmlPencetak = getPencetak?.split('.');
    var pencetak =
    jmlPencetak?.length == 3 ? jmlPencetak![1] : jmlPencetak?.last;
    var regexNns = RegExp('(?<=0118).+?(?=ID)');
    var getNns = regexNns.stringMatch(val);
    var strnoncrc = val.substring(0, val.length - 4);
    var crc = val.substring(val.length - 4);
    var getCrc = toCRC16(strnoncrc);
    var cekCrc = (crc == getCrc);
    final qris = QRIS(val);
    // print('${qris.merchantName}, ${qris.rawMapData} , ${qris.merchantAccountDomestic?.merchantID}');
    final newPencetak = qris.merchants.first.globallyUniqueIdentifier?.replaceAll('ID', '').replaceAll('CO', '').replaceAll('WWW', '').replaceAll('.', '');
    return InfoQrisModel(
        defaultCode: val,
        crc: crc,
        idQris: id,
        merchantName: qris.merchantName ?? merchantName,
        nmId: qris.merchantAccountDomestic?.merchantID?.toString() ?? nmId,
        nns: getNns,
        pencetak: newPencetak ?? pencetak ?? '');
  }

  String toCRC16(String val) {
    var crc = 0xFFFF;
    for (var c = 0; c < val.length; c++) {
      crc ^= val.codeUnitAt(c) << 8;

      for (var i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc = crc << 1;
        }
      }
    }
    var hex = crc & 0xFFFF;
    var fixCrc16 = hex.toRadixString(16);
    if (fixCrc16.length == 3) {
      fixCrc16 = "0" + fixCrc16;
    }
    return fixCrc16.toUpperCase();
  }

  String pad(int d) {
    return d < 10 ? '0' + d.toString() : d.toString();
  }

  String getBetween(String val, String start, String end) {
    final startIndex = val.indexOf(start);
    final endIndex = val.indexOf(end, startIndex + start.length);
    return val.substring(startIndex + start.length, endIndex);
  }
}
