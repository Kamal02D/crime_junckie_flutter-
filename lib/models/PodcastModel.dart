import 'package:poducts/utils/constants.dart';
class Podcast {
  final String id;
  final String title;
  final String description;
  final DateTime publicationDate;
  final String link;
  final String audioLink;
  final Duration audioDuration;
  Duration palyedDuration;

  Podcast(this.id, this.title, this.description, this.publicationDate, this.link, this.audioLink, this.audioDuration,this.palyedDuration);

  @override
  String toString() {
    return """
    id : $id
    title : $title
    description : $description
    publicationDate : $publicationDate
    link : $link
    audioLink : $audioLink
    audioDuration : $audioDuration
    palyed durartion : $palyedDuration
    """;
  }

  factory Podcast.fromMap(Map<String,Object?> input){
      final String id = input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.ID]!.toString();
      final String title = input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.TITLE]!.toString();
      final String description = input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.DESCRIPTION]!.toString();
      final DateTime publicationDate = DateTime.parse(input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PUBLICATION_DATE]!.toString());
      final String link = input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.LINK]!.toString();
      final String audioLink = input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_LINK]!.toString();
      final Duration audioDuration = Duration(seconds:int.parse(input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_DURATION].toString()));
      final playedDuration = Duration(seconds: int.parse(input[Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PLAYED_DURATION].toString()));
      return Podcast(id, title, description, publicationDate, link,audioLink, audioDuration,playedDuration);
  }

  @override
  bool operator ==(covariant Podcast other) {
      return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
