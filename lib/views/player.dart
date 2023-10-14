import 'package:flutter/cupertino.dart';
import 'package:poducts/utils/duration_formater.dart';
import 'package:flutter/material.dart';
import 'package:poducts/view_models/player_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev show log;


class PodcastPlayerView extends StatefulWidget {
  PodcastPlayerView(
      {Key? key,
      required this.audioLink,
      required this.audioDuration,
      required this.palyedDuration,
        required this.audioTitle,})
      : super(key: key);

  final String audioLink;
  final Duration audioDuration;
  final Duration palyedDuration;
  final String audioTitle;

  @override
  State<PodcastPlayerView> createState() => _PodcastPlayerViewState();
}

class _PodcastPlayerViewState extends State<PodcastPlayerView> {
  PlayersViewModel? pvm;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayersViewModel>(
        create: (context) => PlayersViewModel(),
        child: Consumer<PlayersViewModel>(
          builder: (context, model, child) {
            Provider.of<PlayersViewModel>(context);
            pvm = model;
            if (!model.isInitialized()) {
              model.initialize(widget.audioDuration, widget.palyedDuration,
                  widget.audioLink,widget.audioTitle);
            }
            dev.log("currently playing :${PlayersViewModel.currentlyPlaying}");
            if(PlayersViewModel.currentlyPlaying != widget.audioLink && model.isPlaying()){
              model.pause(directlyPaused:false);
              dev.log("stopping one");
            }

            return Column(
              children: [
                Slider(
                    min: 0,
                    max: model.getAudioDuration().inSeconds.toDouble(),
                    value: model.getPlayedDuration().inSeconds.toDouble(),
                    onChanged: (value) {
                      dev.log("--- value changed");
                      model.setPlayedDuration(Duration(seconds: value.toInt()));
                    }),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(model
                            .getPlayedDuration()
                            .getFormatedDurationInMinutesAndSeconds()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(model
                            .getAudioDuration()
                            .getFormatedDurationInMinutesAndSeconds()),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.replay_10_outlined,
                          size: 40,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          model.seekBackward();
                        },
                      ),
                      (() {
                        if (!model.isPlaying()) {

                          return IconButton(
                            icon: const Icon(
                              Icons.play_circle,
                              size: 50,
                              color: Colors.purple,
                            ),
                            onPressed: () {
                              model.resume();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(
                              Icons.pause,
                              size: 50,
                              color: Colors.purple,
                            ),
                            onPressed: () {
                              model.pause(directlyPaused: true);
                            },
                          );
                        }
                      }()),
                      IconButton(
                        icon: const Icon(
                          Icons.forward_10_outlined,
                          size: 40,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          model.seekForward();
                        },
                      ),
                    ]),
              ],
            );
          },
        ));
  }

  @override
  void dispose() async {
    await pvm!.disposePlayer();
    super.dispose();
  }
}
