import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  Helper();

  Future setStorage(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  Future getStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  String timestampToTime(DateTime date) {
    var strDate = new DateFormat.Hm().format(date);

    return strDate;
  }

  String formatNumber(double number, int length) {
    try {
      if (length == 1) {
        var f1 = new NumberFormat('###,##0.0');
        return f1.format(number);
      }
      if (length == 2) {
        var f1 = new NumberFormat('###,##0.00');
        return f1.format(number);
      }
      if (length == 3) {
        var f1 = new NumberFormat('###,##0.000');
        return f1.format(number);
      }

      var f1 = new NumberFormat('###,##0');
      return f1.format(number);
    } catch (error) {
      return '0';
    }
  }
}
