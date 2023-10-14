String  getDurationToDisplay(DateTime publicationDate){
  final currentDateTime = DateTime.now();
  final Duration diff = currentDateTime.difference(publicationDate);
  // minutes hours days months years
  int diffInMinutes = diff.inMinutes;
  if(diffInMinutes < 1){
    diffInMinutes = 1;
  }else if(diffInMinutes<60){
     return "$diffInMinutes Minutes ago";
  }else{
     final diffInHours = diff.inHours;
     if (diffInHours < 24){
        return "$diffInHours Hours ago";
     }else{
       final diffInDays = diff.inDays;
       if(diffInDays < 30){
         return "$diffInDays days ago";
       }else{
          final diffMonths =  (diffInDays/30).round();
          if(diffMonths<12){
             return "$diffMonths Months ago";
          }else{
            final years = (diffMonths/12).floor();
            final months = diffMonths-12*years;
            return "$years Years ago and $months Months ago" ;
          }
       }
     }
  }
  return "0 days ago";
}