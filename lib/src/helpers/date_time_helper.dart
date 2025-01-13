import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getFormattedDateTime(Timestamp time){
    return DateFormat.MMMEd().format(time.toDate());
  }


  static String timeAgo(Timestamp from,) {
    DateTime fromDate = from.toDate();
    DateTime toDate = Timestamp.now().toDate();

    Duration difference = toDate.difference(fromDate);

    if (difference.inDays > 0) {
      String days =  difference.inDays.toString();
      return '$days days ago';
    } else if (difference.inHours > 0) {
      String hours = difference.inHours.toString();
      return '$hours h${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      String minutes = difference.inMinutes.toString();
      return '$minutes min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}