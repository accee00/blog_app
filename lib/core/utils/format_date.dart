import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('d MMM, yyyy').format(date);
}
