// convert a DateTime to a string in format - yyyy/mm/dd

String convertDateTimeToString(DateTime dateTime)
{
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();
  if(month.length == 1)
  {
    // add a zero if its a single digit month
    month = '0$month';
  }

  String day = dateTime.day.toString();
  if(day.length == 1)
  {
    // add a zero if its a single digit day
    day = '0$day';
  }

  String yyyymmdd = '$year/$month/$day';

  return yyyymmdd;
}