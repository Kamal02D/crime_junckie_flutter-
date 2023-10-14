import 'package:poducts/models/PodcastModel.dart';
import 'package:poducts/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as dev show log;
class DataBaseService{
  static DataBaseService? _dataBaseService;
  static  Database? _db;
  DataBaseService._();

  factory DataBaseService.create(){
      _dataBaseService ??= DataBaseService._();
      return  _dataBaseService!;
  }

  Future<void> open() async{ // first function that should be called
      if(_db == null) {
        dev.log("initializing database : should be called once");
        final dbPath = await getDatabasesPath();
        final String dbFullPath = join(dbPath, Constants.DATA_BASE.NAME);
         _db = await openDatabase(dbFullPath);
      }
      //await _db!.execute("drop table ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.NAME}");
      await _createTableIfFirstTime();
  }

  Future<void> _createTableIfFirstTime() async{
     final String query = """
     CREATE TABLE IF NOT EXISTS ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.NAME}(
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.DB_ID}  integer NOT NULL PRIMARY key,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.ID}  Text not NULL,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.TITLE}  Text NOT NULL,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.DESCRIPTION}  Text Not Null,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PUBLICATION_DATE}  Datetime NOt Null,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.LINK}  Text Not NUll,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_LINK}  Text Not NUll,
        ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_DURATION}  int Not NULL,${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PLAYED_DURATION}  int Not NULL
      );
     """;
     await _db!.execute(query);
  }


  Future<List<Podcast>> getAll() async{
    if(_db == null || !_db!.isOpen){
      throw DataBaseNotOpend();
    }
    final String query = """
    select *
    from ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.NAME}
    """;
    final results = await _db!.rawQuery(query);
    List<Podcast> out  = [];
    for (var res in results){
        //print("$res");
        final currentPodcast  = Podcast.fromMap(res);
        out.add(currentPodcast);
    }
    dev.log("${out.length} podcast data were loaded locally");
    return out;
  }

  Future<int> insert(Podcast podcast) async{
    if(_db == null || !_db!.isOpen){
      throw DataBaseNotOpend();
    }
    final query = """
     INSERT INTO ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.NAME}
     ('${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.ID}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.TITLE}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.LINK}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PUBLICATION_DATE}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_DURATION}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_LINK}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.DESCRIPTION}',
      '${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PLAYED_DURATION}'
     )
     VALUES (
      '${podcast.id}',
      '${podcast.title.replaceAll("'", "''")}',
      '${podcast.link.replaceAll("'", "''")}',
      '${podcast.publicationDate}',
      '${podcast.audioDuration.inSeconds}',
      '${podcast.audioLink.replaceAll("'", "''")}',
      '${podcast.description.replaceAll("'", "''")}',
      '${podcast.palyedDuration.inSeconds}'
     );
    """;

    final insertedId = await _db!.rawInsert(query);
    if (insertedId == 0){
      dev.log("could not insert this query  : ${query}");
    }
    return insertedId;
  }

  Future<void> updatePlayedDuration(Duration playedDuration,String url) async{
    final query = """
    UPDATE ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.NAME}
    SET ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.PLAYED_DURATION} = ${playedDuration.inSeconds}
    WHERE ${Constants.DATA_BASE.TABLES.PODCAST_TABLE.COLUMNS.AUDIO_LINK} = '$url'
    """;
    final updated = await _db!.rawUpdate(query);
    if(updated != 1){
      throw Exception('updated more then one ');
    }
  }

}


class DataBaseNotOpend implements Exception{

}