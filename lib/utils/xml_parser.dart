import 'dart:async';

import 'package:poducts/models/PodcastModel.dart';
import 'package:xml/xml.dart';
import 'dart:developer' as dev show log;
import 'package:intl/intl.dart';

Stream<Podcast> getPodacts(String xml) async*{
    var podcastController = StreamController<Podcast>();
    final document  = XmlDocument.parse(xml);
    final items = document.findAllElements("item");
    for (var item in items){
        //dev.log("item reading ...${item.toString()}");
        //final String id = item.getElement("guid")!.innerText;
        final  id = item.getElement("guid")!.innerText;
        final String title = item.getElement("title")!.innerText;
        final String  description = item.getElement("itunes:summary")!.innerText;
        final DateTime publicationDate = parsePubDate(item.getElement("pubDate")!.innerText);
        final String link = item.getElement("link")!.innerText;
        final String  audioLink = item.getElement("enclosure")!.getAttribute("url")!;
        final Duration audioDuration = textToDuration(item.getElement("itunes:duration")!.innerText);
        final Podcast current = Podcast(id, title, description, publicationDate, link,audioLink, audioDuration,const Duration(seconds: 0));
        podcastController.add(current);
        yield current;
    }
    podcastController.close();
}

Duration textToDuration(String s) {
  //  expected example : 00:48:49
  final List<String> hms = s.split(":");
  return Duration(hours: int.parse(hms[0]), minutes: int.parse(hms[1]), seconds: int.parse(hms[2]));
}

DateTime parsePubDate(String dateString ){
    DateFormat inputFormat = DateFormat("E, d MMM yyyy HH:mm:ss Z");
    return inputFormat.parse(dateString);
}