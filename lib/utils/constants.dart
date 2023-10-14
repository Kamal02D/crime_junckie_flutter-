import 'package:poducts/utils/enums.dart';

abstract class Constants{
  static const  String URL = "https://feeds.simplecast.com/qm_9xx0g";
  static   DataBaseConstants DATA_BASE = DataBaseConstants();
}

class DataBaseConstants{
   final String NAME = "podcasts_db";
   final Tables TABLES = Tables();
   DataBaseConstants();
}

class Tables{
   final PodcastTable PODCAST_TABLE = PodcastTable();
}
class PodcastTable{
    final NAME = "podcast";
    final PodcastTableColumns COLUMNS = PodcastTableColumns();
}
class PodcastTableColumns{
    final String DB_ID = "dbId";
    final String ID = "id";
    final String TITLE = "title";
    final String DESCRIPTION = "description";
    final String PUBLICATION_DATE = "publicationDate";
    final String LINK = "link";
    final String AUDIO_LINK = "audioLink";
    final String AUDIO_DURATION = "audioDuration";
    final String PLAYED_DURATION = "palyedDuration";
}
