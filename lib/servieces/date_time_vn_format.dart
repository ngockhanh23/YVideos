
import 'package:intl/intl.dart';

class DateTimeVNFormat{
  static String formatDate(DateTime dateTime) {
    return DateFormat('HH:mm  dd/MM/yyyy').format(dateTime);
  }
}