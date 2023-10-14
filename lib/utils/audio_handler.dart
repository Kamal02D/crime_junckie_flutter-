import 'package:audio_service/audio_service.dart';
import 'dart:developer' as dev show log;

import 'package:audioplayers/audioplayers.dart';


class MyAudioHandler extends BaseAudioHandler
    with QueueHandler, // mix in default queue callback implementations
        SeekHandler { // mix in default seek callback implementations

    int id = 0;
    void Function(bool dd)? _changePlayStateCallBack;
    AudioPlayer? _player;
  // The most common callbacks:

  void setMediaItem(String title,Duration audioDuration,Duration played,AudioPlayer player,void Function(bool dd) changePlayStateCall){
      dev.log("title received $title");
      final item = MediaItem(
        id: (++id).toString(),
        title: title,
        duration: audioDuration,
      );

     mediaItem.add(item);

      playbackState.add(PlaybackState(
        processingState: AudioProcessingState.loading,
        // Whether audio is playing
        playing: false,
        updatePosition: played,
      ));

      //_playerViewModel!.changePlayState(true);
      _player = player;
      _changePlayStateCallBack = changePlayStateCall;
  }

  @override
  Future<void> play()async {
      dev.log("0000000000000000000000000000000000000000000000000000000000000000000000000");
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.ready,
          playing: true,
          controls: [
            MediaControl.pause,
            MediaControl.stop
          ],
        ),
      );
      _player!.resume();
      _changePlayStateCallBack!(true);
    dev.log("supposedly played");
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
      updatePosition: playbackState.value.position,
    ));
    _player!.pause();
    _changePlayStateCallBack!(false);
    dev.log("pause is called");
  }

  Future<void> updatePosition(Duration newDuration)async {
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: newDuration,
        )
      );
  }
  @override
  Future<void> stop() async {
    dev.log("stop is called");
  }
  @override
  Future<void> seek(Duration position) async {
     dev.log("seek is called");
  }
  @override
  Future<void> skipToQueueItem(int index) async {
       dev.log("seek is called");
  }
}