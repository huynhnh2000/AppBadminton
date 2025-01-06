import 'package:intl/intl.dart';

class AppFormat {

  static String formatPhoneNumberVN(String phoneNumber) {
    // Vietnamese format (e.g., 081 947 1796)
    String phoneFormatted = phoneNumber.replaceAll(" ", "");
    if (phoneFormatted.length == 10) {
      return "${phoneFormatted.substring(0, 3)} ${phoneFormatted.substring(3, 6)} ${phoneFormatted.substring(6)}";
    }
    return phoneFormatted;
  }

  static String formatNumber(String number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(double.parse(number));
  }

  static String formatMoney(String number) {
    double amount = double.parse(number);
    
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      final formatter = NumberFormat('#,##0');
      return formatter.format(amount);
    }
  }

  static String removeParentheses(String name) {
    return name.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
  }

  static String formatDateTime(String date){
    String dateSplit = date.split("T")[0];
    DateTime parsedDate = DateTime.parse(dateSplit);
    String formattedDate = DateFormat("dd/MM/yyyy").format(parsedDate);
    return formattedDate;
  }

}