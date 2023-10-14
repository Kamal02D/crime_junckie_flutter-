import 'package:flutter/material.dart';
import 'package:poducts/utils/calculate_duartion_passed.dart';
import 'package:poducts/views/player.dart';


class ListViewItem extends StatefulWidget {
  const ListViewItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.publicationDate,
      required this.audioDuration,
      required this.audioLink,
        required this.playedDuration,})
      : super(key: key);

  // required fields
  final String id;
  final String title;
  final String description;
  final DateTime publicationDate;
  final Duration audioDuration;
  final String audioLink;
  final Duration playedDuration;
  @override
  State<ListViewItem> createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: const Color(0XFF191538),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(widget.title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              Text(widget.description,
                  style: const TextStyle(
                      color: Color(0xFFACA7C7), fontStyle: FontStyle.italic)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: PodcastPlayerView(
                    audioLink: widget.audioLink,
                    audioDuration: widget.audioDuration,
                    palyedDuration: widget.playedDuration,
                    audioTitle: widget.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      getDurationToDisplay(widget.publicationDate),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF494059)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
