import 'dart:async';


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:poducts/models/database_service.dart';
import 'package:poducts/utils/enums.dart';
import 'package:async/async.dart';
import 'dart:developer' as dev  show log;

import '../main.dart';
class PlayersViewModel extends ChangeNotifier{
  static String currentlyPlaying = "";
  bool _isInited =  false;// change once

   bool _isPlaying = false;
   String _audioLink = "";
   String _audioTitle = "";
   Duration _audioDuration = const Duration(seconds: 0);
   Duration _playedDuration = const Duration(seconds: 0);

   AudioPlayer? _player;
   bool _didSourceSet = false;
   CancelableOperation? _operation;//keep track of the operation and be able to stop them


    // update to db feilds
   Duration? _lastCachedPlayed; // hold the lasplayedDuration uploaded to db : not update if  not changed
    Timer? _regularUpdate;
   AppErrors _error = AppErrors.NO_ERROR;

   DataBaseService? _dataBaseService;

  void initialize(Duration audioDuration, Duration palyedDuration ,String audioLink,String audioTitle){
    if (!_isInited){
          //dev.log("initing palyer view model ... title $audioTitle");
        _isPlaying = false;
        _audioDuration = audioDuration;
        _playedDuration = palyedDuration;
        _audioLink = audioLink;
        _audioTitle = audioTitle;
        _isInited = true;
        _error = AppErrors.NO_ERROR;
        _dataBaseService = DataBaseService.create();
        //AudioLogger.logLevel = AudioLogLevel.none;
        _player = AudioPlayer();
        //AudioLogger.logLevel = AudioLogLevel.none;
        _player!.onPositionChanged.listen((Duration  playedDuration){
            _playedDuration = playedDuration;
            if(_playedDuration.inSeconds != MyApp.audioHandler!.playbackState.value.position.inSeconds){
              dev.log("position is different ${_playedDuration.inSeconds} vs ${MyApp.audioHandler!.playbackState.value.position.inSeconds}");
              MyApp.audioHandler!.updatePosition(_playedDuration);
              dev.log("11111111111111111111111111111111 changing");
            }
            notifyListeners();
        });
    }else{
      throw Exception("should be intied once");
    }
  }

  bool isInitialized(){
    return _isInited;
  }

  Duration getPlayedDuration() {
    return _playedDuration;
  }
  Duration getAudioDuration(){
    return _audioDuration;
  }

  bool isPlaying(){
    return _isPlaying;
  }
  void changePlayState(bool state){
    _isPlaying = state;
    notifyListeners();
  }

  Future<void> resume() async{
      MyApp.audioHandler!.setMediaItem(_audioTitle, _audioDuration,_playedDuration,_player!,changePlayState);
      if(_lastCachedPlayed == null){ // first time playing for  this player

          _dataBaseService!.updatePlayedDuration(_playedDuration,_audioLink);
          _lastCachedPlayed = _playedDuration;
          dev.log("updating [${_playedDuration.inSeconds} was played]");

          // start our listening to changes in the Audio...

          _regularUpdate =Timer.periodic(const Duration(seconds: 5), (timer) {
            dev.log("5 seconds passed");
            if(_playedDuration.inSeconds != _lastCachedPlayed!.inSeconds){
                dev.log("updating in db...");
                _dataBaseService!.updatePlayedDuration(_playedDuration,_audioLink);
                _lastCachedPlayed = _playedDuration;
            }else{
              dev.log("no update");
            }
          });

      }
      // if player service is null => error
      currentlyPlaying = _audioLink;
      changePlayState(true);

      if(!_didSourceSet) {
        dev.log("setting source");
        await _player!.setSourceUrl(_audioLink);
        _didSourceSet = true;
      }
      await _player!.seek(_playedDuration);

      /// the audio handler has version of  our _player we passed it through setMedia function
      /// we gonna let it handel playing
      /// also it has access to the fucntion [changePlayState] to be able to broadcast change to the currentview model
      /// and hence the ui
      MyApp.audioHandler!.play();

  }

  Future<void> pause({required bool directlyPaused}) async{
    /*
    * directlyPaused : indicate whether  the user has paused the by clicking pause (true) ,
    *  or as result of playing other player
    * */
    dev.log("pause --");
    changePlayState(false);
    _regularUpdate!.cancel();
    _lastCachedPlayed = null;

    //_player!.pause().then((value) {
      if (directlyPaused) { // when directly paused  : the notification should broadcast the change , if playing new one the hall notifaction will chnage so no need to pause
        MyApp.audioHandler!.pause();
      }else{
        _player!.pause();
      }
    //},);
  }

  disposePlayer() async {
    dev.log("disposing the player");
    await _player!.dispose();
  }

  void setPlayedDuration(Duration playedDuration) async{
    _playedDuration= playedDuration;
    if(_operation != null){
      dev.log("canceling prev");
      _operation!.cancel();
    }
    _operation = CancelableOperation.fromFuture(_player!.seek(_playedDuration));
  }

  Future<void> seekForward() async{
    _playedDuration = Duration(seconds:_playedDuration.inSeconds+10);
    if(_playedDuration.inSeconds > _audioDuration.inSeconds){
      _playedDuration = _audioDuration;
    }
    if(_operation != null){
      dev.log("canceling prev");
      _operation!.cancel();
    }
    notifyListeners();
    _operation = CancelableOperation.fromFuture(_player!.seek(_playedDuration));
  }

  Future<void> seekBackward() async{
    _playedDuration = Duration(seconds:_playedDuration.inSeconds-10);
    if(_playedDuration.isNegative){
      _playedDuration = const Duration(seconds: 0);
    }
    if(_operation != null){
      dev.log("canceling prev");
      _operation!.cancel();
    }
    notifyListeners();
    _operation = CancelableOperation.fromFuture(_player!.seek(_playedDuration));
  }

}