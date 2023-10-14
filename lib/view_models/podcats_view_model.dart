// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:poducts/models/PodcastModel.dart';
import 'package:poducts/models/database_service.dart';
import 'package:poducts/models/http_service.dart';
import 'package:poducts/utils/enums.dart';
import 'package:poducts/utils/xml_parser.dart';
import 'dart:developer' as dev show log;

class PodcastViewModel extends ChangeNotifier{
     late bool _firstCall;
     bool get getFirstCall => _firstCall;

     late bool _isLoading;
     bool get getIsLoading => _isLoading;
     late AppErrors _error = AppErrors.NO_ERROR;
     AppErrors get getError => _error;
     late List<Podcast> _podcasts;


     // services
     late final HttpService _httpService;
     late final DataBaseService _dataBaseService;


     PodcastViewModel() {
          dev.log("inting the view model ---------");
          //services
          _httpService = HttpService.create();
          _dataBaseService = DataBaseService.create();
          // properties
          _error = AppErrors.NO_ERROR;
          _isLoading = true;
          _podcasts = [];
          _firstCall=true;
     }


     Future<void> getData() async{
          _firstCall = false;
          _isLoading = true;
          _error = AppErrors.NO_ERROR;
          notifyListeners();

          dev.log("get data called");
          List<Podcast>? localData;
          try {
               try {
                    localData = await _dataBaseService.getAll();
               } on DataBaseNotOpend catch (_) {
                    dev.log("database not opened : opening db");
                    await _dataBaseService.open();
                    localData = await _dataBaseService.getAll();
               }
          }catch (_){
               dev.log("two times not able to open db");
          }

          if(localData == null){
               _isLoading = false;
               _error = AppErrors.UNABLE_TO_LOAD_DATA_LOCALLY;
               notifyListeners();
               return Future.value();
          }
          _podcasts.addAll(localData);
          if(getDataCount() != 0){ // if when store at least one element wil dispaly it if not then  load them onlien
               notifyListeners();
          }
          final xml = await _httpService.fetchData();

          if (xml == null){
                 _isLoading = false;
                 _error = AppErrors.UNABLE_TO_LOAD_DATA;
                 notifyListeners();
                 return Future.value();
          }

          final podcastStream = getPodacts(xml);
          dev.log("start loading podcasts");
          podcastStream.listen((podcast) async {
               final podcastIndex = _podcasts.indexOf(podcast);
               if (podcastIndex == -1){
                     dev.log("podcast with id ${podcast.id} is new");
                    _podcasts.add(podcast);
                    await _dataBaseService.insert(podcast);
               }
          }
          ).onDone(() {
               _error = AppErrors.NO_ERROR;
               _isLoading = false;
               notifyListeners();
               dev.log("done loading ...");
               notifyListeners();
          });
     }



     int getDataCount() => _podcasts.length;

     String getTitleByIndex(int index){
          return _podcasts[index].title;
     }

     String getDescriptionByIndex(int index){
          return _podcasts[index].description;
     }
     DateTime getPublicationDateByIndex(int index){
          return _podcasts[index].publicationDate;
     }
     Duration getDurationByIndex(int index){
          return _podcasts[index].audioDuration;
     }
     String getIdByIndex(int index){
          return _podcasts[index].id;
     }
     String getAudioLinkByIndex(int index) {
          return _podcasts[index].audioLink;
     }

     Duration getPlayedDurationByIndex(index) {
          return _podcasts[index].palyedDuration;
     }
}